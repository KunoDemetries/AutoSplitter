// Original script by Kuno Demetries.
// Enhancements by Ero.

state("FEARXP2") {
	string26 mapName : 0x21208C;
	int cutscene     : 0x216DC4;
	int loading      : 0x2193D0;
}

startup {
	var sB = new Dictionary<string, string> {
		{"Sewer.World00p",             "Investigation - Underneath"},
		{"Streets.World00p",           "Investigation - Firefight"},
		{"Data_Center.World00p",       "Revelation - Rescue and Recon"},
		{"Computer_Core.World00p",     "Revelation - Disturbance"},
		{"Landing_Zone.World00p",      "Apprehension - Pacification"},
		{"Research_facility.World00p", "Apprehension - Bio-Research"},
		{"Plaza.World00p",             "Apprehension - The Plaza Chase"},
		{"Underground.World00p",       "Devastation - Buried"},
		{"Subway.World00p",            "Devastation - The Deep"},
		{"Train_Yard.World00p",        "Infiltration - Relic"},
		{"Headquarters.World00p",      "Infiltration - Base Camp"},
		{"Mine.World00p",              "Exploration - Labyrinth"},
		{"Clone_Labs.World00p",        "Extermination - Clone Facility"},
		{"Clone_Production.World00p",  "Extermination - Clone Production"},
		{"Escape.World00p",            "Extermination - Showdown"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "Introduction.World00p" && current.loading != 0 && current.cutscene == 0;
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

isLoading {
	return current.loading == 0 || current.cutscene != 0;
}
