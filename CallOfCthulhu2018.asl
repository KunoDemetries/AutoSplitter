// Original script by Kuno Demetries.
// Enhancements by Ero.

state("CallOfCthulhu") {
	int loading : 0x313B1D0, 0x8;
}

startup {
	var sB = new Dictionary<string,string> {
		{"1",  "Chapter 2: Dark Water"},
		{"2",  "Chapter 3: Garden of the Hawkins mansion"},
		{"3",  "Chapter 4: Tunnels Under the Hawkins mansion"},
		{"4",  "Chapter 5: Riverside Institute"},
		{"5",  "Chapter 6: Hawkins mansion"},
		{"6",  "Chapter 7: The Nameless Bookstore"},
		{"7",  "Chapter 8: Riverside Institute"},
		{"8",  "Chapter 9: Riverside Institute"},
		{"9",  "Chapter 10: Darkwater police station"},
		{"10", "Chapter 11: Darkwater police station"},
		{"11", "Chapter 12: Darkwater Port"},
		{"12", "Chapter 13: Abandoned whaling station"},
		{"13", "Chapter 14: Coastal Cave Alabaster Point"},
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	vars.doneMaps = new List<int>();

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init {
	vars.counter = 0;
	vars.oldComp = 0;
}

update {
	if (current.loading != 2 && old.loading == 2 && vars.oldComp != current.loading)
		vars.counter++;
}

start {
	if (current.loading != 2 && old.loading == 2) {
		vars.doneMaps.Clear();
		vars.counter = 0;
		return true;
	}
}

split {
	if (old.loading != current.loading && settings[vars.counter.ToString()] && !vars.doneMaps.Contains(vars.counter)) {
		vars.oldComp = current.loading;
		vars.doneMaps.Add(vars.counter);
		return true;
	}
}

isLoading {
	return current.loading == 2;
}
