-- resources.lua
-- written by Thorondor
-- patched by Technical_13, Giseldah


local AppRes = "HabnaPlugins/TitanBar/Resources/";

_G.resources = {
	Picker = AppRes .. "picker.jpg",
	BagIcon = { 0x41008113, 0x41008114, 0x41008115, 0x41008111, 0x41008112 },
	Box = {
		TopLeft = 0x41000145,
		Top = 0x41000146,
		TopRight = 0x41000144,
		MidLeft = 0x41000147,
		Middle = 0x4100014C,
		MidRight = 0x4100014B, --0x4100013B
		BottomLeft = 0x41000148,
		Bottom = 0x41000149,
		BottomRight = 0x4100014A
	},
	DelIcon = 0x4101f893,
	Durability = { 0x410e924c, 0x410e925c, 0x410e926e },
	FreePeoples = {
		[0] = 0x4100819b,
		[1] = 0x410080a8,
		[2] = 0x410080a9,
		[3] = 0x410080aa,
		[4] = 0x410080ab,
		[5] = 0x410080ac,
		[6] = 0x410080ad,
		[7] = 0x410080ae,
		[8] = 0x410080af,
		[9] = 0x410080a1,
		[10] = 0x410080a2,
		[11] = 0x410080a3,
		[12] = 0x410080a4,
		[13] = 0x410080a5,
		[14] = 0x410080a6,
		[15] = 0x410080a7
	},
	frmMain = 0x41007e8f, --( 0x411044a2, 0x41007e2a, 0x41007e8f )
	InfamyBG = 0x41007df5, -- pink: 0x41007df4, white/grey: 0x41007df7, white: 0x41007e14
	-- blue: 0x41007df5 -gradient, blue: 0x41000143 -dark, blue: 0x41007e92 -bright
	-- yellow: 0x41007e93, green: 0x41007df3, Freeps : 0x41007e25,	
	Item = 0x411386af,
	MoneyIcon = {
		Gold = 0x41007e7b,
		Silver = 0x41007e7c,
		Copper = 0x41007e7d
	}, --gold, silver, copper icon 27x21
	Monster = {
		[0] = 0x4100819c,
		[1] = 0x410080b7,
		[2] = 0x410080b8,
		[3] = 0x410080b9,
		[4] = 0x410080ba,
		[5] = 0x410080bb,
		[6] = 0x410080bc,
		[7] = 0x410080bd,
		[8] = 0x410080be,
		[9] = 0x410080b0,
		[10] = 0x410080b1,
		[11] = 0x410080b2,
		[12] = 0x410080b3,
		[13] = 0x410080b4,
		[14] = 0x410080b5,
		[15] = 0x410080b6
	},
	PlayerInfo = { Morale = 0x410dcfce, Power = 0x410dcfcf, Armor = 0x410dcfd0, Wrath = 0x4115bdfe },
	PlayerIconCode = {  -- icon id for each new class needs to be added here (by Class Id)
		[23] = 0x4111dd35, -- Guardian
		[24] = 0x4111dd31, -- Captain
		[31] = 0x4111dd3b, -- Minstrel
		[40] = 0x4111dd2f, -- Burglar
		[52] = 0x41007dde, -- Warleader
		[71] = 0x41007ddd, -- Reaver
		[126] = 0x41007de1, -- Stalker
		[127] = 0x41007de0, -- Weaver
		[128] = 0x410E6BF5, -- Defiler
		[162] = 0x4111dd37, -- Hunter
		[172] = 0x4111dd33, -- Champion
		[179] = 0x41007ddf, -- Blackarrow
		[185] = 0x4111dd39, -- LoreMaster
		[192] = 0x41091dde, -- Chicken (Adventurer)
		[193] = 0x4111dd3d, -- RuneKeeper
		[194] = 0x4111dd3f, -- Warden
		[214] = 0x41153604, -- Beorning
		[215] = 0x4120fcd9, -- Brawler
		[216] = 0x4122f865 -- Mariner
	},
	Reputation = {
		Icon = 0x410d431a,
		BGGood = 0x41007df5,
		BGBad = 0x41007df5,
		BGGuild = 0x41007df5,
		BGFrame = 0x41007e94,
		BGWindow = 0x4100013B
	}, -- diff BG's
	Ring = 0x41005f30,
	Storage = {
		Shared = 0x41003830,
		Vault = 0x41005e9d
	}, --0x410e76b7 in-game icon 16x16 (Need 32x32)
	Sun = 0x4101f898,
	Moon = 0x4101f89a,
	TrackItems = 0x410d42cc, -- in-game icon 32x32 (0x41005bd6 / 0x410d42cc)
	LOTROPoints = 0x4113478C,
	Wallet = 0x41004641,    --0x41007f7c,
	WalletWindow = 0x4100014c,
	WalletWindowRefresh = 0x4100013B
};

_G.DurabilitySlotsBG = { 0x41007eed, 0x41007ef6, 0x41007ef7, 0x41007eef, 0x41007eee, 0x41007ee9, 0x41007ef0, 0x41007ef9, 0x41007ef8,
	0x41007ef4, 0x41007ef3, 0x41007ef2, 0x41007ef1, 0x41007ef5, 0x41007efa, 0x41007eea, 0x41007eeb, 0x41007eec,
	0x41007efb, 0x410e8680
};
