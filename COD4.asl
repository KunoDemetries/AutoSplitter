//original script by KunoDemetries
//cleaned up and some extra features by rythin
//modified pointers for expanded memory .exe file and fixed end split condition -Surviv0r
//fixed ending split for speedrun mod - Dev1ne

state("iw3sp", "V1.0") // Steam Version
{
  	int Loader :	0x10B1100;
	string20 CurrentLevelName :	0x6C3140;
	int EndSplit :	0xCDE4C8;
}



state("iw3sp", "V1.5") // Modified .exe to support more physical memory
{
  	int Loader :	0x1C75F4, 0x0;
	string20 CurrentLevelName :	0x4EA64, 0x50C;
	int EndSplit :	0xCDE4C8;
}

startup 
{
	settings.Add("CoD4", true, "Call of Duty 4");
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

	refreshRate = 30;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
        var timingMessage = MessageBox.Show 
		(
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Call of Duty 4: Modern Warfare",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init 
{
	vars.doneMaps = new List<string>(); // Actually needed because intel%
	vars.coupOffset = false;
	vars.currentTime = new TimeSpan(0, 0, 0);	//TimeSpan object used to add a timer offset after The Coup
	if (modules.First().ModuleMemorySize == 0x1D03000)
        version = "V1.0";
    else if (modules.First().ModuleMemorySize == 0x1D00EC2)
        version = "V1.5";
}

update 
{
	vars.currentTime = timer.CurrentTime.GameTime;	//keep the variable updated with the current time on the timer
}

start 
{
	//changed start condition to happen only after loading in rather than any time in the load
	return (current.CurrentLevelName == "killhouse" && current.Loader != 0 && old.Loader == 0);
}

onStart
{
	vars.doneMaps.Clear();		//clear the doneMaps list
	vars.coupOffset = false;
}

split 
{
	if ((current.CurrentLevelName != old.CurrentLevelName) && (!vars.doneMaps.Contains(current.CurrentLevelName)))
	{					//on map change
		if (current.CurrentLevelName == "coup") 
		{				//if the last map was The Coup. kuno note: Changed to do it on coup and not after it's skipped ie into the next level 
			vars.currentTime = timer.CurrentTime.GameTime;	//set a variable to the value of current time
			vars.coupOffset = true;				//add 4:44 to the timer
			if (settings["coup"]) 
			{				//if the split for The Coup is enabled
				vars.doneMaps.Add(old.CurrentLevelName);		//add the last map to done splits list
				return true;				//split
			}
		}	
		else 
		{						//if map is NOT The Coup
			if (settings[current.CurrentLevelName]) 
			{		//if setting for last map is enabled
				vars.doneMaps.Add(old.CurrentLevelName);	//add the last map to done splits list
				return true;			//split
			}
		}	
	}	
	//Endsplit for the game
	if (current.CurrentLevelName == "jeepride" && current.EndSplit != 147865) 
	{
		return true;
	}
	//Endsplit solution for speedrun mod
	else if (old.CurrentLevelName == "jeepride" && current.CurrentLevelName == "ac130")
	{
		return true;
	}
}   
 
reset 
{
	return (current.CurrentLevelName == "ui" && old.CurrentLevelName != "coup");
}

onReset
{
	vars.doneMaps.Clear();
}

gameTime 
{
	if (vars.coupOffset == true) 
	{					//when offset gets set to true
		vars.coupOffset = false;				//set it back to false
		return vars.currentTime.Add(new TimeSpan (0, 4, 44));	//set the timer to current timer time + 284s (4m44s)
	}
}

isLoading 
{
		return (current.Loader == 0) || (current.CurrentLevelName == "coup");
}

exit 
{
    timer.OnStart -= vars.onStart;
}
