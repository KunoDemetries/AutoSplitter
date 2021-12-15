// Gotta love .exe changes so you don't need an identifer 
state("SniperElite4_DX11") 
{
    string16 map : 0xEB0BEB;
    float loading1 : 0xCFCAF0;
    byte loading : 0xBE1F37;
    float islandload : 0xC15A90;
    int endscene : 0xB67E60;
}

state("SniperElite4_DX12") 
{
	string16 map :  0xE5A2AB;
	float loading1 : 0xE55958;
	byte loading : 0xB2007F;
	float islandload : 0xB683E0;
	int endscene : 0xAA5E98;
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
		{ 
    		{"Marina", "Bianti Village"},
    	    {"Viaduct", "Regilino Viaduct"},
    	    {"Dockyard", "Lorino Dockyard"},
    	    {"Monte_Cassino", "Abrunza Monastery"},
    		{"Coastal_Facility", "Magazzeno Facility"},
    	    {"Forest", "Giovi Fiorini Mansion"},
    	    {"Fortress", "allagra Fortress"},
		};
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

    vars.onStart = (EventHandler)((s, e) => 
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
                "LiveSplit | Sniper Elite 4",
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
	vars.doneMaps = new List<string>(); // You get kicked to the main menu, so adding this just in case
}

start
{
	if ((current.map == "Island") && (current.loading != 1) && (current.loading1 != 0))
	{
		vars.doneMaps.Clear();
		return true;		
	}
}

split
{
	if ((current.map != old.map) && (settings[current.map]) && (!vars.doneMaps.Contains(current.map)) || ((current.endscene == 1)) && ((current.map == "Fortress")))
	{
		vars.doneMaps.Add(current.map);
		return true;		
	}
}

reset
{
	return ((current.map == "Island") && (old.map != "Island"));
}

isLoading
{
	return ((current.loading == 1));
}

exit 
{
    timer.OnStart -= vars.onStart;
}
