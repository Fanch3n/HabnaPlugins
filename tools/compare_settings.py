"""Check that a change keeps the settings files compatible.

Runs TitanBar's settings code of a git ref (default: HEAD) and of the working tree
in Lua 5.1 with a stubbed Turbine API, and compares what both save for a few scenarios:
a new character, an existing character with changed values, an incomplete file,
settings changed at runtime, and "Reset all settings".

Requirements: Python 3 with git on the PATH, and the Lua runtime for Python:
    pip install lupa

Usage (from anywhere in the repository):
    python tools/compare_settings.py            # compare HEAD with the working tree
    python tools/compare_settings.py --ref v1.52

Prints the differences per scenario and exits with 1 if there are any.
Differences are not always wrong, e.g. when a default was changed on purpose.
"""
import argparse
import json
import os
import re
import subprocess
import sys

try:
    from lupa import lua51
except ImportError:
    sys.exit("This tool needs the Lua runtime for Python: pip install lupa")

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SETTINGS_NAME = "TitanBarSettingsEN"

# Stubs for everything the settings code needs outside of its own files
PRELUDE = r"""
local function mock()
    return setmetatable({}, {
        __index = function(t, k) local v = mock(); rawset(t, k, v); return v end,
        __call = function() return mock() end,
    })
end
Turbine = mock()
Turbine.DataScope = { Character = "Character", Server = "Server", Account = "Account" }
Turbine.UI.ContentAlignment = { MiddleLeft = "ML", MiddleRight = "MR", MiddleCenter = "MC" }
storage, saved = {}, {}
local function copy(t)
    if type(t) ~= "table" then return t end
    local c = {}; for k, v in pairs(t) do c[k] = copy(v) end; return c
end
Turbine.PluginData = {
    Load = function(scope, name) return copy(storage[name]) end,
    Save = function(scope, name, t) saved[name] = copy(t); storage[name] = copy(t) end,
}
write = function() end
screenWidth, screenHeight = 1920, 1080
GLocale = "en"
PlayerAlign = 1
Version = "test"
AppDirD = "HabnaPlugins.TitanBar."; AppCtrD = AppDirD .. "Control."; AppLocaleD = AppDirD .. "Locale."
_G.FontN = { ["TrajanPro"] = { [14] = 7 } }
_G.FontT = { ["TrajanPro"] = { [14] = 9 } }
ReloadTitanBar = function() end
ShowHideCurrency = function() end
"""


class Variant:
    """The TitanBar files of a git ref, or of the working tree (ref None)."""

    def __init__(self, ref):
        self.ref = ref

    def read(self, path):
        if self.ref is None:
            return open(os.path.join(REPO, "TitanBar", path), encoding="utf-8").read()
        return subprocess.run(["git", "-C", REPO, "show", f"{self.ref}:TitanBar/{path}"],
                              capture_output=True, check=True).stdout.decode("utf-8")

    def control_files(self):
        if self.ref is None:
            names = os.listdir(os.path.join(REPO, "TitanBar", "Control"))
        else:
            out = subprocess.run(["git", "-C", REPO, "ls-tree", "--name-only", f"{self.ref}:TitanBar/Control"],
                                 capture_output=True, check=True).stdout.decode("utf-8")
            names = out.split()
        return sorted("Control/" + n for n in names if n.endswith(".lua"))

    def register_calls(self):
        """The ControlRegistry.Register(...) calls of all control files, as Lua source."""
        calls = []
        for path in self.control_files():
            src = self.read(path)
            for m in re.finditer(r"ControlRegistry\.Register\(", src):
                depth, i = 1, m.end()
                while depth:
                    depth += {"(": 1, ")": -1}.get(src[i], 0)
                    i += 1
                calls.append("_G.ControlRegistry.Register(" + src[m.end():i])
        return calls


def start(variant):
    lua = lua51.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(PRELUDE)
    lua.globals().import_file = lambda p: lua.execute(
        variant.read(p.replace("HabnaPlugins.TitanBar.", "").replace(".", "/") + ".lua"))
    lua.execute("import = function(p) import_file(p) end")
    for path in ["ControlRegistry.lua", "Constants.lua", "Currencies.lua", "settings.lua"]:
        lua.execute(variant.read(path))
    lua.execute("_G.ControlRegistry.InitializeAll(); if Constants.InitializeAlignments then Constants.InitializeAlignments() end")
    return lua


