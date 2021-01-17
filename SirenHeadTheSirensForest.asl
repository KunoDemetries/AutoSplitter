state("Sirean Head")
{
    byte loading1 :"UnityPlayer.dll", 0x135FE9B;
}

startup
{
	settings.Add("missions", true, "All Levels");
	settings.SetToolTip("missions", "IDK why I added this customization lol");

	vars.missions = new Dictionary<string,string> 
    { 
        {"2","Level 2"},
        {"3","Level 3"},
        {"4","Level 4"},
    };
    
    	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}

init
{
    vars.counter = 1;
    vars.oldcounter = 1;
    vars.value = 0;
}

update
{
    if (current.loading1 == 5)
    {
        vars.value = current.loading1;
    }

    if ((current.loading1 != old.loading1) && (current.loading1 != 5) && (vars.value != current.loading1))
    {
        vars.value = current.loading1; 
        vars.counter++;
    }
}

start
{
    if ((current.loading1 == 5) && (old.loading1 != 5))
    {
        vars.counter = 1;
        vars.oldcounter = 1;
        return true;
    }
}

split 
{
    if ((vars.counter != vars.oldcounter) && (settings[(vars.counter.ToString())]))
    {
        vars.oldcounter++;
        return true;
    }

}

isLoading
{
    return (current.loading1 != 5);
}