/*
This is the coolest ASL I've ever made, it works for both metro 2033 and metro last light for each launcher 
*/
state("metro", "Steam")
{
    int Loader : 0xCFAC30; // 1 loading / 0 not loading
    int Splitter : 0xD23810;
}

state("metro", "Epic")
{
    int Loader : 0xCD6690; // 1 loading / 0 not loading
    int Splitter :  0xD15790;
}

state("metro", "GoG") // This isn't needed as I could just set the gog version to the steam one, but I'd like to keep them seperate still
{
    int Loader : 0xCFAC30;
    int Splitter : 0xD23810;
}

init
{
     switch (modules.First().ModuleMemorySize) { // This is to know what version you are playing on
        case  20750336: version = "Steam"; 
            break;
        case 19550208: version = "Epic"; 
            break;
        case 20283392: version = "GoG"; 
            break;
        default:        version = ""; 
            break;
    }
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("2033", true, "All Chapters Metro 2033");
    settings.Add("Light", true, "Main Story Metro Last Light");
    settings.Add("LightNM", true, "New Missions Metro Last Light");

  var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    	{
            tB("2033","13613070", "Tower"),
            tB("2033","11364390", "Hunter"), 
            tB("2033","12111516","Exhibition"),
            tB("2033","23459760","Chase"),
            tB("2033","7555304","Riga"),
            tB("2033","43309382","Lost Tunnel"),
            tB("2033","5055304","Market"),
            tB("2033","17551496","Dead City"),
            tB("2033","11632932","Dry"),
            tB("2033","42393914","Ghosts"),
            tB("2033","24570920","Cursed"),
            tB("2033","22705244","Armory"),
            tB("2033","20191422","Front Line"),
            tB("2033","25020278","Trolley Combat"),
            tB("2033","28304314","Depot"),
            tB("2033","46971900","Defense"),
            tB("2033","18233862","Outpost"),
            tB("2033","25194692","Black Station"),
            tB("2033","12945624","Polis"),
            tB("2033","15794468","Alley"),
            tB("2033","15579794","Depository"),
            tB("2033","8224820","Archives"),
            tB("2033","14964468","Church"),
            tB("2033","21847646","Dark Star"),
            tB("2033","24894220","Cave"),
            tB("2033","27371888","D6"),
            tB("2033","40533228","Tower tB(2)"),
            tB("Light","10156116","Sparta"),
            tB("Light","10825266","Ashes"),
            tB("Light","1070380","Pavel"),
            tB("Light","4115038","Reich"),
            tB("Light","7994250","Seperation"),
            tB("Light","7519198","Facility"),
            tB("Light","25987280","Torchlight"),
            tB("Light","9097920","Echoes"),
            tB("Light","9156618","Bolshoi"),
            tB("Light","2142010","Korbut"),
            tB("Light","13314050","Revolution"),
            tB("Light","8270544","Regina"),
            tB("Light","11343060","Bandits"),
            tB("Light","15610894","Dark Water"),
            tB("Light","4525036","Venice"),
            tB("Light","11142052","Sundown"),
            tB("Light","11910180","Nightfall"),
            tB("Light","17885320","Undercity"),
            tB("Light","15690530","Contagion"),
            tB("Light","8137878","Quaratine"),
            tB("Light","11073562","Khane"),
            tB("Light","12986928","The Chase"),
            tB("Light","11808914","The Crossing"),
            tB("Light","12119850","Bridge"),
            tB("Light","10080826","Depot"),
            tB("Light","13882126","The Dead City"),
            tB("Light","15135450","Red Square"),
            tB("Light","9863802","The Garden"),
            tB("Light","4239678","Polis"),
            tB("Light","4005458","D6"),
            tB("LightNM","1948462","Heavy Squad"),
            tB("LightNM","8659570","Kshatriya"),
            tB("LightNM","12786154","Sniper Team"),
            tB("LightNM","4461344","Tower Pack"),
            tB("LightNM","11236060","spider Lair"),
            tB("LightNM","11230334","Pavel"),
            tB("LightNM","5808252","Khan"),
            tB("LightNM","6718786","Anna"),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Metro Redux",
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
    return ((old.Loader == 1) && (current.Loader == 0) && (settings[current.Splitter.ToString()]));
}

onStart
{
    vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
    vars.doneMaps.Add(current.Splitter.ToString()); // Adding for the starting map because it's also bad
}

split 
{
    if (settings[current.Splitter.ToString()] && (current.Loader != 0) && (!vars.doneMaps.Contains(current.Splitter.ToString()))) 
    {
        vars.doneMaps.Add(current.Splitter.ToString());
        return true;
    }
}

isLoading 
{
    return (current.Loader == 1);
}
