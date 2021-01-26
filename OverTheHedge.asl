// Original script by Kuno Demetries.
// Enhancements by Ero.

state("hedge") {
	byte endSplit : 0x2E5BA4;
	int lvlID     : 0x3338B4;
	byte loading  : 0x358CD4;
}

startup {
	var sB = new Dictionary<string, string> {
		{"4",  "Inside Gladys' House"},
		{"5",  "Escape!"},
		{"6",  "Caught in the Hedge!"},
		{"7",  "Night Streets"},
		{"8",  "Projector Heist"},
		{"9",  "Martin Heist, Pt. 1"},
		{"10", "Martin Heist, Pt. 2"},
		{"11", "Martin House"},
		{"12", "Martin House Escape"},
		{"13", "Steam Train"},
		{"14", "Shooting Gallery"},
		{"15", "Maintenance Room"},
		{"16", "Smith Birthday Party"},
		{"17", "Smith Heist, Pt. 2"},
		{"18", "Smith House"},
		{"19", "Smith House Escape"},
		{"20", "Cave Interiors"},
		{"21", "Below Vincent's Den"},
		{"22", "Mountain Paths"},
		{"23", "Vincent's Den"},
		{"24", "Conner Heist, Pt. 1"},
		{"25", "Conner Heist, Pt. 2"},
		{"26", "Conner Heist, Pt. 3"},
		{"27", "Conner House"},
		{"28", "Conner House Escape"},
		{"29", "Mini-Golf Course"},
		{"30", "Roller Coaster Tracks"},
		{"31", "Roller Coaster Escape"},
		{"32", "Gladys Heist, Pt. 1"},
		{"33", "Gladys Heist, Pt. 2"},
		{"34", "Gladys Heist Escape"},
		{"35", "Protect The Woods!"},
		{"36", "Vermtech Heist"},
		{"37", "Rescue Heather!"}
	};

	settings.Add("Missions");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Missions");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.lvlID == 3 && current.loading == 1;
}

split {
	return current.lvlID != old.lvlID && settings[current.lvlID.ToString()] || current.lvlID == 37 && current.endSplit == 11;
}

reset {
	return current.lvlID == 2;
}

isLoading {
	return current.loading == 0;
}
