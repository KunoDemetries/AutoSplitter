// Original script by Kuno Demetries.
// Enhancements by Ero.

state("SniperEliteV2") {
	//int loading      : 0x6486C4;
	string38 mapName : 0x685F31;
}

startup {
	var sB = new Dictionary<string, string> {
		{@"Street\M02_Street.pc",                   "Schonberg Streets"},
		{@"Facility\M03_Facility.pc",               "Mittelwerk Facility"},
		{@"BodeMuseum\M05_BodeMuseum.pc",           "Kasier Friedrich Museum"},
		{@"Bebelplatz\M06_Bebelplatz.pc",           "Opernplatz"},
		{@"Church\M07_Church.pc",                   "St. Olibartus Church"},
		{@"Flaktower\M08_Flaktower.pc",             "Tiergarten Flak Tower"},
		{@"CommandPost\M09_CommandPost.pc",         "Karlshorst Command Post"},
		{@"PotsdamerPlatz\M10_PotsdamerPlatz.pc",   "Kreuzberg HeadQuarters"},
		{@"LaunchSite\M10a_LaunchSite.pc",          "Kopenick Launch Site"},
		{@"BrandenburgGate\M11_BrandenburgGate.pc", "Brandenburg Gate"}
	};

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value);
}

start {
	return current.mapName == @"Tutorial\M01_Tutorial.pc" && old.mapName == @"nu\Options.gui";
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

reset {
	return current.mapName == @"nu\Options.gui" && old.mapName != @"nu\Options.gui";
}
