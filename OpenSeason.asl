// Original script by Kuno Demetries.
// Enhancements by Ero.

state("OpenSeason") {
	string23 map : 0x6880EC;
	int loading  : 0x6880F0;
}

startup {
	var sB = new Dictionary<string, string> {
		{"OS_TimberlineRide",       "Timberline"},
		{"OS_TimberlinePuni",       "Puni Mart Picnic"},
		{"OS_TheLedge",             "Wake In The Wild"},
		{"OS_ForestSkunks",         "Meet The Skunks"},
		{"OS_ElliotRosie",          "Hoof It!"},
		{"OS_ForestLoggers",        "Scare Bear"},
		{"OS_Mine",                 "Mine Shafted"},
		{"OS_Journey",              "Hunted!"},
		{"OS_SnowballRide",         "Snow Blitz"},
		{"OS_Marsh",                "Crazy Quackers"},
		{"OS_ElliotDuckCall",       "Fowl Duty"},
		{"OS_ElliotTurret1",        "Duck And Cover"},
		{"OS_BeaverDam",            "Beaver Damage"},
		{"OS_OuthouseRide",         "Rocky River"},
		{"OS_ShawsCabin",           "Shaw's Shack"},
		{"OS_DawnBattleTheLedge",   "Start The Battle"},
		{"OS_ElliotTurretClanTree", "Protect The Clan's Tree"},
		{"OS_ElliotPropaneTank",    "Tanks A Lot"},
		{"OS_DawnBattleTheMarsh",   "Clear The Ducks"},
		{"OS_DawnBattleForest",     "The Trouble With Trappers"},
		{"OS_ElliotTurretBeaver",   "Toothy Torpedoes"},
		{"OS_ElliotChainsaw",       "Chainsaw Cha Cha"},
		{"OS_DawnBattleBeaverDam",  "Reilly's Rampage"},
		{"OS_FinalBattle",          "Shaw Showdown"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.map != "menu" && current.map == "OS_Daisyfield";
}

split {
	return current.map != old.map && settings[current.map];
}

reset {
	return current.map == "menu" && old.map != current.map;
}

isLoading {
	return current.loading == 0;
}
