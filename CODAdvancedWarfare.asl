// Original script by Klooger, Kuno Demetries.
// Enhancements by Ero.

state("s1_sp64_ship") {
	string12 map : 0x30740B6;
	int loading  : 0xF6109DC;
}

startup {
	var sB = new Dictionary<string,string> {
		{"recovery",     "Atlas"},
		{"lagos",        "Traffic"},
		{"fusion",       "Fission"},
		{"detroit",      "Aftermath"},
		{"greece",       "Manhunt"},
		{"betrayal",     "Utopia"},
		{"irons_estate", "Sentinel"},
		{"crash",        "Crash"},
		{"lab",          "Bio Lab"},
		{"sanfran",      "Collapse"},
		{"sanfran_b",    "Armada"},
		{"df_fly",       "Throttle"},
		{"captured",     "Captured"},
		{"finale",       "Terminus"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.map == "seoul" && current.loading == 0;
}

split {
	return current.map != old.map && settings[current.map];
}

reset
{
	return current.map == "ui";
}

isLoading
{
	return current.loading == 1;
}
