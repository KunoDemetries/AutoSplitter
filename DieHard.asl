state("Lithtech")
{
    string30 map : 0x000D739C, 0x30, 0x54, 0x48, 0x120, 0x20, 0x4;
    bool isLoading : 0xE1AF8;
}

startup
{
    settings.Add("diehardbro", true, "Levels List");

    vars.missions5 = new Dictionary<string,string> 
    { 
        {@"ds\map1.aiw","Level 1: Makatomi Plaza"},
        {@"ds\32-1.aiw","Level 2: False Alarm"},
        {@"ds\39-1.aiw","Level 3: The Bomber"},
        {@"ds\roof-1.aiw","Level 4: On the Roof"},
        {@"ds\39-2.aiw","Level 5: Down the Shaft"},
        {@"ds\38-2.aiw","Level 6: Welcome to the party"},
        {@"ds\basement-1.aiw","Level 7: High Maintenance"},
        {@"ds\parkade-1.aiw","Level 8: Argyte's Run"},
        {@"ds\basement-2.aiw","Level 9: PLayin' The Hero"},
        {@"ds\subbasement-1.aiw","Level 10: One of the Terrorists"},
        {@"ds\sewer-1.aiw","Level 11: Not my Day"},
        {@"ds\subbasement-2.aiw","Level 12: Aftermath"},
        {@"ds\4-1.aiw","Level 13: Clearing the Bird's Nest"},
        {@"ds\21-1.aiw","Level 14: Unexpected Friend"},
        {@"ds\20-1.aiw","Level 15: The Architect"},
        {@"ds\5-1.aiw","Level 16: In the Vents"},
        {@"ds\33-1.aiw","Level 17: Send in the Car"},
        {@"ds\23-1.aiw","Level 18: Backup Arrives"},
        {@"ds\39-3.aiw","Level 19: The FBI Arrives"},
        {@"ds\33-2.aiw","Level 20: Bill Clay"},
        {@"ds\34-1.aiw","Level 21: Coulda Used his Shoes"},
        {@"ds\34-2.aiw","Level 22: I hate the Dark"},
        {@"ds\35-1.aiw","Level 23: R&D Lab"},
        {@"ds\subbasement-3.aiw","Level 24: Fumbling in the Dark"},
        {@"ds\elevator-3.aiw","Level 25: A Fish in the Barrel"},
        {@"ds\39-4.aiw","Level 26: Karl's Revenge"},
        {@"ds\roof-2.aiw","Level 27: Everyone on the Roof"},
        {@"ds\30-4.aiw","Level 28: Just Like Saigon"},
        {@"ds\31-1.aiw","Level 39: Running the Gauntlet"},
        {@"ds\vault-2.aiw", "Level 30: Still the Cowboy"}
    };
 	
    foreach (var Tag in vars.missions5)
	{
		settings.Add(Tag.Key, true, Tag.Value, "diehardbro");
    };

    
  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
        vars.doneMaps.Clear();
		vars.doneMaps.Add(current.map);
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Die Hard Nakatomi Plaza",
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
    vars.doneMaps = new List<string>(); // You can accidently checkpoint yourself back to a previous level, so doneMaps needed 
}

start
{
   if ((current.map == @"ds\map1.aiw") && (current.isLoading == false)) 
   {
        vars.doneMaps.Clear();
		vars.doneMaps.Add(current.map);
        return true;
    }
}


split
{
	if ((current.map != old.map) && (settings[current.map]))
	{
		vars.doneMaps.Add(old.map);
		return true;	
	}
}

isLoading
{
    return current.isLoading;
}

exit 
{
    timer.OnStart -= vars.onStart;
}
