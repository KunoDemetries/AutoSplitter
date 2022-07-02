/*state("GWT", "1.02")
{
    // flips between 1 in game and 2 on loads
    int loadingNormal : 0x55211C0; 
    // 0 in game & 112 while Fast Travelling as well as a couple specific cutscene - these cutscenes are now removed on purpose since this issue wasn't discovered for a couple months.
    int loadingFT     : 0x57077D8; 
    string300 CurTextString : 0x057665F8, 0xC0, 0X28, 0X0;
}
*/
state("GWT")
{
    int loadingNormal : 0x5411388;
    int loadingFT : 0x570F818;
    string300 CurTextString : 0x0576E640, 0xC0, 0X28, 0X0;
}

init 
{
    vars.doneMaps = new List<string>(); 
    vars.allObjs = new List<string>();
    vars.DoSplit = false;
    // Basically finding and naming the exe we want to target as I understand it
    switch(modules.First().ModuleMemorySize)
    {
	case 688128 :
        version = "wrongEXE";
        break;
    }

    // Now using the exe we found earlier, we can tell livesplit to leave it alone and find the correct exe we want to read from
    if (version == "wrongEXE") 
    {
        var allComponents = timer.Layout.Components;
        // Grab the autosplitter from splits
        if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) 
        {
            allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
        }
        foreach (var component in allComponents) 
        {
            var type = component.GetType();
            if (type.Name == "ASLComponent") 
            {
                // Could also check script path, but renaming the script breaks that, and
                //  running multiple autosplitters at once is already just asking for problems
                var script = type.GetProperty("Script").GetValue(component);
                script.GetType().GetField(
                    "_game",
                    BindingFlags.NonPublic | BindingFlags.Instance
                ).SetValue(script, null);
            }
        }
        return;
    }
}

