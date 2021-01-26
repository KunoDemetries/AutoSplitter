// Original script by Kuno Demetries.
// Enhancements by Ero.

state("iw5sp") {
	string14 mapName : 0xB23C64;
	int loading      : 0x19ECCC4;
}

startup {
	var sB = new Dictionary<string, string> {
		{"deer_hunt",      "Brave New World"},
		{"nml",            "No Man's Land"},
		{"enemyhq",        "Struck Down"},
		{"homecoming",     "Homecoming"},
		{"flood",          "Legends Never Die"},
		{"cornered",       "Federation Day"},
		{"oilrocks",       "Birds of Prey"},
		{"jungle_ghosts",  "The Hunted"},
		{"clockwork",      "Clockwork"},
		{"black_ice",      "Atlas Falls"},
		{"ship_graveyard", "Into the Deep"},
		{"factory",        "End of the Line"},
		{"las_vegas",      "Sin City"},
		{"carrier",        "All or Nothing"},
		{"satfarm",        "Severed Ties"},
		{"loki",           "Loki"},
		{"skyway",         "The Ghost Killer"}
	};

	settings.Add("missions", true, "Missions");

	foreach (var s in sB) settings.Add(s.Key, true, s.Value, "missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "prologue";
}

split {
	return old.mapName != current.mapName && settings[current.mapName];
}

reset {
	return current.mapName == null;
}

isLoading {
	return current.loading == 0;
}
