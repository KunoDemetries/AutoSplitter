state("GoW", "Epic 1.0.1") // Stating the game's .exe name, and the launcher and version number
{
    string80 CurrentObjective : 0x2232080; // Found by doing a string scan of the current objective playing (IS STATIC) Search any value in the startup than move the value backwards to add the realm name (super important it has to be done like this or the string will not read correctly in longer string names)
    int Loader : 0x2255648; // 257 during loads, 256 during cutscene loads, 0 during everything else (This value is somewhat hard if you don't have a NG+ save)
}

state("GoW", "Epic 1.0.2")
{
    string80 CurrentObjective : 0x2233080; 
    int Loader : 0x2256648;
}

state("GoW", "Epic 1.0.3")
{
    string80 CurrentObjective : 0x2234100;
    int Loader : 0x22576C8;
}

state("GoW", "Epic 1.0.4")
{
    string80 CurrentObjective : 0x2236380;
    int Loader : 0x2259948;
}

state("GoW", "Steam 1.0.2")
{
    string80 CurrentObjective : 0x2235CE0;
    int Loader : 0x22592A8; 
}

state("GoW", "Steam 1.0.6.1")
{
    string80 CurrentObjective : 0x2238FE0;
    int Loader : 0x225C5B0; 
}

init
{
	vars.doneMaps = new List<string>(); //Used for not splitting twice just in cause the game crashes

    switch (modules.First().ModuleMemorySize) 
    {
        case    83886080: version = "Epic 1.0.1";
            break;
        case    84807680: version = "Epic 1.0.2"; 
            break;
        case    84811776: version = "Epic 1.0.3";
            break;
        case    84819968: version = "Epic 1.0.4";
            break;
        case    85020672: version = "Steam v1.0.2"; 
            break;
        case    85032960: version = "Steam 1.0.6.1";
            break;
        default:        version = ""; 
            break;
    } 
    /* This will check the current module size for a game, generally they are different per update.
    you can find this by doing "print(modules.First().ModuleMemorySize.ToString());" inside of update through livesplit
    and use DebugViewer to see the value printed
    */

    vars.CurrentObjectiveParsed = "";
    vars.Parser = "";
    vars.Parser2 = "";
    vars.Splitter = false;
}

