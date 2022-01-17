state("h1_sp64_ship")
{
	string4 decide: 0x6668D4C;
	string4 decide2: 0x781FAC;
}

state("h1_sp64_ship","default")
{
   int Loader : 0x1226507C;
	string200 CurrentLevelName : 0x443C652;
	string4 decide : 0x6668D4C;
	string4 decide2 : 0x781FAC;
}

state("h1_sp64_ship","1.13")
{
	int Loader : 0x1240049C;
	string200 CurrentLevelName : 0x45FF434;
	string4 decide : 0x6668D4C;
	string4 decide2 : 0x781FAC;
}

state("h1_sp64_ship","1.15")
{
	int Loader : 0x5005458;
	string200 CurrentLevelName : 0x45FF196;
	string4 decide : 0x6668D4C;
	string4 decide2 : 0x781FAC;
}

init
{
    if (current.decide == "1.15") 
	{
    version = "1.15";
    }

    if (current.decide2 == "1.13") 
	{
	version = "1.13";
    }

    if ((current.decide != "1.15") && (current.decide2 != "1.13")) 
	{
	version = "1.15";
    }

    vars.doneMaps = new List<string>(); 
	vars.coupOffset = false;
	vars.currentTime = new TimeSpan(0, 0, 0);
}

update 
{
	vars.currentTime = timer.CurrentTime.GameTime;	//keep the variable updated with the current time on the timer
}

startup 
{
  	settings.Add("CoD4", true, "Call of Duty 4 Remastered");
    settings.Add("act0", true, "Prologue", "CoD4");
    settings.Add("act1", true, "Act 1", "CoD4");
    settings.Add("act2", true, "Act 2", "CoD4");
    settings.Add("act3", true, "Act 3", "CoD4");

	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>> 
	{
		tB("act0","killhouse", "F.N.G."),
		tB("act0","cargoship", "Crew Expendable"), 
		tB("act0","coup", "The Coup"),
		tB("act1","blackout", "Blackout"),
		tB("act1","armada", "Charlie Dont Surf"),
		tB("act1","bog_a", "The Bog"),
		tB("act1","hunted", "Hunted"),	
		tB("act1","ac130", "Death From Above"),
		tB("act1","bog_b", "War Pig"),	
		tB("act1","airlift", "Shock and Awe"),
		tB("act1","aftermath", "Aftermath"),
		tB("act2","village_assault", "Safe House"),
		tB("act2","scoutsniper", "All Ghillied Up"), 
		tB("act2","sniperescape", "One Shot, One Kill"),
		tB("act2","village_defend", "Heat"),
		tB("act2","ambush", "The Sins of the Father"),
		tB("act3","icbm", "Ultimatum"),
		tB("act3","launchfacility_a", "All In"),
		tB("act3","launchfacility_b", "No Fighting in The War Room"),
		tB("act3","jeepride", "Game Over"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

}

start
{
	return ((current.CurrentLevelName == "killhouse") && (current.Loader == 1));
}

onStart
{
	vars.doneMaps.Clear();
}

split 
{
	if (current.CurrentLevelName != old.CurrentLevelName) 
	{
		if (current.CurrentLevelName == "coup") 
		{
			vars.currentTime = timer.CurrentTime.GameTime;	
			vars.coupOffset = true;
			
			if (settings["coup"]) 
			{				
				vars.doneMaps.Add(old.CurrentLevelName);		
				return true;
			}
		}
		else 
		{
			if (settings[current.CurrentLevelName]) 
			{	
				vars.doneMaps.Add(old.CurrentLevelName);
				return true;
			}
		}
		
	}
}   
 
reset
{
    return ((current.CurrentLevelName == "ui") && (old.CurrentLevelName != "ui"));
}

isLoading
{
	return (current.Loader == 0);

	if ((version == "default") && (current.loading1 == 0))
	{
		return true;
	}
}

gameTime
{
	if (vars.coupOffset == true) 
	{					
		vars.coupOffset = false;				
		return vars.currentTime.Add(new TimeSpan (0, 4, 45));	
	}
}
