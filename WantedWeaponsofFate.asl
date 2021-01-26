// Original script by Kuno Demetries.
// Enhancements by Ero.

state("Wanted") {
	string18 mapName : 0x73060C, 0x58, 0xC;
	int loading      : 0x73EF70;
}

startup {
	var sB = new Dictionary<string,string> {
		{"/02_RES_A_1_stage1", "Act 2: When the Water Broke"},
		{"/03_DCF_A_stage1",   "Act 3: Russian's Last Dance"},
		{"/04_AIR_A_stage1",   "Act 4: Fear of Flying Fuck"},
		{"/05_OFF_A_stage1",   "Act 5: Shut The Fuck Up"},
		{"/06_CF_A_stage1",    "Act 6: Shoot That MotherFucker!"},
		{"/07_MOU_A_stage1",   "Act 7: Spiders Don't Have Wings"},
		{"/08_MVA_B_stage1",   "Act 8: Dust to Dust"},
		{"/09_CHU_A_1_stage1", "Act 9; How's Your Father?"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	vars.doneMaps = new HashSet<string>();
}

start {
	if (current.mapName == "/01_APT_A_stage1" && current.loading == 0 && old.loading != current.loading) {
		vars.doneMaps.Clear();
		return true;
	}
}

split {
	if (current.mapName != old.mapName && settings[current.mapName] && !vars.doneMaps.Contains(current.mapName)) {
		vars.doneMaps.Add(current.mapName);
		return true;
	}
}

isLoading {
	return current.loading == 1;
}
