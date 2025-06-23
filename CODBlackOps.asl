state("BlackOps")
{
	string35 currentlevelName : 0x21033E8; // Doesn't work for langagues other than English (idk why)
	long Loader : 0x2AEA4B0;	// Changed based on timing method changes by community vote
	bool Loader2 : 0x3CE1594;	// aciidz: this alone would probably be fine but apparently some cutscenes need to be removed from loads so we'll use this in tandem with the other one
}

startup 
{
	settings.Add("missions", true, "All Missions"); // Decided to add this just so it's like all the other ones

	vars.missions = new Dictionary<string,string> 
	{ 
	  	{"vorkuta", "Vorkuta"},
		{"pentagon", "USDD"},
		{"flashpoint", "Executive Order"},
		{"khe_sanh", "SOG"},
		{"hue_city", "The Defector"},
		{"kowloon", "Numbers"},
		{"fullahead", "Project Nova"},
		{"creek_1", "Victor Charlie"},
		{"river", "Crash Site"},
		{"wmd_sr71", "WMD"},
		{"pow", "Payback"}, 
		{"rebirth", "Rebirth"},
		{"int_escape", "Revelations"},
		{"underwaterbase", "Redemption"},
		{"outro", "Menu Screen"},
	}; 
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)  
    {        
    	var timingMessage = MessageBox.Show 
		(
        	"This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Call of Duty: Black Ops",
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
	vars.currentTime = new TimeSpan(0, 0, 0);	//TimeSpan object used to add a timer offset on entering USDD
	vars.USDDtime = false;
}

update
{
	vars.currentTime = timer.CurrentTime.GameTime;	//keep the variable updated with the current time on the timer

}

start
{
    return ((current.currentlevelName == "cuba") && (current.Loader != 0 && !current.Loader2));
}

onStart
{
	vars.USDDtime = false;
}

isLoading
{
	return (current.Loader == 0 || current.Loader2) ||
	(current.currentlevelName == "pentagon") || // Adding this because of the new timing method changed based on community vote
	(current.currentlevelName == "frontend"); // Adding this just in case it because of the fact that sometimes frontend leaks during the crashed helicopter scenes (thanks 3arc)
}

reset
{
	return ((current.currentlevelName == "frontend") && (old.currentlevelName != "pentagon")); // Adding the old.map thing just because of new timing rules, prolly runners don't want to reset when leaving USDD 
}

split
{
    if (current.currentlevelName != old.currentlevelName && settings.ContainsKey(current.currentlevelName) && settings[current.currentlevelName]) // If setting is true, and on a different map 
  	{
		if (current.currentlevelName == "pentagon") // if were on USDD
		{
			vars.USDDtime = true; // adds game time of 4:55
			return true;
		}
		else // if not on USDD split
		{
			return true;
		}
	}
}			

gameTime 
{
	if (vars.USDDtime == true) 
	{					
		vars.USDDtime = false;				
		return vars.currentTime.Add(new TimeSpan (0, 4, 55));	//Time taken from the mean of most of the submitted any% runs
	}
}
