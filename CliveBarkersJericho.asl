state("jericho")
{
    string50 CurrentLevel : 0x3C4E78;
    int loading1 : 0x3C1AFC;
}

init
{
    vars.ReplacedString = "";
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("Je",true,"Jericho");
    settings.Add("l1",true,"Al-Khali", "Je");
    settings.Add("l2",true,"World War 2", "Je");
    settings.Add("l3",true,"The Crusades", "Je");
    settings.Add("l4",true,"Roman Provinces", "Je");
    settings.Add("l5",true,"Sumeria", "Je");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>

    {
        tB("l1", "alk_desert.dds", "The Storm"),
    	tB("l1", "alk_tomb.dds", "The Tomb"),
        tB("l1", "alk_bunker_00.dds", "Operation Vigil"),
	    tB("l1", "alk_city.dds", "Al Khali"),
	    tB("l1", "alk_bunker_01.dds", "Green"),
	    tB("l1", "alk_final.dds", "Man Down!"),
        tB("l2", "wwii_biggates.dds", "Still with you"),
    	tB("l2", "wwii_pillboxes.dds", "The Path of Souls"),
    	tB("l2", "wwii_mosque.dds", "Blackwatch"),
    	tB("l2", "wwii_mosque_inside.dds", "Ambush"),
    	tB("l2", "wwii_vigil.dds", "The Flames of Anger"),
    	tB("l2", "wwii_vigil_inside.dds", "Exorcism"),
    	tB("l2", "wwii_bradenburg.dds", "Bradenburg Gate"),
        tB("l3", "cru_river.dds", "Rivers of Blood"),
        tB("l3", "cru_labyrinh.dds", "Motley Crew"),
    	tB("l3", "cru_sewers.dds", "Sewers"),
    	tB("l3", "cru_keep.dds", "Out of the Frying Pan..."),
        tB("l3", "cru_catacomb.dds", "Tortured Souls"),
        tB("l3", "cru_chapel.dds", "Black Rose"),
        tB("l4", "rom_outskirts.dds", "Imperium"),
        tB("l4", "rom_caldrium.dds", "The Low road"),
    	tB("l4", "rom_tepidarium.dds", "Decadence"),
        tB("l4", "rom_palace_01.dds", "Temple of Pain"),
	    tB("l4", "rom_palace_02.dds", "Gardens of Hell"),
    	tB("l4", "rom_coloseum.dds", "Morituri te Salutant"),
    	tB("l4", "rom_chamber.dds", "Guts"),
        tB("l5", "sum_ziggurat_01.dds", "The GodSeal"),
        tB("l5", "sum_ziggurat_02.dds", "spiritual Guide"),
    	tB("l5", "sum_ziggurat_03.dds", "Skin"),
    	tB("l5", "sum_ziggurat_04.dds", "Flesh"),
        tB("l5", "sum_ziggurat_meat.dds", "Blood"),
    	tB("l5", "sum_ziggurat_05.dds", "Sacrifice"),
    	tB("l5", "sum_end.dds", "Pyxis Prima"),
    };
    foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);    
}

update
{
   vars.ReplacedString = current.CurrentLevel.Replace(@"2D/Loading/Levels/", "").ToLowerInvariant();
   //vars.ReplacedString.ToLowerInvariant();
   print(vars.ReplacedString.ToString());
   //print(current.loading1.ToString());
}

start
{
    return ((settings[vars.ReplacedString]) && (current.loading1 == 0));
}

onStart
{
    vars.doneMaps.Add(vars.ReplacedString);
}

split
{
    return ((!vars.doneMaps.Contains(vars.ReplacedString)) && (current.CurrentLevel != old.CurrentLevel)) && (settings[vars.ReplacedString]);
}

onSplit
{
    vars.doneMaps.Add(vars.ReplacedString);
}

isLoading
{
    return (current.loading1 == 0);
}

reset
{
    return (vars.ReplacedString == "Default.dds");
}

onReset
{
    vars.doneMaps.Clear();
}
