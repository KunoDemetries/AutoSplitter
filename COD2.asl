// Original script by Kuno Demetries.
// Enhancements by Ero.

state("CoD2SP_s") {
	int loading  : 0x415010;
	string16 map : 0xCFEBD0;
}

startup {
	var sB = new Dictionary<string, string> {
		{"demolition",       "Demolition"},
		{"tunkhunt",         "Repairing the Wire"},
		{"trainyard",        "The Pipeline"},
		{"downtown_assault", "Downtown Assault"},
		{"cityhall",         "City Hall"},
		{"downtown_sniper",  "Comrade Sniper"},
		{"decoytrenches",    "The Diversionary Raid"},
		{"decoytown",        "Holding The Line"},
		{"elalamein",        "Operation Supercharge"},
		{"eldaba",           "The End of the Beginning"},
		{"libya",            "Crusader Charge"},
		{"88ridge",          "88 Ridge"},
		{"toujane_ride",     "Outnumbered and Outgunned"},
		{"toujane",          "Retaking Lost Ground"},
		{"matmata",          "Assault on Matmata"},
		{"duhoc_assault",    "The Battle of Pointe du Hoc"},
		{"duhoc_defend",     "Defending the Pointe"},
		{"silotown_assault", "The Silo"},
		{"beltot",           "Prisoners of War"},
		{"crossroads",       "The Crossroads"},
		{"newvillers",       "The Tiger"},
		{"breakout",         "The Brigade Box"},
		{"bergstein",        "Approaching Hill 400"},
		{"hill400_assault",  "Rangers Lead the Way"},
		{"hill400_defend",   "The Battle for Hill 400"},
		{"rhine",            " Crossing the Rhine"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.map == "moscow" && old.map == "movie_eastern";
}

split {
	return current.map != old.map && settings[current.map] || current.map == "credits";
}

reset {
	return current.map == "movie_eastern" && old.map != "movie_eastern";
}

isLoading {
	return current.loading == 0;
}
