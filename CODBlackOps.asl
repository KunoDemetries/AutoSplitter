// Original script by Kuno Demetries, rythin.
// Enhancements by Ero.

state("BlackOps")
{
	string14 mapName : 0x21033E8;
	long loading : 0x356E7F4;
}

startup {
	var sB = new Dictionary<string,string> {
		{"vorkuta",        "Vorkuta"},
		{"pentagon",       "USDD"},
		{"flashpoint",     "Executive Order"},
		{"khe_sanh",       "SOG"},
		{"hue_city",       "The Defector"},
		{"kowloon",        "Numbers"},
		{"fullahead",      "Project Nova"},
		{"creek_1",        "Victor Charlie"},
		{"river",          "Crash Site"},
		{"wmd_sr71",       "WMD"},
		{"pow",            "Payback"},
		{"rebirth",        "Rebirth"},
		{"int_escape",     "Revelations"},
		{"underwaterbase", "Redemption"},
		{"outro",          "Menu Screen"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;

	vars.onStart = (EventHandler)((s, e) => {
		vars.USDDtime = false;
	});

	timer.OnStart += vars.onStart;
}

init {
	vars.USDDtime = false;
}

start {
	if (current.mapName == "cuba" && current.loading != 0) {
		vars.USDDtime = false;
		return true;
	}
}

isLoading
{
	return current.loading == 0 || current.mapName == "pentagon" || current.mapName == "frontend";
}


reset
{
	return current.mapName == "frontend";
}

split {
	if (old.mapName != current.mapName && settings[current.mapName]) {
		if (current.mapName == "pentagon") vars.USDDtime = true;
		return true;
	}
}

gameTime {
	if (vars.USDDtime) {
		vars.USDDtime = false;
		return timer.CurrentTime.RealTime.Add(new TimeSpan (0, 4, 55));
	}
}

exit {
	timer.OnStart -= vars.onStart;
}

shutdown {
	timer.OnStart -= vars.onStart;
}
