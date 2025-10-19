state("DMC-DevilMayCry", "1.0")
{
	int loading : "DMC-DevilMayCry.exe", 0x273F0F8, 0x5B4;
    string20 Checkpoint : 0x111; // I was told not to worry about V1.0 as nobody runs on it, but I have to add this in the code or it won't init 
}

state("DMC-DevilMayCry", "Last Version Before 2025 Update")
{
	int loading : "DMC-DevilMayCry.exe", 0x2759300, 0x5B4;
    string50 Checkpoint : 0x2733378, 0x560, 0x0;
}

state("DMC-DevilMayCry", "Current")
{
	int loading : "DMC-DevilMayCry.exe", 0x27521C0, 0x5B4;
    string50 Checkpoint : 0x272C328, 0x560, 0x0;
}

init
{
	vars.isLoading = false;
	switch(modules.First().ModuleMemorySize)
	{
		case 47788032:
			version = "1.0";
			break;
		case 47902720:
			version = "Last Version Before 2025 Update";
			break;
		default:
			version = "Current";
			break;
	}
    vars.doneMaps = new List<string>(); 
}

startup
{
    settings.Add("DMC", true, "Devil May Cry");
    settings.Add("Ver", true, "Vergil's Downfall");
    settings.Add("Sec", true, "Secret Mission");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>> 
    {
        tB("DMC", "ch1_main", "Found"),
        tB("DMC", "ch2_main", "Home Truths"),
        tB("DMC", "ch4_main", "Bloodline"), 
        tB("DMC", "ch5_main", "Under Watch"),
        tB("DMC", "ch6_main", "Virility"),
        tB("DMC", "ch7_main", "Secret Ingredient"),
        tB("DMC", "ch8_main", "Overturn"),
        tB("DMC", "ch9A_main", "Eyeless"),
        tB("DMC", "ch9B_main", "Devil Inside"),
        tB("DMC", "ch10_main", "Bad News"),
        tB("DMC", "ch11_main", "The Order"),
        tB("DMC", "ch12_main", "Under Siege"),
        tB("DMC", "ch13_main", "Devil's Dalliance"),
        tB("DMC", "ch14_main", "Last Dance"),
        tB("DMC", "ch15_main", "The Trade"),
        tB("DMC", "ch16_main", "The Plan"),
        tB("DMC", "ch17_main", "Furnace of Souls"),
        tB("DMC", "ch18_main", "Demon's Den"),
        tB("DMC", "ch19_main", "Face of The Demon"),
        tB("DMC", "ch20_main", "The End"),
        tB("Ver", "DLC1_Ch1_main", "Personal Hell New Game"),
		tB("Ver", "DLC1_ch1_main", "Personal Hell New Game+"),
        tB("Ver", "DLC1_ch2_main", "Hollow"),
        tB("Ver", "DLC1_ch3_main", "Power Struggle"),
        tB("Ver", "DLC1_ch4_main", "Heartless"),
        tB("Ver", "DLC1_ch5_main", "Own Shadow"),
        tB("Ver", "DLC1_ch6_main", "Another Chance"),
        tB("Sec", "SecretMission01_Main", "Air Brawl"),
        tB("Sec", "SecretMission02_Main", "Simple Traversal"),
        tB("Sec", "SecretMission03_Main", "Simple Eradication"),
        tB("Sec", "SecretMission04_Main", "Demonic Conflict"),
        tB("Sec", "SecretMission05_Main", "Angelic Warfare"),
        tB("Sec", "SecretMission06_Main", "Rapid Descent"),
        tB("Sec", "SecretMission07_Main", "A Taste of Heaven"),
        tB("Sec", "SecretMission08_Main", "Stylish Victory"),
        tB("Sec", "SecretMission09_Main", "Bait and Switch"),
        tB("Sec", "SecretMission10_Main", "The Power Within"),
        tB("Sec", "SecretMission11_Main", "What Goes Around"),
        tB("Sec", "SecretMission12_Main", "Moderate Traversal"),
        tB("Sec", "SecretMission13_Main", "Flawless Conquest"),
        tB("Sec", "SecretMission14_Main", "Colossal Triumph"),
        tB("Sec", "SecretMission15_Main", "Hasty Acquistion"),
        tB("Sec", "SecretMission16_Main", "Displaced Skirmish"),
        tB("Sec", "SecretMission17_Main", "Divergent Slaugher"),
        tB("Sec", "SecretMission18_Main", "Extreme Traversal"),
        tB("Sec", "SecretMission19_Main", "A Day In Hell"),
        tB("Sec", "SecretMission20_Main", "Subsistence"),
        tB("Sec", "SecretMission21_Main", "Shenanigans"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

        	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
            var timingMessage = MessageBox.Show 
            (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? Mods do not retime loading screens for this game, if you do not use this your run will not be retimed",
                "LiveSplit | DMC: Devil May Cry",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	    
}

start // Just for ILs I'mma have it start on every entrance to each IL
{
    if (settings[current.Checkpoint] && (current.loading != 0))
    {
        vars.doneMaps.Clear();
        vars.doneMaps.Add(current.Checkpoint);
        return true;
    }
}

split 
{
    if (settings[current.Checkpoint] && (current.loading != 0) && (!vars.doneMaps.Contains(current.Checkpoint)))
    {
        vars.doneMaps.Add(current.Checkpoint);
        return true;
    }
}

isLoading
{
	return current.loading != 0;
}

reset // Adding for Vergil's Downfall Runners per Their Request
{
	if (current.loading != 0 && current.Checkpoint == "mainmenu_startup_vergil") {
		return true;
	}
}
