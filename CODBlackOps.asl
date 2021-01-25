state("BlackOps")
{
	string70 map : 0x21033E8;
	long loading1: 0x1656804;	
}

startup 
{
	vars.missions = new Dictionary<string,string> { 
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
    foreach (var Tag in vars.missions) {
    settings.Add(Tag.Key, true, Tag.Value);
    };

    
  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
        vars.doneMaps.Clear();
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
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

}

init 
{
	vars.doneMaps = new List<string>(); 
}

start
{
    if ((current.map == "cuba") && (current.loading1 != 0)) {
        vars.doneMaps.Clear();
        return true;
    }
}

isLoading
{
	return (current.loading1 == 0);
}


reset
{
	return (current.map == "frontend");
}

split
{
    if ((current.map != old.map) && (vars.doneMaps != old.maps))
    {
	    if (settings[current.map]) 
      {
	      vars.doneMaps.Add(old.map);
				return true;
			}
    }			
}


exit 
{
    timer.OnStart -= vars.onStart;
}
