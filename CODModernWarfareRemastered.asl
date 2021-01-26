// Original script by Kuno Demetries, rythin.
// Enhancements by Ero.

state("h1_sp64_ship", "Default") {
	string4 decide2  : 0x781FAC;
	string16 mapName : 0x443C652;
	string4 decide   : 0x6668D4C;
	int loading      : 0x1226507C;
}

state("h1_sp64_ship", "1.13") {
	string4 decide2  : 0x781FAC;
	string16 mapName : 0x45FF434;
	string4 decide   : 0x6668D4C;
	int loading      : 0x1240049C;
}

state("h1_sp64_ship", "1.15") {
	string4 decide2  : 0x781FAC;
	string16 mapName : 0x45FF196;
	string4 decide   : 0x6668D4C;
	int loading      : 0xB5C6570;
}

startup {
	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
	var sB = new List<Tuple<string, string, string>> {
		tB("Prologue", "cargoship", "Crew Expendable"),
		tB("Prologue", "coup", "The Coup"),
		tB("Act 1", "blackout", "blackout"),
		tB("Act 1", "ts_armada", "Charlie Dont Surf"),
		tB("Act 1", "ts_bog_a", "The Bog"),
		tB("Act 1", "hunted", "Hunted"),
		tB("Act 1", "ac130", "Death From Above"),
		tB("Act 1", "ts_bog_b", "War Pig"),
		tB("Act 1", "airlift", "Shock and Awe"),
		tB("Act 1", "aftermath", "Aftermath"),
		tB("Act 2", "village_assault", "Safe House"),
		tB("Act 2", "scoutsniper", "All Ghillied Up"),
		tB("Act 2", "sniperescape", "One Shot, One Kill"),
		tB("Act 2", "village_defend", "Heat"),
		tB("Act 2", "ambush", "The Sins of the Father"),
		tB("Act 2", "icbm", "Ultimatum"),
		tB("Act 3", "launchfacility_a", "All In"),
		tB("Act 3", "launchfacility_b", "No Fighting in The War Room"),
		tB("Act 3", "jeepride", "Game Over")
	};

	settings.Add("Prologue");
	settings.Add("Act 1");
	settings.Add("Act 2");
	settings.Add("Act 3");

	foreach (var s in sB)
		settings.Add(s.Item2, true, s.Item3, s.Item1);
}

init {
	if (current.decide == "1.15")       version = "1.15";
	else if (current.decide2 == "1.13") version = "1.13";
	else                                version = "Default";

	vars.coupOffset = false;
}

start {
	if (current.mapName == "killhouse" && current.loading == 0) {
		vars.coupOffset = false;
		return true;
	}
}

split {
	if (current.mapName != old.mapName) {
		if (current.mapName == "coup") vars.coupOffset = true;
		return settings[current.mapName];
	}
}

reset {
	return current.mapName == "ui" && old.mapName != "ui";
}

gameTime {
	if (vars.coupOffset) {
		vars.coupOffset = false;
		return timer.CurrentTime.RealTime.Add(new TimeSpan (0, 4, 45));
	}
}

isLoading {
	return version == "Default" ? current.loading == 0 : current.loading == 1;
}
