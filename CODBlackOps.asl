state("BlackOps")
{
	string35 map : 0x21033E8; // Doesn't work for langagues other than English (idk why)
	long loading1: 0x356E7F4;	// Changed based on timing method changes by community vote
}

startup 
{
	settings.Add("missions", true, "Missions"); // Decided to add this just so it's like all the other ones

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


	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts (especially if manual start is used/ main start is disabled)
        {
		vars.USDDtime = false;
        });
	// Really helpful especially if runners for whatever reason have livesplit reset on USDD  
    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)  
        {        
        var timingMessage = MessageBox.Show (
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
	// I just like to give the customization for this just because forcing it to IGT no matter what seems like a shit thing to do
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
    if ((current.map == "cuba") && (current.loading1 != 0)) 
	{
		vars.USDDtime = false;
        return true;
    }
}

isLoading
{
	return (current.loading1 == 0) ||
	(current.map == "pentagon") || // Adding this because of the new timing method changed based on community vote
	(current.map == "frontend"); // Adding this just in case it because of the fact that sometimes frontend leaks during the crashed helicopter scenes (thanks 3arc)
}


reset
{
	return ((current.map == "frontend") && (old.map != "pentagon")); // Adding the old.map thing just because of new timing rules, prolly runners don't want to reset when leaving USDD 
}

split
{
    if ((settings[current.map]) && (current.map != old.map)) // If setting is true, and on a different map 
  	{
		if (current.map == "pentagon") // if were on USDD
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

exit 
{
    timer.OnStart -= vars.onStart;
}
