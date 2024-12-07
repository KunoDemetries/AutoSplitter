state("CoDWaW") 
{
    string50 CurrentLevelName : 0x5592B8; 
    bool Loader : 0x3172284; // Originally an int
    int HasControlLevelMak : 0x14ED874; //Used to start the timer at the beginning of Mak once you gain control
}

startup 
{
    settings.Add("Cutscene Time Fix", true, "Substract 62.55s from the timer after finishing TLTB");
	settings.Add("WAW", true, "All Missions");
		
	vars.missions = new Dictionary<string,string> 
		{ 
        	{"pel1", "Little Resistance"}, 
       		{"pel2", "Hard Landing"},
       		{"sniper", "Vendetta"},
       		{"see1", "Their Land, Their Blood"},
			{"pel1a", "Burn 'em Out"},
       		{"pel1b", "Relentless"},
       		{"see2", "Blood and Iron"},
       		{"ber1", "Ring of Steel"},
        	{"ber2", "Eviction"},
       		{"pby_fly", "Black Cats"},
       		{"oki2", "Blowtorch & Corkscrew"},
       		{"oki3","Breaking Point"},
       		{"ber3","Heart of the Reich"},
       		{"ber3b","Downfall"},
		};
    	foreach (var Tag in vars.missions) 
		{
   			settings.Add(Tag.Key, true, Tag.Value, "WAW");
  		}

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show 
		(
    	    "This game uses Time without Loads (Game Time) as the main timing method.\n"+
    	    "LiveSplit is currently set to show Real Time (RTA).\n"+
    	    "Would you like to set the timing method to Game Time? This will make verification easier",
    	    "LiveSplit | Call of Duty: World at War",
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
	vars.doneMaps = new List<string>(); // Coop runners can enter the wrong level by accident, so doneMaps needed
}

start
{
    if ((current.CurrentLevelName == "mak") && (current.HasControlLevelMak == 16384)) 
	{
        vars.doneMaps.Clear(); 
        return true;
    }
}

onStart
{
	vars.doneMaps.Clear();
}

isLoading
{
    return (!current.Loader);
}

update
{
	//massive shoutout to Ero for the help here. This is basically *adding* time to LiveSplits "loading times" which is then subtracting from RTA to display the time as LRT
    if (settings["Cutscene Time Fix"] && old.CurrentLevelName == "see1" && current.CurrentLevelName == "pel1a_load")
    {
        print("CTF Executed Succesfully");
        const double Offset = 62.55;
        timer.LoadingTimes += TimeSpan.FromSeconds(Offset);
    }
}

split
{
    if ((current.CurrentLevelName != old.CurrentLevelName) && (settings[current.CurrentLevelName]) && (!vars.doneMaps.Contains(current.CurrentLevelName)))
	{
        vars.doneMaps.Add(current.CurrentLevelName);
		return true;
	}			
}

reset 
{
	return (current.CurrentLevelName == "ui");
}

onReset
{
	vars.doneMaps.Clear();
}
