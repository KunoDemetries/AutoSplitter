// Original script by Kuno Demetries.
// Enhancements by Ero.

state("SniperElite3") {
	int loading      : 0x628040, 0x0;	// Probably a static address.
	string38 mapName : 0xA37ECD;
}

startup {
	var sB = new Dictionary<string, string> {
		{@"Oasis\M02_Oasis.pc",                   "Gaberoun"},
		{@"Halfaya_Pass\M03_Halfaya_Pass.pc",     "Halfaya Pass"},
		{@"Fort\M04_Fort.pc",                     "Fort Rifugio"},
		{@"Siwa\M05_Siwa.pc",                     "Siwa Oasis"},
		{@"Kasserine_Pass\M06_Kasserine_Pass.pc", "Kasserine Pass"},
		{@"Airfield\M07_Airfield.pc",             "Pont Du Fahs Airfield"},
		{@"Ratte_Factory\M08_Ratte_Factory.pc",   "Ratte Factory"}
	};

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value);

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == @"Siege_of_Tobruk\M01_Siege_of_Tobruk.pc" && current.loading == 1;
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

isLoading {
	return current.loading == 0;
}
