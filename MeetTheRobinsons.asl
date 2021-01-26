// Original script by Kuno Demetries.
// Enhancements by Ero.

state("wilbur") {
	byte loading     : 0x2FBC5C;
	string23 mapName : 0x328810;
}

startup {
	var sB = new Dictionary<string, string> {
		{"a1_robinson",             "Entering Robinson's house"},
		{"a1_robinson_storage",     "Storage Room"},
		{"a1_robinson_trainroom",   "Entering Training Room"},
		{"a1_robinsonhouse_ext",    "Exterior of House"},
		{"a1_subbasement",          "Entering Basement"},
		{"a1_subbasement2",         "Basement Part 2"},
		{"a1_subbasement3",         "Basement Part 3"},
		{"a1_subbasement_boss",     "Fighting Basement Boss"},
		{"a1_sciencefair",          "Science Fair"},
		{"a2_altfuture",            "Trainsit Station"},
		{"a2_altfuture_warehouse",  "Industrial District 1"},
		{"a2_oldtown",              "Old Town 1"},
		{"a2_altfuture_warehouse2", "Future Warehouse Part 2"},
		{"a2_oldtown2",             "Old Town Part 2"},
		{"a2_lizzy",                "Hive"},
		{"a2_lizzy_boss",           "Hive Thrown Room"},
		{"a2_magma",                "Magma Industires Transit"},
		{"a2_magma_interior",       "Magma Industries Backdoor"},
		{"a2_prometheus",           "Magma Industries Prometheus"},
		{"a3_robinson",             "Robinson House Pre-Doris"},
		{"a3_industries",           "Doris Fight"}
	};

	settings.Add("l1", false, "Levels Splits");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "l1");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "a1_egypt";
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

reset {
	return current.mapName == "fronted";
}

isLoading {
	return current.loading == 1;
}
