// Original script by Kuno Demetries.
// Enhancements by Ero.

state("FEARXP") {
	string21 mapName : 0x21007F;
	int cutscene     : 0x214DA4;
	int loading      : 0x2173B8;
}

startup {
	var sB = new Dictionary<string, string> {
		{"Church_02.World00p",    "Contamination - Metastasis"},
		{"Warehouse_01.World00p", "Flight - Ambush"},
		{"Warehouse_02.World00p", "Flight- Holiday"},
		{"Warehouse_03.World00p", "flight- Desolation"},
		{"Subway_01.World00p",    "Descent - Terminus"},
		{"Subway_02.World00p",    "Descent - Orange Line"},
		{"Subway_03.World00p",    "Descent - The L"},
		{"Office_01.World00p",    "Malice - Leviathan"},
		{"Hospital_01.World00p",  "Extraction Point - Malignancy"},
		{"Hospital_02.World00p",  "Extraction Point - Dark Heart"},
		{"Hospital_03.World00p",  "Epilogue"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "Church_01.World00p" && current.loading != 0 && current.cutscene == 0;
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

reset {
	return current.mapName == "XP_Intro.World00p";
}

isLoading {
	return current.loading == 0 || current.cutscene != 0;
}
