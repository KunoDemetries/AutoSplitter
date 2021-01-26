// Original script by Kuno Demetries.
// Enhancements by Ero.

state("s2_sp64_ship") {
	int loading      : 0x2AB9B44;
	string14 mapName : 0x6A122B4;
}

startup {
	var sB = new Dictionary<string, string> {
		{"cobra", "Operation Cobra"},
		{"marigny", "Stronghold"},
		{"train", "S.O.E."},
		{"paris", "Liberation"},
		{"aachen", "Collateral Damage"},
		{"hurtgen", "Death Factory"},
		{"hill", "Hill 493"},
		{"bulge", "Battle of The Bulge"},
		{"taken", "Ambush"},
		{"taken_tent", "The Rhine"},
		{"labor_camp", "Epilogue"}
	};

	settings.Add("missions", true, "Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "normandy" && current.mapName != "transport_ship";
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

isLoading {
	return current.loading == 0;
}