startup
{
    settings.Add("SES", false, "Split for non-English version?");
    settings.Add("SOC", false, "Split on completion of task?"); // Adding this as sometimes people like more customization of split location (superbly important for longer games)
    settings.Add("GoW", true, "God of War"); // used as the entire function head of the split settings
    settings.Add("TMT", true, "The Marked Trees", "GoW"); //Used to wrap all of the objectives to marked tree than to the GoW function
    settings.Add("PTTM", true, "Path to the Mountain", "GoW");
    settings.Add("ARB", true, "A Realm Beyond", "GoW");
    settings.Add("TLOA", true, "The Light of Alfheim", "GoW");
    settings.Add("ITM", true, "Inside the Mountain", "GoW");
    settings.Add("AND", true, "A New Destination", "GoW");
    settings.Add("TMC", true, "The Magic Chisel", "GoW");
    settings.Add("BTL", true, "Behind the Lock", "GoW");
    settings.Add("TS", true, "The Sickness", "GoW");
    settings.Add("TBlR", true, "The Black Rune", "GoW");
    settings.Add("RTTS", true, "Return to the Summit", "GoW");
    settings.Add("EFH", true, "Escape from Helheim", "GoW");
    settings.Add("APTJ", true, "A Path to Jotunheim", "GoW");
    settings.Add("BTR", true, "Between the Realms", "GoW");
    settings.Add("JIR", true, "Jotunheim in Reach", "GoW");
    settings.Add("MA", true, "Mother's Ashes", "GoW");
    settings.Add("TJH", true, "The Journey Home", "GoW");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        tB("TMT", "Midgard - Wildwoods - Hunt with Atreus", "Hunt with Atreus"),
        tB("TMT", "Midgard - Wildwoods - Defeat Dauði Kaupmaðr", "Defeat Dauði Kaupmaðr"),
        tB("TMT", "Midgard - Wildwoods - Return to the house", "Return to the house"),
        tB("TMT", "Midgard - Wildwoods - Defeat the Stranger", "Defeat the Stranger"),
        tB("PTTM", "The River Pass - Journey to the Mountain", "Journey to the Mountain"),
        tB("PTTM", "The River Pass - Continue towards the mountain", "Continue towards the mountain"),
        tB("PTTM", "The River Pass - Escape the ruins", "Escape the ruins"),
        tB("PTTM", "The River Pass - Fight off the Reavers", "Fight off the Reavers"),
        //tB("PTTM","Escape the ruins","Escape the ruins"),   In the event of a mission appearing again, I'm just counting it as it wasn't finished originally as it'd be annoying figuring something out for duplicates
        tB("PTTM", "The River Pass - Throw your ax at the trees", "Throw your ax at the trees"),
        tB("PTTM", "The River Pass - Proceed through the gate to the mountain", "Proceed through the gate to the mountain"),
        tB("PTTM", "The River Pass - Hunt with Atreus", "Hunt with Atreus (again)"),
        tB("PTTM", "Sanctuary Grove - Follow the Witch", "Follow the Witch"),
        tB("PTTM", "Sanctuary Grove - Collect the white-petaled flower", "Collect the white-petaled flower"),
        tB("PTTM", "The River Pass - Get to the boat", "Get to the boat"),
        tB("PTTM", "The River Pass -Boat towards daylight ", "Boat towards daylight"),
        tB("PTTM", "Shores of Nine - Dock at the bridge", "Dock at the bridge"),
        tB("PTTM", "Shores of Nine - Investigate the temple and bridge", "Investigate the temple and bridge"),
        tB("PTTM", "Brok’s Shop - Make your way to the Tower", "Make your way to the Tower"),
        tB("PTTM", "Shores of Nine - Pass through the tower and caves", "Pass through the tower and caves"),
        tB("PTTM", "Foothills - Continue towards the mountain", "Continue towards the mountain (Foothills)"),
        tB("ARB", "Foothills - Follow the Witch", "Follow the Witch (Foothills)"),
        tB("TLOA", "Realm Travel Room - Travel to Alfheim", "Travel to Alfheim"),
        tB("TLOA", "Týr’s Bridge - Find a way to the Light", "Find a way to the Light"),
        tB("TLOA", "Lake of Light - Get to the Ringed Temple", "Get to the Ringed Temple"),
        tB("TLOA", "Lake of Light - Find a way into the temple", "Find a way into the temple"),
        tB("TLOA", "Lake of Light - Reactivate the Ringed Temple bridge", "Reactivate the Ringed Temple bridge"),
        tB("TLOA", "Lake of Light - Go back up to the Ringed Temple bridge", "Go back up to the Ringed Temple bridge"),
        tB("TLOA", "Lake of Light - Find another way into the temple", "Find another way into the temple"),
        tB("TLOA", "Lake of Light - Find a way into the hive", "Find a way into the hive"),
        tB("TLOA", "The Dusk Veil - Investigate the hive", "Investigate the hive"),
        tB("TLOA", "The Dusk Veil - Destroy the hive and claim the Light", "Destroy the hive and claim the Light"),
        tB("TLOA", "Lake of Light - Find a way out of the temple", "Find a way out of the temple"),
        tB("TLOA", "Lake of Light - Return to the boat", "Return to the boat"),
        tB("TLOA", "Lake of Light - Use the sand bowl lift", "Use the sand bowl lift"),
        tB("TLOA", "Lake of Light - Return to Týr’s Temple", "Return to Týr’s Temple"),
        tB("TLOA", "Lake of Light - Realm travel back to Midgard", "Realm travel back to Midgard"),
        tB("TLOA", "Realm Travel Room - Return to the Mountain", "Return to the Mountain"),
        tB("TLOA", "Shores of Nine - Go back through the tower", "Go back through the tower"),
        tB("ITM", "Foothills - Ascend the mountain", "Ascend the mountain"),
        tB("ITM", "The Mountain - Traverse the dark caves", "Traverse the dark caves"),
        tB("ITM", "The Mountain - Ascend the Cave Shaft", "Ascend the Cave Shaft"),
        tB("ITM", "The Mountain - Free the chain", "Free the chain"),
        tB("ITM", "The Mountain - Find a way to ascend", "Find a way to ascend"),
        tB("ITM", "The Mountain - Reach the summit", "Reach the summit"),
        tB("AND", "The Summit - Take Mimir’s head to the Witch", "Take Mimir’s head to the Witch"),
        tB("AND", "Shores of Nine - Return to the Witch’s Cave", "Return to the Witch’s Cave"),
        tB("AND", "The River Pass - Talk to the Witch in her house", "Talk to the Witch in her house"),
        tB("AND", "The River Pass - Return to the boat", "Return to the boat"),
        tB("AND", "The River Pass - Go to the Serpent’s horn", "Go to the Serpent’s horn"),
        tB("TMC", "Shores of Nine - Follow Mimir’s instructions to the chisel", "Follow Mimir’s instructions to the chisel"),
        tB("TMC", "Northern Dock - Investigate the dead Giant", "Investigate the dead Giant"),
        tB("TMC", "Thamur’s Corpse - Retrieve a piece of the chisel", "Retrieve a piece of the chisel"),
        tB("TMC", "Thamur’s Corpse - Find a way to break the ice", "Find a way to break the ice"),
        tB("TMC", "Thamur’s Corpse - Talk to Sindri", "Talk to Sindri"),
        tB("TMC", "Thamur’s Corpse - Find a way to the hammer", "Find a way to the hammer"),
        tB("TMC", "Thamur’s Corpse - Make your way up the hammer", "Make your way up the hammer"),
        tB("TMC", "Thamur’s Corpse - Release the strap", "Release the strap"),
        tB("TMC", "The Hammer Head - Find a way to the hammer’s head", "Find a way to the hammer’s head"),
        tB("TMC", "Thamur’s Corpse - Make your way to the chisel", "Make your way to the chisel"),
        tB("BTL", "The Giant’s Chisel - Return to the boat", "Return to the boat"),
        tB("BTL", "Northern Dock - Return to the Lake of Nine", "Return to the Lake of Nine"),
        tB("BTL", "Shores of Nine - Go to Týr’s Vault", "Go to Týr’s Vault"),
        tB("BTL", "Týr’s Vault - Ask Freya for help", "Ask Freya for help"),
        tB("TS", "The River Pass - Use Freya’s boat to return home", "Use Freya’s boat to return home"),
        tB("TS", "Wildwoods - Return to the Realm Travel Room", "Return to the Realm Travel Room"),
        tB("TS", "Realm Travel Room - Reach the Bridge Keeper", "Reach the Bridge Keeper"),
        tB("TS", "Bridge Of The Damned - Defeat the Bridge Keeper", "Defeat the Bridge Keeper"),
        tB("TS", "Bridge Of The Damned - Return to the Realm Travel Room", "Return to the Realm Travel Room"),
        tB("TS", "Realm Travel Room - Deliver the heart to Freya", "Deliver the heart to Freya"),
        tB("TBlR", "The River Pass - Enter the boat", "Enter the boat"),
        tB("TBlR", "Shores of Nine - Return to Týr’s Vault", "Return to Týr’s Vault"),
        tB("TBlR", "Týr’s Vault - Retrieve the Black Rune", "Retrieve the Black Rune"),
        tB("TBlR", "Týr’s Vault - Escape the trap", "Escape the trap"),
        tB("TBlR", "Týr’s Vault - Exit Týr’s Vault", "Exit Týr’s Vault"),
        tB("RTTS", "Shores of Nine - Journey back to the mountain", "Journey back to the mountain"),
        tB("RTTS", "The Mountain - Find a new path up to the summit", "Find a new path up to the summit"),
        tB("RTTS", "The Mountain - Continue towards the summit", "Continue towards the summit"),
        tB("RTTS", "The Summit - Open the bridge to Jötunheim", "Open the bridge to Jötunheim"),
        tB("RTTS", "The Summit - Catch Baldur", "Catch Baldur"),
        tB("EFH", "Helheim Landing - Find a way out of Helheim", "Find a way out of Helheim"),
        tB("EFH", "Helheim Landing - Use the ship", "Use the ship"),
        tB("EFH", "Helheim Landing - Escape Helheim", "Escape Helheim"),
        tB("APTJ", "Secret Chamber of Odin - Realm travel back to Midgard", "Realm travel back to Midgard"),
        tB("APTJ", "Realm Travel Room - Show Týr’s key plans to Brok", "Show Týr’s key plans to Brok"),
        tB("APTJ", "Brok’s Shop - Locate Týr’s mysterious door", "Locate Týr’s mysterious door"),
        tB("APTJ", "The Hall of Týr - Explore Týr’s hidden chamber", "Explore Týr’s hidden chamber"),
        tB("APTJ", "The Hall of Týr - Break the chains", "Break the chains"),
        tB("APTJ", "The Hall of Týr - Go back up and flip the temple", "Go back up and flip the temple"),
        tB("BTR", "Realm Travel Room - Explore the Realm Between Realms", "Explore the Realm Between Realms"),
        tB("BTR", "Realm Travel Room - Take the Unity Stone to the precipice", "Take the Unity Stone to the precipice"),
        tB("BTR", "Jötunheim Tower - Investigate the Jötunheim tower", "Investigate the Jötunheim tower"),
        tB("BTR", "Jötunheim Tower - Survive the gauntlet of realms", "Survive the gauntlet of realms"),
        tB("JIR", "Realm Travel Room - Talk to Brok and Sindri", "Talk to Brok and Sindri"),
        tB("JIR", "Shores of Nine - Boat into the Serpent’s mouth", "Boat into the Serpent’s mouth"),
        tB("JIR", "Belly of the Beast - Find Mimir’s eye", "Find Mimir’s eye"),
        tB("JIR", "Thamur’s Corpse - Defeat Baldur", "Defeat Baldur"),
        tB("MA", "Thamur’s Corpse - Return to the Realm Travel Room", "Return to the Realm Travel Room"),
        tB("MA", "Jötunheim - Find Jötunheim’s highest peak", "Find Jötunheim’s highest peak"),
        tB("MA", "Jötunheim - Scatter her ashes", "Scatter her ashes"),
    };
    foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);   

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | God of War (2018)",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

