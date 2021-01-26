// Original script by Kuno Demetries.
// Enhancements by Ero.

state("SniperElite4_DX11") {
	float islandLoad  : 0xC15A90;
	float loading     : 0xCFCAF0;
	string100 mapName : 0xEB0BEB;
}

state("SniperElite4_DX12") {
	float islandLoad  : 0xB683E0;
	float loading     : 0xE55958;
	string100 mapName : 0xE5A2AB;
}

startup {
	var sB = new Dictionary<string, string> {
		{"Marina", "Bianti Village"},
		{"Viaduct", "Regilino Viaduct"},
		{"Dockyard", "Lorino Dockyard"},
		{"Monte_Cassino", "Abrunza Monastery"},
		{"Coastal_Facility", "Magazzeno Facility"},
		{"Forest", "Giovi Fiorini Mansion"},
		{"Fortress", "allagra Fortress"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == "Island" && current.loading != 0;
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

reset {
	return current.mapName == "Island" && old.mapName != "Island";
}

isLoading {
	return current.loading == 0 || current.islandLoad == 0;
}
