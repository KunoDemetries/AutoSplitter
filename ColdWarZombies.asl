// Original script by Kuno Demetries.
// Enhancements by Ero.

state("BlackOpsColdWar") {
	int loading : 0xE179120;
	int round   : 0xFC390E4;
}

startup {
	var sB = new Dictionary<string,string> {
		{"2",   "Round 2"},
		{"3",   "Round 3"},
		{"4",   "Round 4"},
		{"5",   "Round 5"},
		{"10",  "Round 10"},
		{"15",  "Round 15"},
		{"30",  "Round 30"},
		{"50",  "Round 50"},
		{"70",  "Round 70"},
		{"100", "Round 100"}
	};

	settings.Add("rounds", false, "Round Splits");

 	foreach (var s in sB)
			settings.Add(s.Key, true, s.Value, "rounds");

	vars.onStart = (EventHandler)((s, e) => {
		timer.Run.Offset = TimeSpan.FromSeconds(0);
		vars.doneMaps.Clear();
	});

	timer.OnStart += vars.onStart;

	vars.doneMaps = new List<int>();

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	if (current.round == 1 && current.loading != 0) {
		timer.Run.Offset = TimeSpan.FromSeconds(-10);
		return true;
	}
}

split {
	if (current.round != old.round && settings[current.round.ToString()] && !vars.doneMaps.Contains(current.round)) {
		vars.doneMaps.Add(current.round);
		return true;
	}
}

reset {
	return current.round == 0;
}
