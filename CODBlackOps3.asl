// Original script by Kuno Demetries.
// Enhancements by Ero.

state("blackops3")  {
	string11 map : 0x156E5086;
	int loading  : 0x19E00000;
}

startup {
	var sB = new Dictionary<string, string> {
		{"newworld", "New World"},
		{"ackstation", "In Darkness"},
		{"odomes", "Provocation"},
		{"en", "Hypercenter"},
		{"ngeance", "Vengeance"},
		{"amses", "Rise and Fall"},
		{"nfection", "Demon Within"},
		{"quifer", "Sand Castle"},
		{"otus", "Lotus Towers"},
		{"coalescence", "Life"}
	};

	settings.Add("missions", true, "Missions");

	foreach (var s in sB) settings.Add(s.Key, true, s.Value, "missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.map == "logue" && current.loading != 0;
}

split {
	return current.map != old.map && settings[current.map];
}

isLoading {
	return current.loading == 0;
}
