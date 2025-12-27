-- shellcmd.lua
-- written by Habna


local max = 4; -- Number of shell commands

local ShellCommandName = {};
local ShellCommandDes = {};

for i = 1, max do ShellCommandName[i]= ( L["SCb" .. i] .. L["SCa" .. i] ); ShellCommandDes[i]= ( L["SCWC" .. i] ); end

function frmShellCmd()
	TB["win"].MouseLeave();
	frmSC = true;
	opt_shellcmd:SetEnabled( false );

	import(AppDirD .. "WindowFactory")
	
	-- **v Determine window width based on locale v**
	local windowWidth = 460
	if TBLocale == "fr" then windowWidth = 565
	elseif TBLocale == "de" then windowWidth = 645
	end
	-- **^
	
	-- **v Create window via factory v**
	wShellCmd = CreateWindow({
		text = L["SCWTitle"],
		width = windowWidth,
		height = 50,
		left = SCWLeft,
		top = SCWTop,
		config = {
			settingsKey = "Shell",
			windowGlobalVar = "wShellCmd",
			onPositionChanged = function(left, top)
				SCWLeft, SCWTop = left, top
			end,
			onClosing = function(sender, args)
				opt_shellcmd:SetEnabled(true)
				frmSC = nil
			end
		}
	})
	-- **^
	
	--**v Shell command v**
	local PosY = 40;
	local ShowSC = true;
	local Max = #ShellCommandName --Number of shell command

	for i = 1, Max do
		if PlayerAlign == 2 then
			if i == 5 or i == 6 or i == 9 or i == 10 or i == 14 or i == 15 or i == 16 or i == 17 or i == 20 or i == 21 or i == 24 then -- Shell command to ignore if in monster play
				ShowSC = false;
			end
		end

		if ShowSC then
			local lblShell = Turbine.UI.Label();
			lblShell:SetParent( wShellCmd );
			lblShell:SetText( ShellCommandName[i] );
			lblShell:SetPosition( 25, PosY );
			lblShell:SetSize( lblShell:GetTextLength() * 7.5, 18 );
			lblShell:SetForeColor( Color["green"] );
			lblShell:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			--lblShell:SetBackColor( Color["red"] ); -- debug purpose

			local lblShellDes = Turbine.UI.Label();
			lblShellDes:SetParent( wShellCmd );
			lblShellDes:SetText( ShellCommandDes[i] );
			lblShellDes:SetPosition( lblShell:GetLeft() + lblShell:GetWidth() + 5, PosY );
			lblShellDes:SetSize( lblShellDes:GetTextLength() * 7.5, 18 );
			lblShellDes:SetForeColor( Color["white"] );
			lblShellDes:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			--lblShellDes:SetBackColor( Color["blue"] ); -- debug purpose

			PosY = PosY + 15;
			wShellCmd:SetHeight( PosY );
		end
		ShowSC = true;
	end
	wShellCmd:SetHeight( PosY + 20 );
	--**^
end