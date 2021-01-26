// Original script by Kuno Demetries.
// Enhancements by Ero.

state("iw4sp") {
	string13 mapName : 0x5DA560;
	int randVar      : 0xC98A50;
	int loading      : 0x171338C;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("Act 1", "trainier",      "S.S.D.D."),
		tB("Act 1", "roadkill",      "Team Player"),
		tB("Act 1", "cliffhanger",   "Cliffhanger"),
		tB("Act 1", "airport",       "No Russian"),
		tB("Act 1", "favela",        "Takedown"),
		tB("Act 2", "invasion",      "Wolverines"),
		tB("Act 2", "favela_escape", "The Hornets Nest"),
		tB("Act 2", "arcadia",       "Exodus"),
		tB("Act 2", "oilrig",        "The Only Easy Day Was Yesterday"),
		tB("Act 2", "gulag",         "The Gulag"),
		tB("Act 2", "dcburning",     "Of Their Own Accord"),
		tB("Act 3", "contingency",   "Contingency"),
		tB("Act 3", "dcemp",         "Second Sun"),
		tB("Act 3", "dc_whitehouse", "Whiskey Hotel"),
		tB("Act 3", "estate",        "Loose Ends"),
		tB("Act 3", "boneyard",      "The Enemy of My Enemy"),
		tB("Act 3", "af_caves",      "Just Like Old Times"),
		tB("Act 3", "af_chase",      "Endgame"),
		tB("Act 3", "ending",        "End")
	};

	settings.Add("Act 1");
	settings.Add("Act 2");
	settings.Add("Act 3");

	foreach (var s in sB)
		settings.Add(s.Item2, true, s.Item3, s.Item1);
}

start {
	return current.mapName == "trainer" && old.mapName == "ui" && current.loading != 0;
}

split {
	return
		current.mapName != old.mapName && settings[current.mapName] ||
		current.randVar == 1048576000 && current.mapName == "ending";
}

reset {
	return current.mapName == "ui" && old.mapName != "ui";
}

isLoading {
	return current.loading == 0;
}
