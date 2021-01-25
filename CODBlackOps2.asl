state("t6sp")
{
	string65 map : 0xF4E62C;
	double loading1 : 0x1A002C0;
	string90 map2 : 0xC18138;
	int exit : 0x2578DF0;
}

startup
{
    vars.missions = new Dictionary<string,string> {  
		{"monsoon.all.sabs", "Celerium"},
		{"afghanistan.all.sabs", "Old Wounds"},
		{"nicaragua.all.sabs", "Time and Fate"},
		{"pakistan_1.all.sabs", "Fallen Angel"},
		{"karma_1.all.sabs", "Karma"},
		{"panama.all.sabs", "Suffer With Me"},
		{"yemen.all.sabs", "Achilles Veil"},
		{"blackout.all.sabs", "Odysseus"},
		{"la_1.all.sabs", "Cordis Die"},
		{"haiti.all.sabs", "Judgment Day"},
	}; 
		   foreach (var Tag in vars.missions) {
        settings.Add(Tag.Key, true, Tag.Value);
           }
           
    vars.loadings = new Dictionary<string,string> {
        {"fronted.english.sabs","cutscene1"},
        {"fronted.all.sabs","cutscene2"},
        {"ts_afghanistan.all.sabs","cutscene3"},
    };
        vars.missions1A = new List<string>();
        foreach (var Tag in vars.loadings) {
        vars.missions1A.Add(Tag.Key);
        }

    
  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.starter = 0;
            vars.endsplit = 0;
            vars.FuckFinalSplit = 0;
            vars.doneMaps.Clear();
            vars.doneMaps.Add(current.map.ToString());
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Black Ops 2",
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
    if ((current.map == "angola.all.sabs") && (current.loading1 != 0)) {
        vars.doneMaps.Clear();
        return true;
    }
}

isLoading
{
    if (current.map2 != "nicaragua_gump_josefina")
	{
		if ((current.loading1 == 0) ||
		((current.map2 == "su_rts_mp_dockside")) ||
		(vars.missions1A.Contains(current.map)))
        {
            return true;
        }

	else 
		{
			return false;
		}

	}	
}

split
{
    if (current.map != old.map) {
	    if (settings[current.map]) {
	            vars.doneMaps.Add(old.map);
				return true;
				}
        }

   if ((current.map2 == "haiti_gump_endings") && (current.exit != 0))
   {
       return true;
   }		
}

exit 
{
    timer.OnStart -= vars.onStart;
}
