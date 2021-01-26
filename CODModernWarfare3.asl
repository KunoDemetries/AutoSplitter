// Original script by Kuno Demetries.
// Enhancements by Ero.

state("iw5sp") {
	int dad           : 0x5AC158;
	string13 mapName1 : 0xB23C64;
	string13 mapName2 : 0xB23D0B;
	int poser         : 0x18002C3;
	int loading       : 0x19ECCC4;
}

startup {
	var sB = new Dictionary<string, string> {
		{"harbor",        "Hunter Killer"},
		{"ro",            "Persona Non Grata"},
		{"hijack",        "Turbulence"},
		{"sp_warlord",    "Back on the Grid"},
		{"london",        "Mind the Gap"},
		{"hamburg",       "Goalpost"},
		{"sp_payback",    "Return To Sender"},
		{"paris_a",       "Bag and Drag"},
		{"paris_ac130",   "Iron Lady"},
		{"prague",        "Eye of the Storm"},
		{"prague_escape", "Blood Brothers"},
		{"lin",           "Stronghold"},
		{"sp_berlin",     "Scorched Earth"},
		{"rescue_2",      "Down the Rabbit Hole"},
		{"dubai",         "Dust to Dust"}
	};

	settings.Add("missions", true, "Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName1 == "sp_ny_manhattan" && current.dad != 0 && current.loading != 0;
}

split {
	return current.mapName1 != old.mapName1 && settings[current.mapName1] || current.mapName2 != old.mapName2 && settings[current.mapName2];
}

reset {
	return current.poser == 0 && old.poser != 0;
}

isLoading {
	return current.loading == 0;
}
