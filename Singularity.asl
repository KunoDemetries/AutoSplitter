/* This ASL is a testement as to why the saying "oh why does the ASL look like shit, why don't you find better addresses?"
    I want to be brutally honest here, the game is coded in such a way that it literally is impossible to find any one address
    that'll work without messing up passed Barslov's Lab; secondly, there are so many EMPTY functions within the game that I just feel like
    it'd be so impossible to just "find one." I really think Acti took a dev team of 10 people, split it to 2 groups and told them "figure it out"
    and figured it out they did because the game runs AMAZING, it plays AMAZING; but finding anything like you would find for a UE3 game is impossible.
    They somehow made an engine I'm familiar with and turned it into this monstosicty that has the inability to run correctly 
    without ductape and superglue holding it together
    Genuinely, it may be me here but I used the exact same methods I used for ol1/ol2, ds3, ds2, The Beast Inside and other UE3/UE4 games.
*/
state("Singularity")
{
    bool Loader : 0x17C6080; // 0 loading/1 not, btw as nobody puts it this is originally a byte 
    bool inControl : 0x18DA251; // 1 in control, 0 not
    string56 mapID1 : 0x0191A210, 0x14;
    string56 mapID2 : 0x018F74E4, 0x58, 0x3C, 0x18, 0x1E4, 0x2C;
    float zcoord : 0x18DE3B4; // prolly isn't the zcoord idk how the game orders it lol
}

startup
{
    settings.Add("SGL", true, "All Chapters");
        settings.Add("WD", true, "Workers' District");
        settings.Add("RF", true, "Research Facility");
        settings.Add("BT", true, "Barsiov's Tower");
        settings.Add("RL", true, "Rail Line");
        settings.Add("CD", true, "Central Dock");
        settings.Add("E99", true, "E99 Processing Complex");
        settings.Add("SL", true, "Singularity Labs");
        settings.Add("SP_SL3_kismet99", true, "End Split");


	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    	{
            //tB("WD", "SP_VI_intro_Kismet","After First Cutscene"), keeping this just incase 
            //tB("WD", "SP_VI2_kismet01", "Standing on The Dock"),
            tB("WD", "SP_RL1_kismet01", "Clicking Into Laptop"),
            tB("RF", "SP_RL2_kismet04", "Entering Underground Railway"),
            tB("RF", "SP_RL2_kismet02_1950", "Entering The Rift"),
            tB("RF", "SP_RL3_kismet03", "Returning from 1950"),
            tB("RF", "SP_RL5_kismet05", "Entering into the Battle Royal"),
            tB("BT", "SP_BT_A_kismet01", "Entering into Barsiov's Tower"),
            tB("RL", "orld.PersistentLevel.RCheckpoint_0", "Getting NTD Upgrade"),
            tB("RL", "orld.PersistentLevel.RCheckpoint_16", "Crane Skip"),
            tB("RL", "orld.PersistentLevel.RCheckpoint_6", "Rescued Kathryn"),
            tB("RL", "rain_intro", "Skipped Mother Phase Tick Fight"),
            tB("CD", "eck1", "Fixed boat and getting onto it"),
            tB("E99", "SP_WL1_kismet01", "Barsiov's Hut"),
            tB("E99", "SP_WL1_kismet04", "Skip through the badlands"),
            tB("E99", "SP_WL3_kismet04", "Repaired Bridge"),
            tB("E99", "SP_WL4_kismet08", "Top of elevator"),
            tB("E99", "P_WL6_kismet_1950.TheWorld.PersistentLevel.RCheckpoint_1", "Getting the E99 bomb charged and leaving"),
            tB("SL", "SP_SL1_kismet01", "Start of Singularity Tower"),
            tB("SL", "L2_kismet_p.TheWorld.PersistentLevel.RCheckpoint_5", "After recieving TMD amplifer mod"),
            //tB("", "", ""),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

    vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
        });
    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Singularity",
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
    vars.Splitter = false; // Just so I can throw everything in update
}

update
{
    if (settings[current.mapID1] && (!vars.doneMaps.Contains(current.mapID1)) || (settings[current.mapID2] && (!vars.doneMaps.Contains(current.mapID2))))
    {
        vars.doneMaps.Add(current.mapID1);
        vars.doneMaps.Add(current.mapID2); //Wouldn't matter if either of them get triggered as there is never a location where one split can affect another
        vars.Splitter = true;
    }
    else
    {
        vars.Splitter = false;
    }
    print(current.inControl.ToString());
}

start
{
    if (current.mapID1 == "SP_VI2_kismet01" && current.zcoord >= -37546.51953 && current.inControl == 1)  // scuffed but it changes within 5 seconds
    {
        vars.doneMaps.Clear();
        return true;
    }
}

split 
{
    if (vars.Splitter)
    {
        vars.Splitter = false;
        return true;
    }
}

isLoading
{
    return (!current.Loader);
}