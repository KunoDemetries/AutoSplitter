// Original script by Kuno Demetries, rythin.
// Enhancements by Ero.

state("CoDWaW") {
	string7 mapName : 0x5592B8;
	int seen        : 0x14E742C;
	int squares     : 0x14ED874;
	int loading     : 0x3172284;
}

startup {
	var sB = new Dictionary<string, string> {
		{"pel1",    "Little Resistance"},
		{"pel2",    "Hard Landing"},
		{"sniper",  "Vendetta"},
		{"see1",    "Their Land, Their Blood"},
		{"pel1a",   "Burn 'em Out"},
		{"pel1b",   "Relentless"},
		{"see2",    "Blood and Iron"},
		{"ber1",    "Ring of Steel"},
		{"ber2",    "Eviction"},
		{"pby_fly", "Black Cats"},
		{"oki2",    "Blowtorch & Corkscrew"},
		{"oki3",    "Breaking Point"},
		{"ber3",    "Heart of the Reich"},
		{"ber3b",   "Downfall"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "mak" && current.squares == 16384;
}

split {
	return current.mapName != old.mapName && settings[old.mapName];
}

reset {
	return old.mapName != "ui" && current.mapName == "ui";
}

isLoading {
	return current.loading == 0 || current.mapName == "see1" && current.seen == 0;
}
