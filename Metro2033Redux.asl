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

init
{
    if (modules.First().ModuleMemorySize == 20750336)
    {
        version = "Steam";
    }
    
    if (modules.First().ModuleMemorySize == 19550208)
    {
        version = "Epic";
    }
    
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("metro", true, "All Chapters");

    vars.Chapters = new Dictionary<string,string> 
	    {
            //tower == 13613070
            {"11364390", "Hunter"}, 
            {"12111516","Exhibition"},
            {"23459760","Chase"},
            {"7555304","Riga"},
            {"43309382","Lost Tunnel"},
            {"5055304","Market"},
            {"17551496","Dead City"},
            {"11632932","Dry"},
            {"42393914","Ghosts"},
            {"24570920","Cursed"},
            {"22705244","Armory"},
            {"20191422","Front Line"},
            {"25020278","Trolley Combat"},
            {"28304314","Depot"},
            {"46971900","Defense"},
            {"18233862","Outpost"},
            {"25194692","Black Station"},
            {"12945624","Polis"},
            {"15794468","Alley"},
            {"15579794","Depository"},
            {"8224820","Archives"},
            {"14964468","Church"},
            {"21847646","Dark Star"},
            {"24894220","Cave"},
            {"27371888","D6"},
            {"40533228","Tower (2)"},
        };
    foreach (var Tag in vars.Chapters)
		{
			settings.Add(Tag.Key, true, Tag.Value, "metro");
    	}; 
}

start
{
    return ((old.Loader == 1) && (current.Loader == 0) && (current.Splitter == 13613070));
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