update
{
    int ObjectiveLength = current.CurrentObjective.Length;

    if(ObjectiveLength > 45) // I have to add this as the last few objectives only have location - objective name, most likely due to the fact the realm has nothing in it
    {
        if (settings["SOC"])  // To conserve creating 6 different variables, I'm just under the assumption the user of the ASL wouldn't tick the setting e/d during the run.
        {
            vars.Parser = old.CurrentObjective.Split('-'); // Splitting the string into three different parts based on the symbol '-'. The string typically prints realm - location - objective name
            vars.Parser2 = vars.Parser[1] + "-" + vars.Parser[2];  // Deleting the first realm split and simplifying it down to location - objective (parse 1 is location, parse 2 is objective name)
            vars.CurrentObjectiveParsed = vars.Parser2.Remove(0,1); // I'm removing the front end space as split keeps everything relative to the '-' symbol
        }
        else
        {
            vars.Parser = current.CurrentObjective.Split('-'); 
            vars.Parser2 = vars.Parser[1] + "-" + vars.Parser[2];  
            vars.CurrentObjectiveParsed = vars.Parser2.Remove(0,1);
        }   
    }// I could relatively simplify this down even more to using a single var instead of current vs old and passing it through the split and parse, but I'm trying to limit the startup process.
    else // Passing the string through as it's most likely the last few splits or the very first objective that we can ignore for obvious reasons.
    {
        vars.CurrentObjectiveParsed = current.CurrentObjective;
    }

    if (!settings["SES"]) // Just to save me the migraine of recoding for different langauges, this is pretty much only a test at this point 
    {
        if ((settings[vars.CurrentObjectiveParsed.ToString()]) && (!vars.doneMaps.Contains(vars.CurrentObjectiveParsed.ToString())) && (current.CurrentObjective != old.CurrentObjective)) 
        // Checking to see if the current/old objective is a setting   seeing if we have split previously for it                          seeing if we changed objectives and not on a previous one
        {
            vars.doneMaps.Add(vars.CurrentObjectiveParsed.ToString()); // Adding the split we currently split on to the doneMaps list to remove it from the split settings
            vars.Splitter = true;
        }
    }
    else
    {
        if ((!vars.doneMaps.Contains(current.CurrentObjective)) && (current.CurrentObjective != old.CurrentObjective))
        {
            vars.doneMaps.Add(current.CurrentObjective);
            vars.Splitter = true;
        }
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
    return (current.Loader != 0);
}

onStart  // Clearing the doneMaps on start, most likely could do it either on start or reset, but I usually find start is slightly better for games where the first objective isn't a setting for splits
{
    vars.doneMaps.Clear();
}