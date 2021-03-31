state("SMBBBHD")
{
	byte decided : "UnityPlayer.dll", 0x010BF87C, 0x28, 0x88, 0x24, 0xA0, 0xC0, 0x90;
    int isNotLoading : "mono-2.0-bdwgc.dll", 0x0039B56C, 0x794, 0x90, 0x2C;
	int state : "mono-2.0-bdwgc.dll", 0x0039B56C, 0x79C, 0x4C, 0x10, 0xE8;
	int stage : "mono-2.0-bdwgc.dll", 0x0039B56C, 0x7AC, 0x20, 0x6C, 0x28;
	int world : "mono-2.0-bdwgc.dll", 0x0039B56C, 0x7AC, 0x20, 0x6C, 0x24;
	float igt : "mono-2.0-bdwgc.dll", 0x0039CC58, 0x48, 0x6DC, 0x44, 0x90, 0x10;
}

init
{
    timer.IsGameTimePaused = false;
    game.Exited += (s, e) => timer.IsGameTimePaused = true;
	vars.betStages = null;
}

startup
{
    settings.Add("BBB", true, "Super Monkey Ball Banana Blitz HD");
    	settings.Add("1", true, "Splits Every Stage", "BBB");
    	settings.Add("2", false, "Splits Every World", "BBB");
        settings.Add("3", false, "Splits Bonus levels", "BBB");
        	settings.SetToolTip("1", "This is will split every stage, disable if you want to split worlds.");
        	settings.SetToolTip("2", "This will split every world, Disable the 1st and 3rd option if you use this one");
        	settings.SetToolTip("3", "Disable options 1 and 2 if you want to split only on bonus stages");
}

start
{
	return ((current.stage == 0) && (current.world == 0) && (current.decided == 1 && old.decided == 0));
}

split 
{
	if (settings["BBB"]) 
	{
			return ((settings["1"] && current.stage != old.stage)    ||
					(settings["2"] && current.world != old.world)    ||
					(settings["3"] && current.stage != old.stage && current.stage == 8) ||
					(current.stage == 9 && current.world == 9 && current.state != old.state && current.state == 10));
    }
}

isLoading
{
    return current.isNotLoading != 1;
}
