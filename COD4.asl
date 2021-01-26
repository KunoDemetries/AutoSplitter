// Original script by Kuno Demetries, rythin.
// Enhancements by Ero.

state("iw3sp") {
	string16 mapName : 0x6C3140;
	int randVar      : 0xCDE4C8;
	int loading      : 0x10B1100;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("act0", "killhouse",        "F.N.G."),
		tB("act0", "cargoship",        "Crew Expendable"),
		tB("act0", "coup",             "The Coup"),
		tB("act1", "blackout",         "Blackout"),
		tB("act1", "armada",           "Charlie Dont Surf"),
		tB("act1", "bog_a",            "The Bog"),
		tB("act1", "hunted",           "Hunted"),
		tB("act1", "ac130",            "Death From Above"),
		tB("act1", "bog_b",            "War Pig"),
		tB("act1", "airlift",          "Shock and Awe"),
		tB("act1", "aftermath",        "Aftermath"),
		tB("act2", "village_assault",  "Safe House"),
		tB("act2", "scoutsniper",      "All Ghillied Up"),
		tB("act2", "sniperescape",     "One Shot, One Kill"),
		tB("act2", "village_defend",   "Heat"),
		tB("act2", "ambush",           "The Sins of the Father"),
		tB("act3", "icbm",             "Ultimatum"),
		tB("act3", "launchfacility_a", "All In"),
		tB("act3", "launchfacility_b", "No Fighting in The War Room"),
		tB("act3", "jeepride",         "Game Over")
	};

	settings.Add("act0", true, "Prologue");
	settings.Add("act1", true, "Act 1");
	settings.Add("act2", true, "Act 2");
	settings.Add("act3", true, "Act 3");

	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init {
	vars.coupOffset = false;
}

start {
	if (current.mapName == "killhouse" && current.loading != 0 && old.loading == 0) {
		vars.coupOffset = false;
		return true;
	}
}

split {
	if (current.mapName != old.mapName) {
		if (current.mapName == "coup") vars.coupOffset = true;
		return settings[current.mapName];
	}

	return current.mapName == "jeepride" && current.randVar == 139512;
}

reset {
	return current.mapName == "ui" && old.mapName != "coup";
}

gameTime {
	if (vars.coupOffset) {
		vars.coupOffset = false;
		return timer.CurrentTime.RealTime.Add(new TimeSpan (0, 4, 44));
	}
}

isLoading {
	return current.loading == 0 || current.mapName == "coup";
}
