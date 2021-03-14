// Thanks to Earllgray for testing the ASL
state("SMBBBHD")
{
    int isNotLoading : "mono-2.0-bdwgc.dll", 0x0039B56C, 0x794, 0x90, 0x2C; // This was found by Ellie
    int splitter : "UnityPlayer.dll", 0x01099D78, 0x4, 0x8, 0x1C, 0xBC, 0x18, 0x30; // Based on time bonus value after finishing each level, turns to null in main menu
}

init
{
    timer.IsGameTimePaused = false;
    game.Exited += (s, e) => timer.IsGameTimePaused = true;
    vars.trigger = false; //Used for settings 1 and 2
    vars.comparison = null; // Used for settings 1 and 2
    vars.comparison2 = null; // Used for settings 3
    vars.trigger2 = false; // Used for settings 3
}

startup
{


    settings.Add("BBB", true, "Super Monkey Ball Banana Blitz HD");
    	settings.Add("1", true, "Split Every Level Change?", "BBB");
    	settings.Add("2", false, "Split Every State Change", "BBB");
        settings.Add("3",true, "Split on Bonus levels?", "BBB");
        	settings.SetToolTip("1", "This is basically just never split, disable if you use option 2");
        	settings.SetToolTip("2", "Warning: This will split a lot more than you think, Disable the 1st and 3rd option if you use this one");
        	settings.SetToolTip("3", "Bonus levels are removed normally, so this setting will make sure it happens");

}

update
{
    // Basically split everytime the value "splitter" changes but can't be in the main menu, and entering a level from the main menu
    if ((current.splitter != old.splitter) && (current.splitter != 0) && (current.splitter != null) && (settings["1"]) && (current.splitter != vars.comparison))
    {
        vars.trigger = true;
    }
    // Dangerous as it splits for every change even for nulls
    if ((current.splitter != old.splitter) && settings["2"] && (current.splitter != vars.comparison))
    {
        vars.trigger = true;
    }
    // This is used just because after defeating a boss, or exiting a level it'll split 3 times
    if ((current.splitter == 0) && (current.splitter != old.splitter) && (old.splitter != null) && (settings["3"]) && (current.splitter != vars.comparison2))
    {
        vars.comparison2 = 0;
        vars.trigger2 = true;
    }
}

split 
{
    if (vars.trigger == true)
    {
        vars.comparison = current.splitter;
        vars.trigger = false;
        return true;
    }

    if (vars.trigger2 == true)
    {
        vars.trigger2 = false;
        return true;
    }
}

isLoading
{
    return current.isNotLoading != 1;
}