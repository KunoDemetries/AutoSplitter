state("pcsx2")
{
    int CurItemSelected : 0x012457B4, 0x6E4;
    int Loader : 0x0123E454, 0xFD4; 
    int CurMapID : 0x0123E450, 0x128;
    int IGT : 0x0123E450, 0x130;
}

init
{
    vars.doneMaps = new List<string>(); 
	vars.timeTotal = 0;

    switch(modules.First().ModuleMemorySize)
    {
	case 47538176 :
        version = "PCSX2 Emulator 1.6.0";
        break;
    default:        version = "Wrong version of PCSX2"; 
        break;
    }
}

startup
{
    settings.Add("BTVS", true, "Buffy The Vampire Slayer - Chaos Bleeds");

    vars.missions2 = new Dictionary<string,string> 
	{ 	
        {"100003A", "Magic Box"},
        {"1000024",  "Cemetery"},
        {"100000D",  "Blood Factory"},
        {"1000047",  "Magic Box Revisited"},
        {"100002B",  "Downtown Sunnydale"},
        {"1000008",  "High School"},
        {"1000049",  "Old Quarry"},
        {"1000011",  "The Initiative"},
        {"1000033",  "Sunnydale Mall"},
        {"100002C",  "Sunnydale Zoo"},
        {"10000D0",  "The First's Lair"},
        {"10000F8",  "Epilogue"},
    };
 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "BTVS");
    };
}

update
{
    int timeDiff = (current.IGT - old.IGT);

    if ( timeDiff > 0 )
	{
		vars.timeTotal += timeDiff;
	}
}

gameTime
{
	// Convert centiseconds to milliseconds and return.
	return TimeSpan.FromSeconds(vars.timeTotal);
}

start
{
    return ((settings[current.CurMapID.ToString("X")]) && (current.IGT <= 1));
}

onStart
{
    vars.doneMaps.Add(current.CurMapID.ToString("X"));
}

split
{
    if ((settings[current.CurMapID.ToString("X")]) && (!vars.doneMaps.Contains(current.CurMapID.ToString("X"))))
    {
        vars.doneMaps.Add(current.CurMapID.ToString("X"));
        return true;
    }
}

onReset
{
    vars.timeTotal = 0;
    vars.doneMaps.Clear();
}

isLoading
{
    return true;
}
