// Original script by Kuno Demetries.
// Enhancements by Ero.

state("Sirean Head") {
	byte loading :"UnityPlayer.dll", 0x135FE9B;
}

startup {
	settings.Add("All Levels");

	var sB = new Dictionary<string,string> {
		{"2", "Level 2"},
		{"3", "Level 3"},
		{"4", "Level 4"},
	};

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "All Levels");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init {
	current.counter = 1;
	vars.value = 0;
}

update {
	if (current.loading == 5)
		vars.value = current.loading;

	if (old.loading != current.loading && current.loading != 5 && vars.value != current.loading) {
		vars.value = current.loading;
		current.counter++;
	}
}

start {
	if (old.loading != 5 && current.loading == 5) {
		current.counter = 1;
		return true;
	}
}

split {
	return old.counter != current.counter && settings[vars.counter.ToString()];
}

isLoading {
	return current.loading != 5;
}
