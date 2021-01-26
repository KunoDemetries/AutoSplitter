// Original script by Kuno Demetries.
// Enhancements by Ero.

state("ModernWarfare") {
	string12 mapName : 0xDE83FA1;
	int loading      : 0xEDD51C4;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("Act 1", "piccadilly",   "Piccadilly"),
		tB("Act 1", "safehouse",    "Embedded"),
		tB("Act 1", "ouse_finale",  "Proxy War"),
		tB("Act 1", "townhoused",   "Clean House"),
		tB("Act 1", "marines",      "Hunting Party"),
		tB("Act 1", "embassy",      "Embassy"),
		tB("Act 2", "highway",      "Highway of Death"),
		tB("Act 2", "hometown",     "Hometown"),
		tB("Act 2", "tunnels",      "The Wolf's Den"),
		tB("Act 2", "captive",      "Captive"),
		tB("Act 3", "stpetersburg", "Old Comrads"),
		tB("Act 3", "estate",       "Going Dark"),
		tB("Act 3", "lab",          "Into the Furnace")
	};

	settings.Add("Act 1");
	settings.Add("Act 2");
	settings.Add("Act 3");

	foreach (var s in sB)
		settings.Add(s.Item2, true, s.Item3, s.Item1);

	vars.doneMaps = new HashSet<string>();

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	if (current.mapName == "proxywar" && current.loading == 1118989 && old.loading != 1118989) {
		vars.doneMaps.Clear();
		vars.doneMaps.Add(current.mapName);
		return true;
	}
}

split {
	if (current.mapName != old.mapName && settings[current.mapName.Trim()] && !vars.doneMaps.Contains(current.mapName)) {
		vars.doneMaps.Add(current.mapName);
		return true;
	}
}

isLoading {
	return current.loading == 1118988;
}
