state("FixitFelixJr")
{
	int start1 : 0x1B294;
	int reset1 : 0x24264;
	int levels : 0x21808;
}

start
{
	if (current.start1 == 4)
	{
		return true;		
	}
}

startup
{
	settings.Add("Level", true, "Stages");
	settings.Add("Level1", true, "Stage 1", "Level");
	settings.Add("Level2", true, "Stage 2", "Level");
	settings.Add("Level3", true, "Stage 3", "Level");
	settings.Add("Level4", true, "Stage 4", "Level");
	settings.Add("Level5", true, "Stage 5", "Level");
}

split
{
	if(settings["Level"])
	{
			return ((settings["Level1"] && old.levels == 0 && current.reset1 != old.reset1 && current.reset1 == 6)		||
					(settings["Level2"] && current.levels == 1 && current.reset1 != old.reset1 && current.reset1 == 6)	||
					(settings["Level3"] && current.levels == 2 && current.reset1 != old.reset1 && current.reset1 == 6)	||
					(settings["Level4"] && current.levels == 3 && current.reset1 != old.reset1 && current.reset1 == 6)	||
					(settings["Level5"] && current.levels == 4 && current.reset1 == 6));

	}
}

 reset
{
    return((current.reset1 == 0));
}
