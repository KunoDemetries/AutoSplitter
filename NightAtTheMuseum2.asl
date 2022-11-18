state("Night")
{
    string40 LevelID : 0x1B1DE1; 
    int Loader : 0x188CFC;
}

init
{
	vars.doneMaps = new List<string>(); 
}

startup
{
    settings.Add("Levels", true, "All Levels");

     vars.missions2 = new Dictionary<string,string> 
		{ 	
           // {"NYC_Museum","NYC Museum"},
            {"Castle","Smithsonia Castle"},            
            {"Archives_01","Federal Archives 1"},
            {"Air_and_Space", "Air and Space Museum"}, 
            {"Air_and_Space_B","A&SM Downstairs"},
            {"vending_machine","A&SM Vending Machine"},
            {"Air_and_Space_Boss","A&SM Able Chase"},
            {"Archives_02","Federal Archives 2"},
            {"art_museum","Art Museum"},
            {"Natural_History","National History Museum"},
            {"Air_and_Space2_Lunar","A&SM: Lunar Lander"},
            {"Air_and_Space_Vega","A&SM: Hanger"},
            {"National_Mall","Lincoln Memorial"},
            {"National_Mall4","Kahmunrah Battle"},
        };
 		foreach (var Tag in vars.missions2)
		{
			settings.Add(Tag.Key, true, Tag.Value, "Levels");
    	};
}

start
{
    return ((current.LevelID.Split('.')[0]) == "NYC_Museum");
}

onStart
{
    vars.doneMaps.Add(current.LevelID);
}

onReset
{
    vars.doneMaps.Clear();
}

split
{
    if ((settings[current.LevelID.Split('.')[0]]) && (!vars.doneMaps.Contains(current.LevelID)))
    {
        vars.doneMaps.Add(current.LevelID);
        return true;
    }
}

isLoading
{
    return (current.Loader == 0);
}