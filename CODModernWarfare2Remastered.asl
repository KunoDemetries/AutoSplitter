// help from Klooger on some of the addresses
state("MW2CR")
{
	string6 decide: 0xA9809F;
    string50 CurrentMapName : 0x41758D1;
	int Loader : 0x4B894F0;
}

state("MW2CR", "Default")
{
	string50 CurrentMapName : 0x42187F6;
	byte Loader : 0x6509784;
	string6 decide : 0xA9809F;
}

state("MW2CR", "1.1.12")
{
	string50 CurrentMapName : 0x41758D1;
	int Loader : 0x4B894F0;
	string6 decide : 0x11BAC56C;
}

state("MW2CR", "1.1.13")
{
	string50 CurrentMapName : 0x41767F6;
	byte Loader : 0x4B8A4F0;
}

init
{
    // I have to leave this in as I don't own 1.1.12 or the orignal 1.0 version
	if (current.decide == "1.1.12") 
	{
    	version = "1.1.12";
  	}
	else 
	{
    version = "Default";
  	}
      
    if ( modules.First().ModuleMemorySize == 300334080)
    {
        version = "1.1.13";
    }

	vars.doneMaps = new List<string>(); // Just in case intel% is added in the future (been talks) just adding a doneMaps just in case
}

startup 
{
    settings.Add("acta", true, "All Acts");
    settings.Add("act1", true, "Act 1", "acta");
    settings.Add("act2", true, "Act 2", "acta");
    settings.Add("act3", true, "Act 3", "acta");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    	{
			//tB("act1","trainier", "S.S.D.D."), 
			tB("act1","roadkill", "Team Player"),
			tB("act1","cliffhanger", "Cliffhanger"),
			tB("act1","airport", "No Russian"),
			tB("act1","favela", "Takedown"),
			tB("act2","invasion", "Wolverines"),
			tB("act2","favela_escape", "The Hornets Nest"),
			tB("act2","arcadia", "Exodus"),
			tB("act2","oilrig", "The Only Easy Day Was Yesterday"),
			tB("act2","gulag", "The Gulag"),
			tB("act2","dcburning", "Of Their Own Accord"),
			tB("act3","contingency", "Contingency"),
			tB("act3","dcemp", "Second Sun"), 
			tB("act3","dc_whitehouse", "Whiskey Hotel"),
			tB("act3","estate", "Loose Ends"),
			tB("act3","boneyard", "The Enemy of My Enemy"),
			tB("act3","af_caves", "Just Like Old Times"),
			tB("act3","af_chase", "Endgame"),
			tB("act3","ending", "End"),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        	var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Modern Warfare 2 Remastered",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	
}

start
{
	return ((current.CurrentMapName == "trainer") && (current.Loader != 0));
}

update
{
        print(modules.First().ModuleMemorySize.ToString());
}

onStart
{
	vars.doneMaps.Add(current.CurrentMapName);
}

isLoading
{
    return (current.CurrentMapName == "ui") || (current.Loader == 0) || (current.CurrentMapName == "airport");
}
 
reset
{
    return ((current.CurrentMapName == "ui") && (old.CurrentMapName != "ui"));
}

onReset
{
	vars.doneMaps.Clear();
}

split
{
	if ((current.CurrentMapName != old.CurrentMapName) && (settings[current.CurrentMapName]) && (!vars.doneMaps.Contains(current.CurrentMapName))) 
	{
		vars.doneMaps.Add(current.CurrentMapName);
		return true;	
	}	
}
