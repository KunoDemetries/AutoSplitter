// Original script by Kuno Demetries.
// Enhancements by Ero.

state("jericho") {
	int loading  : 0x3C1AFC;
	string22 map : 0x3C4E8A;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("Al-Khali",        "alk_tomb.dds",           "The Tomb"),
		tB("Al-Khali",        "alk_bunker_00.dds",      "Operation Vigil"),
		tB("Al-Khali",        "alk_city.dds",           "Al-Khali"),
		tB("Al-Khali",        "alk_bunker_01.dds",      "Green"),
		tB("Al-Khali",        "alk_final.dds",          "Man Down!"),
		tB("World War 2",     "wwii_pillboxes.dds",     "The Path of Souls"),
		tB("World War 2",     "wwii_mosque.dds",        "Blackwatch"),
		tB("World War 2",     "wwii_mosque_inside.dds", "Ambush"),
		tB("World War 2",     "wwii_vigil.dds",         "The Flames of Anger"),
		tB("World War 2",     "wwii_vigil_inside.dds",  "Exorcism"),
		tB("World War 2",     "wwii_bradenburg.dds",    "Bradenburg Gate"),
		tB("The Crusades",    "cru_labyrinh.dds",       "Motley Crew"),
		tB("The Crusades",    "cru_sewers.dds",         "Sewers"),
		tB("The Crusades",    "cru_keep.dds",           "Out of the Frying Pan..."),
		tB("The Crusades",    "cru_catacomb.dds",       "Tortured Souls"),
		tB("The Crusades",    "cru_chapel.dds",         "Black Rose"),
		tB("Roman Provinces", "rom_caldrium.dds",       "The Low road"),
		tB("Roman Provinces", "rom_tepidarium.dds",     "Decadence"),
		tB("Roman Provinces", "rom_palace_01.dds",      "Temple of Pain"),
		tB("Roman Provinces", "rom_palace_02.dds",      "Gardens of Hell"),
		tB("Roman Provinces", "rom_coloseum.dds",       "Morituri te Salutant"),
		tB("Roman Provinces", "rom_chamber.dds",        "Guts"),
		tB("Sumeria",         "sum_ziggurat_02.dds",    "Spiritual Guide"),
		tB("Sumeria",         "sum_ziggurat_03.dds",    "Skin"),
		tB("Sumeria",         "sum_ziggurat_04.dds",    "Flesh"),
		tB("Sumeria",         "sum_ziggurat_meat.dds",  "Blood"),
		tB("Sumeria",         "sum_ziggurat_05.dds",    "Sacrifice"),
		tB("Sumeria",         "sum_end.dds",            "Pyxis Prima")
	};

	settings.Add("Al-Khali");
	settings.Add("World War 2");
	settings.Add("The Crusades");
	settings.Add("Roman Provinces");
	settings.Add("Sumeria");

	foreach (var s in sB)
		settings.Add(s.Item2, true, s.Item3, s.Item1);

	vars.startMissions = new HashSet<string> {"alk_desert.dds", "wwii_biggates.dds", "cru_river.dds", "rom_outskirts.dds", "sum_ziggurat_01.dds"};

	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
	return current.loading == 0 && current.map != old.map && vars.startMissions.Contains(current.map);
}

split {
	return current.map.ToLower() != old.map.ToLower() && settings[current.map.ToLower()];
}

reset {
	return current.map == "Default.dds";
}

isLoading {
	return current.loading == 0;
}
