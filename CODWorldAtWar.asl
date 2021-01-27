// The ASL has to work for coop and solo Any%, so this is gonna get annoying fast lol
state("CoDWaW") 
{
    string50 map : 0x5592B8; 
    int loading1 : 0x3172284;
    int squares1 : 0x14ED874;
    int Seen : 0x14E742C;
}

startup {
	settings.Add("act0", true, "Missions");
		
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
   			settings.Add(Tag.Key, true, Tag.Value, "act0");
  		}

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
    if ((current.map == "mak") && (current.squares1 == 16384)) 
	{
        vars.doneMaps.Clear(); 
        return true;
    }
}

isLoading
{
    return (current.loading1 == 0) ||
    ((current.map == "see1") && (current.Seen == 0)); // Because the level TLTB has the old timing method using the code seen to have the old method
}

reset 
{
	return (old.map != "ui");
}

split
{
    if ((current.map != old.map) && (settings[old.map]) && (!vars.doneMaps.Contains(current.map)))
	{
        vars.doneMaps.Add(old.map);
		return true;
	}			
}

exit 
{
    timer.OnStart -= vars.onStart;
}
