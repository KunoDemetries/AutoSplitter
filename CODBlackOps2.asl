// Original script by Kuno Demetries.
// Enhancements by Ero.

state("t6sp") {
	string23 mapName1 : 0xC18138;
	string23 mapName2 : 0xF4E62C;
	double loading    : 0x1A002C0;
	int exit          : 0x2578DF0;
}

startup {
	var sB = new Dictionary<string, string> {
		{"monsoon.all.sabs",     "Celerium"},
		{"afghanistan.all.sabs", "Old Wounds"},
		{"nicaragua.all.sabs",   "Time and Fate"},
		{"pakistan_1.all.sabs",  "Fallen Angel"},
		{"karma_1.all.sabs",     "Karma"},
		{"panama.all.sabs",      "Suffer With Me"},
		{"yemen.all.sabs",       "Achilles Veil"},
		{"blackout.all.sabs",    "Odysseus"},
		{"la_1.all.sabs",        "Cordis Die"},
		{"haiti.all.sabs",       "Judgment Day"}
	};

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value);

	vars.loadings = new List<string> {
		"fronted.english.sabs",
		"fronted.all.sabs",
		"ts_afghanistan.all.sabs"
	};

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName2 == "angola.all.sabs" && current.loading != 0;
}

split {
	return
		current.mapName2 != old.mapName2 && settings[current.mapName2] ||
		current.mapName1 == "haiti_gump_endings" && current.exit != 0;
}

isLoading {
	return current.mapName1 != "nicaragua_gump_josefina" && (
		current.loading == 0 || current.mapName1 == "su_rts_mp_dockside" || vars.loadings.Contains(current.mapName2)
	);
}
