// Original script by Kuno Demetries.
// Enhancements by Ero.

state("Lithtech") {
	string20 mapName : 0xD739C, 0x30, 0x54, 0x48, 0x120, 0x20, 0x4;
	bool loading     : 0xE1AF8;
}

startup {
	var sB = new Dictionary<string, string> {
		{@"ds\mapName1.aiw",      "Level 1: Makatomi Plaza"},
		{@"ds\32-1.aiw",          "Level 2: False Alarm"},
		{@"ds\39-1.aiw",          "Level 3: The Bomber"},
		{@"ds\roof-1.aiw",        "Level 4: On the Roof"},
		{@"ds\39-2.aiw",          "Level 5: Down the Shaft"},
		{@"ds\38-2.aiw",          "Level 6: Welcome to the party"},
		{@"ds\basement-1.aiw",    "Level 7: High Maintenance"},
		{@"ds\parkade-1.aiw",     "Level 8: Argyte's Run"},
		{@"ds\basement-2.aiw",    "Level 9: PLayin' The Hero"},
		{@"ds\subbasement-1.aiw", "Level 10: One of the Terrorists"},
		{@"ds\sewer-1.aiw",       "Level 11: Not my Day"},
		{@"ds\subbasement-2.aiw", "Level 12: Aftermath"},
		{@"ds\4-1.aiw",           "Level 13: Clearing the Bird's Nest"},
		{@"ds\21-1.aiw",          "Level 14: Unexpected Friend"},
		{@"ds\20-1.aiw",          "Level 15: The Architect"},
		{@"ds\5-1.aiw",           "Level 16: In the Vents"},
		{@"ds\33-1.aiw",          "Level 17: Send in the Car"},
		{@"ds\23-1.aiw",          "Level 18: Backup Arrives"},
		{@"ds\39-3.aiw",          "Level 19: The FBI Arrives"},
		{@"ds\33-2.aiw",          "Level 20: Bill Clay"},
		{@"ds\34-1.aiw",          "Level 21: Coulda Used his Shoes"},
		{@"ds\34-2.aiw",          "Level 22: I hate the Dark"},
		{@"ds\35-1.aiw",          "Level 23: R&D Lab"},
		{@"ds\subbasement-3.aiw", "Level 24: Fumbling in the Dark"},
		{@"ds\elevator-3.aiw",    "Level 25: A Fish in the Barrel"},
		{@"ds\39-4.aiw",          "Level 26: Karl's Revenge"},
		{@"ds\roof-2.aiw",        "Level 27: Everyone on the Roof"},
		{@"ds\30-4.aiw",          "Level 28: Just Like Saigon"},
		{@"ds\31-1.aiw",          "Level 39: Running the Gauntlet"},
		{@"ds\vault-2.aiw",       "Level 30: Still the Cowboy"}
	};

	settings.Add("Levels List");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value, "Levels List");

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.mapName == @"ds\mapName1.aiw" && !current.loading;
}

split {
	return current.mapName != old.mapName && settings[current.mapName];
}

isLoading {
	return current.loading;
}
