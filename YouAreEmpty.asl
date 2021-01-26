// Original script by Kuno Demetries.
// Enhancements by Ero.

state("you_are_empty") {
	string12 mapName  : "ds2kernel.dll", 0xBDC94;
	bool isNotLoading : "ds2kernel.dll", 0xC00EC;
}

startup {
	var sB = new Dictionary<string, string> {
		{"med2",         "Hospital 2"},
		{"kolhoz",       "Kolhoz 1"},
		{"kolhoz_part2", "Kolhoz 2"},
		{"meat",         "Plant 1"},
		{"meat_part2",   "Plant 2"},
		{"wall",         "Old Town"},
		{"gor",          "Totalitarianism 1"},
		{"gor_part_2",   "Totalitarianism 2"},
		{"grsvt",        "City Council"},
		{"gorkonec",     "Tram"},
		{"poh",          "Yards"},
		{"kinostreet",   "Cinema 1"},
		{"kinostreet 2", "Cinema 2"},
		{"metro",        "Metro 1"},
		{"met6",         "Metro 2"},
		{"theatre",      "Opera"},
		{"krovli",       "Roofs"},
		{"parall",       "Depot 1"},
		{"parall_part2", "Depot 2"},
		{"parall_part3", "Depot 3"},
		{"lastlevel",    "Utopia"},
		{"futur",        "Reactor"},
		{"lastzlo",      "Finale"}
	};

	settings.Add("Levels");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Levels");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "med1" && !current.isNotLoading;
}

split {
	return current.map != old.map && settings[current.map];
}

isLoading {
	return !current.isNotLoading;
}
