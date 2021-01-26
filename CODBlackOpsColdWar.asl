// Original script by Kuno Demetries.
// Enhancements by Ero.

state("BlackOpsColdWar") {
	int loading  : 0xE179120;
	string14 map : 0xECF9EF3;
}

startup {
	var sB = new Dictionary<string,string> {
		{"ger_hub",        "CIA Safehouse E9"},
		{"nam_armada",     "Fractured Jaw"},
		{"ger_stakeout",   "Brick in the Wall"},
		{"rus_amerika",    "Redlight, Greenlight"},
		{"rus_yamantau",   "Echoes of a Cold War"},
		{"rus_kgb",        "Desperate Measures"},
		{"nic_revolucion", "End of the Line"},
		{"nam_prisoner",   "Break on Through"},
		{"ger_hub8",       "Identity Crisis"},
		{"rus_siege",      "The Final Countdown (Good Ending)"},
		{"rus_duga",       "Ashes to Ashes (Bad Ending)"},
	};

	settings.Add("Missions");
	settings.Add("briefings", false, "Briefings");
	settings.SetToolTip("split", "Will Split on every briefing (Includes interrogation)");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init {
	vars.debriefSplit = false;
	vars.splitter = false;
}

update {
	vars.debriefSplit = old.map != current.map && current.map == "ger_hub" && old.map != "takedown" && settings["briefings"];
	vars.splitter = ;
}

start {
	return current.map == "takedown" && current.loading != 0;
}

split {
	return old.map != current.map && (settings[current.map] || current.map == "ger_hub" && old.map != "takedown" && settings["briefings"]);
}

reset {
	return old.map != current.map && current.map == "e_frontend";
}

isLoading {
	return current.loading == 0;
}
