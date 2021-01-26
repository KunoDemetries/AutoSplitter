// Original script by Kuno Demetries.
// Enhancements by Ero.

state("Spiderwick") {
	string20 chapter  : 0x2E47A5;
	int cinematics    : 0x32C4A8;
	int loading       : 0xA356B8;
	string25 playArea : 0xA57F68;
	string20 levels   : 0xA57F88;
	int cutscenes     : 0xAE4DB0;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("chapters", "Chapter1", "Chapter 1"),
		tB("chapters", "Chapter2", "Chapter 2"),
		tB("chapters", "Chapter3", "Chapter 3"),
		tB("chapters", "Chapter4", "Chapter 4"),
		tB("chapters", "Chapter5", "Chapter 5"),
		tB("chapters", "Chapter6", "Chapter 6"),
		tB("chapters", "Chapter7", "Chapter 7"),
		tB("chapters", "Chapter8", "Chapter 8"),
		tB("wr",       "7",        "Field Guide"),
		tB("wr",       "15",       "Stone"),
		tB("wr",       "22",       "Monacle"),
		tB("wr",       "34",       "Quarry"),
		tB("wr",       "55",       "Troll"),
		tB("wr",       "56",       "RedCap"),
		tB("wr",       "62",       "Splattergun"),
		tB("wr",       "76",       "Cellar Key"),
		tB("wr",       "78",       "Lucinda"),
		tB("wr",       "86",       "Acorn"),
		tB("wr",       "94",       "Quarry 2"),
		tB("wr",       "107",      "Griffin"),
		tB("wr",       "117",      "Return to the Mansion"),
		tB("wr",       "121",      "House Arrest"),
		tB("wr",       "123",      "Ogre Fight")
	};

	settings.Add("chapters", false, "Chapter Splits");
	settings.Add("wr", true, "World Record Splits");

	foreach (var s in sB) {
		if (s.Item1 == "chapters") vars.chSet.Add(s.Item2);
		if (s.Item1 == "wr") vars.wrSet.Add(s.Item2);
		settings.Add(s.Item2, true, s.Item3, s.Item1);
	}

	timer.CurrentTimingMethod = TimingMethod.GameTime;

	vars.chSet = new HashSet<string>();
	vars.wrSet = new HashSet<string>();
	vars.doneMaps = new List<string>();
}

init {
	vars.wrSplits = 0;
}

update {
	if (current.cinematics != old.cinematics && current.cinematics == 0 ||
	    current.cutscenes != old.cutscenes && current.cutscenes == 0)
		vars.wrSplits++;
}

start {
	if (current.playArea != "shell" && old.playArea == "shell") {
		vars.wrSplits = 0;
		vars.doneMaps.Clear();
		return true;
	}
}

split {
	string currMap = vars.wrSplits.ToString();
	if (settings[currMap] && !vars.doneMaps.Contains(currMap) && (vars.chSet.Contains(current.chapter) || vars.wrSet.Contains(currMap))) {
		vars.doneMaps.Add(currMap);
		return true;
	}

	return vars.wrSplits > 128 && current.chapter == "Chapter7" && current.cinematics == 1 && current.cutscenes == 0 && current.levels == "ealth";
}

reset {
	return current.playArea =="shell";
}

isLoading {
	return current.loading == 1;
}