def to_py(obj):
    if type(obj).__name__ == "_LuaTable":
        return {str(k): to_py(v) for k, v in obj.items()}
    return obj


def lua_literal(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    if isinstance(v, str):
        return json.dumps(v)
    if isinstance(v, dict):
        return "{" + ", ".join(f"[{json.dumps(k)}] = {lua_literal(x)}" for k, x in v.items()) + "}"
    raise TypeError(v)


def run(variant, stored, actions):
    """Load the settings like at login, register the controls, run actions, save. Returns both saved files."""
    lua = start(variant)
    if stored is not None:
        lua.execute(f"storage[{json.dumps(SETTINGS_NAME)}] = {lua_literal(stored)}")
    lua.execute("LoadSettings()")
    after_load = to_py(lua.eval("saved")[SETTINGS_NAME])
    for call in variant.register_calls():
        lua.execute(call)
    lua.execute(actions)
    lua.execute("SaveSettings()")
    after_save = to_py(lua.eval("saved")[SETTINGS_NAME])
    return after_load, after_save


def diff(a, b, path=""):
    out = []
    for k in sorted(set(a) | set(b)):
        p = f"{path}.{k}"
        if k not in a:
            out.append(f"  only new: {p} = {b[k]!r}")
        elif k not in b:
            out.append(f"  only old: {p} = {a[k]!r}")
        elif isinstance(a[k], dict) and isinstance(b[k], dict):
            out += diff(a[k], b[k], p)
        elif a[k] != b[k]:
            out.append(f"  {p}: old {a[k]!r}  new {b[k]!r}")
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--ref", default="HEAD", help="git ref to compare the working tree with (default: HEAD)")
    args = parser.parse_args()
    old, new = Variant(args.ref), Variant(None)
    differences = 0

    def scenario(name, stored, actions=""):
        nonlocal differences
        results = [run(old, stored, actions), run(new, stored, actions)]
        print(f"== {name}")
        for i, label in enumerate(("after LoadSettings", "after SaveSettings")):
            d = diff(results[0][i], results[1][i])
            differences += len(d)
            print(f"  {label}: {'identical' if not d else str(len(d)) + ' differences'}")
            for line in d:
                print("  " + line)
        return results

    # 1. new character
    fresh = scenario("new character", None)

    # 2. existing character with non-default values, and a currency only saved under its pre-1.35 name
    existing = json.loads(json.dumps(fresh[0][1]))
    existing["Money"].update({"S": True, "SS": False, "X": "777"})
    existing["BagInfos"].update({"U": False, "V": False})
    existing["PlayerInfos"].update({"XP": "123456", "Layout": True})
    existing["DurabilityInfos"]["N"] = False
    existing["PlayerLoc"].update({"L": "Bree-town", "X": "1500"})
    existing["Infamy"].update({"F": False, "P": "2500", "K": "4", "V": True})
    existing["DayNight"].update({"N": False, "S": "777"})
    existing["Reputation"]["H"] = False
    existing["GameTime"].update({"H": True, "S": True, "O": True, "M": "-5", "V": False})
    existing["LOTROPoints"].update({"W": "2", "V": True})
    existing["SP"] = existing.pop("Shards")
    existing["SP"].update({"V": True, "W": "1", "X": "400"})
    scenario("existing character", existing)

    # 3. old file that misses most sections and fields
    scenario("incomplete file", {"TitanBar": existing["TitanBar"], "Money": {"V": False}, "GameTime": {"H": True}})

    # 4. settings changed at runtime, then saved
    scenario("runtime changes", existing, """
        _G.ControlData.GT.userGMT = 3; _G.ControlData.RP.showMax = false; _G.ControlData.IF.points = 9999
        _G.ControlData.PL.text = "Rivendell"; _G.ControlData.DN.next = true; _G.ControlData.Money.sts = false
        _G.ControlData.BI.max = false; _G.ControlData.DI.icon = false
    """)

    # 5. "Reset all settings"
    scenario("reset all settings", existing, "ResetSettings()")

    print(f"\n{differences} differences between {args.ref} and the working tree")
    sys.exit(1 if differences else 0)


if __name__ == "__main__":
    main()