startup
{
    refreshRate = 30;
    settings.Add("GT", true, "Ghostwire: Tokyo");
        settings.Add("CH1", true, "Chapter 1: Beginnings", "GT");
            settings.Add("COS", true, "City of Shadows", "CH1");
        settings.Add("Chapter 2: Trouble", true, "Chapter 2: Trouble", "GT");
            settings.Add("K.K", true, "KK", "Chapter 2: Trouble");
            settings.Add("CTF", true, "Clearing the Fog", "Chapter 2: Trouble");
            settings.Add("AMOFD", true, "A Maze of Death", "Chapter 2: Trouble");
            settings.Add("TBL", true, "The Buried Life", "Chapter 2: Trouble");
            settings.Add("TCOS", true, "The Caves of Steel", "Chapter 2: Trouble");
        settings.Add("Chapter 3: Connection", true, "Chapter 3: Connection", "GT");
            settings.Add("POL", true, "Pillar of Light", "Chapter 3: Connection");
            settings.Add("B", true, "Blindness", "Chapter 3: Connection");
            settings.Add("AG", true, "Agony", "Chapter 3: Connection");
        settings.Add("Chapter 4: Contortion", true, "Chapter 4: Contortion", "GT");
            settings.Add("G", true, "Giants", "Chapter 4: Contortion");
            settings.Add("TBT", true, "The Black Tower", "Chapter 4: Contortion");
        settings.Add("Chapter 5: Severance", true, "Chapter 5: Severance", "GT");
            settings.Add("F", true, "Family", "Chapter 5: Severance");
            settings.Add("TT", true, "Tokyo Tower", "Chapter 5: Severance");
        settings.Add("Chapter 6: Binding", true, "Chapter 6: Binding", "GT");
            settings.Add("M", true, "Mari", "Chapter 6: Binding");
            settings.Add("GTTU", true, "Gate to the Underworld", "Chapter 6: Binding");
            settings.Add("Far", true, "Farewells", "Chapter 6: Binding");
        settings.Add("In memory of Robert Altman", true, "End split", "GT");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
        var sB = new List<Tuple<string, string, string>> 
    {
        /* tB("TV","Defeat all enemies","Defeat all enemies & Unleash an attack"),
        tB("TV","Block an enemy attack","Block an enemy attack"), 
        tB("TV","Get to the hospital","Get to the hospital"), 
        tB("COS","Get to Mari's room","Get to Mari's room"), 
        tB("COS","Eliminate the enemies","Eliminate the enemies"),   
        tB("COS","Hit an enemy with a charge attack","Hit an enemy with a charge attack"), */ 
        tB("COS","Grab the enemy's core","Grab the enemy's core"), 
       /* tB("COS","Leave the hospital","Leave the hospital"), 
        tB("K.K","Head to Yugenzaka","Head to Yugenzaka"), 
        tB("K.K","Examine the torii gate", "Examine the torii gate"), */
        tB("K.K","Search the shrine","Search the shrine"), 
       /* tB("K.K","Save the spirits","Save the spirits"), 
        tB("K.K","Hold a katashiro out to the spirits","old a katashiro out to the spirits"), 
        tB("K.K","Find a phone booth","Find a phone booth"), 
        tB("K.K","Remove the seal on the door","Remove the seal on the door"), */
        tB("K.K","Enter the apartment","Enter the apartment"), 
       /* tB("CTF","Search the apartment","Search the apartment"), 
        tB("CTF","Head outside","Head outside"), 
        tB("CTF","Find and destroy the barrier's source","Find and destroy the barrier's source"), 
        tB("CTF","Find the source of the barrier","Find the source of the barrier"), */
        tB("CTF","Use your Spectral Vision to search the area","Use your Spectral Vision to search the area"), 
        /*tB("CTF","Follow the trail","Follow the trail"), 
        tB("CTF","Find a way to purge the corruption","Find a way to purge the corruption"), 
        tB("CTF","Destroy the heard of corruption","Destroy the heard of corruption"), 
        tB("CTF","Search the area","Search the area"), 
        tB("AMOFD","Make your way to Shiroyama Shrine","Make your way to Shiroyama Shrine"), //A Maze of Death */
        tB("AMOFD","Cleanse Shiroyama Shrine","Cleanse Shiroyama Shrine"), 
        tB("AMOFD","Look for something useful at the shrine","Look for something useful at the shrine"), 
       // tB("AMOFD","Head for the Kagerie observation deck","Head for the Kagerie observation deck"),
        tB("AMOFD","Use the tourist binoculars to search the area","Use the tourist binoculars to search the area"), 
       /* tB("AMOFD","Head to the Shibuya underground","Head to the Shibuya underground"), 
        tB("TBL","Investigate the surrounding area with Spectral Vision","Investigate the surrounding area with Spectral Vision"), // The Buried Life 
        tB("TBL","Head deeper underground","Head deeper underground"), */
        tB("TBL","Defeat Yaseotoko","Defeat Yaseotoko"),
        tB("TBL","Get back to the surface","Get back to the surface"),
        tB("TCOS","Get back to KK's safehouse","Get back to KK's safehouse"), // The Caves of Steel
       /* tB("TCOS","Follow KK's trail","Follow KK's trail"),
        tB("TCOS","Make your way to the heart of Hirokawa Shrine","Make your way to the heart of Hirokawa Shrine"),
        tB("TCOS","Defeat the enemies","Defeat the enemies"),
        tB("POL","Head toward the pillar of light","Head toward the pillar of light"), //Pillar of Light */
        tB("POL","Head for the Sengoku Center Building","Head for the Sengoku Center Building"),
      /*  tB("POL","Search the area for clues with Spectral Vision","Search the area for clues with Spectral Vision"),
        tB("POL","Follow the psychic trail","Follow the psychic trail"),
        tB("POL","Find another way inside","Find another way inside"),
        tB("POL","Search for Rinko","Search for Rinko"),
        tB("POL","Find a way to open the shutter","Find a way to open the shutter"),
        tB("POL","Find the control panel to open the shutter","Find the control panel to open the shutter"), */
        tB("POL","Protect Rinko","Protect Rinko"),
        tB("B","Find the torii gate","Find the torii gate"), //Blindness
       /* tB("B","Cleanse the torii gate","Cleanse the torii gate"),
        tB("B","Find and destroy the barrier stones","Find and destroy the barrier stones"),
        tB("B","Find the payphone","Find the payphone"),
        tB("B","Find a telephone card","Find a telephone card"),
        tB("B","Contact Ed","Contact Ed"),
        tB("B","Find the parking lot near Jizo Street","Find the parking lot near Jizo Street"), */
        tB("B","Head for the rental locker","Head for the rental locker"),
       /* tB("B","Search the locker","Search the locker"),
        tB("B","Head to the Kirigaoka apartment block","Head to the Kirigaoka apartment block"),*/
        tB("B","Go outside","Go outside"),
      /*  tB("B","Follow Rinko","Follow Rinko"),
        tB("B","Check out the park","Check out the park"),
        tB("B","Examine the payphone","Examine the payphone"),
        tB("AG","Go to the pillar of light's heart","Go to the pillar of light's heart"), //AG
        tB("AG","Go to the wayside shrine","Go to the wayside shrine"),
        tB("AG","Enter the wayside shrine","Enter the wayside shrine"),
        tB("AG","Go deeper inside","Go deeper inside"), */
        tB("AG","Defeat Ko-omote","Defeat Ko-omote"),
       /* tB("G","Check the payphone","Check the payphone"), //Giants
        tB("G","Cleanse the revealed torii gates","Cleanse the revealed torii gates"), */
        tB("G","Follow KK's lead","Follow KK's lead"),
        tB("G","Head to the basement","Head to the basement"),
       // tB("TBT","Get to the roof of the Mitake Real Estate Building","Get to the roof of the Mitake Real Estate Building"), //The Black Tower
        //tB("TBT","Locate some gasoline and a turbine wheel","Locate some gasoline, a turbine wheel, and fragrant underworld oil"),
        tB("TBT","Find some gasoline and a turbine wheel","Find some gasoline, a turbine wheel, and a turbine wheel"),
        tB("TBT","Go back to the garage","Go back to the garage"),
       /* tB("TBT","Repair the motorcycle","Repair the motorcycle"),
        tB("TBT","Get on the motorcycle","Get on the motorcycle"),
        tB("F","Head for Tokyo Tower","Head for Tokyo Tower"), //Family */
        tB("F","Defeat Okina","Defeat Okina"),
        tB("TT","Head upward","Head upward"), // Tokyo Tower
        tB("TT","DY","Defeat Yaseotoko"),
        //tB("M","Press onward","Press onward"), //Mari
        tB("GTTU","Defeat the amalgamation","Defeat the amalgamation"), //Gate to the underworld
        tB("Far","Keep moving forward","Keep moving forward"), //Farewells

    };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);
    // Checks if the current comparison is set to Real Time
    // Asks user to change to Game Time if LiveSplit is currently set to Real Time.
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Ghostwire: Tokyo",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

update
{
    if (!vars.allObjs.Contains(current.CurTextString))
    {
        vars.allObjs.Add(current.CurTextString);
    }

    if ((vars.DoSplit == false) && (settings["DY"]) && (vars.allObjs.Contains("Head upward") && (current.CurTextString == "Head upward")))
    {
        vars.DoSplit = true;
    }
}

start
{
    return (current.CurTextString == "Chapter 1: Beginnings");
}

onStart
{
    // This is part of a "cycle fix", makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

onReset
{
    /*vars.doneMaps.Clear();
    vars.allObjs.Clear();
    vars.DoSplit = false; */
}

split
{
    if ((settings[current.CurTextString]) && (current.CurTextString != old.CurTextString) && (!vars.doneMaps.Contains(current.CurTextString)) || ((vars.DoSplit == true) && (settings["DY"]) && (current.CurTextString == "Defeat Yaseotoko")))
    {
        vars.doneMaps.Add(current.CurTextString);
        vars.DoSplit = false;
        return true;
    }
}

isLoading
{
    return current.loadingNormal == 2 || current.loadingFT == 112;
}

exit
{
    timer.IsGameTimePaused = true;
}
