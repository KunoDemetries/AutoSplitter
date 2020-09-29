state("Spiderwick")
{
    int cutscenes : 0xAE4DB0;
    int cinematics : 0x32C4A8;
    int loading1 : 0xA356B8;
     string20 levels : 0xA57F88;
     string25 playarea : 0xA57F68;
     string20 chapter : 0x2E47A5;
}


init
{
    vars.Wrsplitter = 0;
    vars.doneMaps = new List<string>(); 
}

startup {
  settings.Add("chapters", false, "Chapter Splits");
  settings.Add("wr", true, "World Record Splits");


    vars.Chapters = new Dictionary<string,string> {
        {"Chapter1","Chapter 1"},
        {"Chapter2","Chapter 2"},
        {"Chapter3","Chapter 3"},
        {"Chapter4","Chapter 4"},
        {"Chapter5","Chapter 5"},
        {"Chapter6","Chapter 6"},
        {"Chapter7","Chapter 7"},
        {"Chapter8","Chapter 8"},
    };
    vars.ChaptersA = new List<string>();
    foreach (var Tag in vars.Chapters) {
    settings.Add(Tag.Key, true, Tag.Value, "chapters");
    vars.ChaptersA.Add(Tag.Key);
    };

    vars.WRsplits = new Dictionary<string,string> { 
        {"7","Field Guide"},
        {"15","Stone"},
        {"22","Monacle"},
        {"34","Quarry"},
        {"55","Troll"},
        {"56", "RedCap"},
        {"62","Splattergun"},
        {"76","Cellar Key"},
        {"78","Lucinda"},
        {"86","Acorn"},
        {"94","Quarry 2"},
        {"107","Griffin"},
        {"117","Return to the Mansion"},
        {"121","House Arrest"},
        {"123","Ogre Fight"},
    };
    vars.WRsplitsA = new List<string>();
    foreach (var Tag in vars.WRsplits) {
    settings.Add(Tag.Key, true, Tag.Value, "wr");
    vars.WRsplitsA.Add(Tag.Key);
    };
}


update
{
    if ((current.cinematics != old.cinematics) && (current.cinematics == 0)) {
        vars.Wrsplitter++;
    }

     if ((current.cutscenes == 0) && (current.cutscenes != old.cutscenes)) {
        vars.Wrsplitter++;
    }

print(vars.Wrsplitter.ToString());
}


start
    {
    if ((current.playarea != "shell") && (old.playarea == "shell")) {
        vars.Wrsplitter = 0;
        vars.doneMaps.Clear();
        return true;
    }
}

split
    {
    string currentMap = (vars.Wrsplitter.ToString());

        if (!vars.doneMaps.Contains(currentMap)) {
            if (settings[currentMap.Trim()]) {
                 if (vars.ChaptersA.Contains(current.chapter) ||
                 (vars.WRsplitsA.Contains(currentMap))) {
                vars.doneMaps.Add(currentMap);
        return true;
        }
        else {
        return false;
        }
        }
        }
    return ((vars.Wrsplitter > 128) && (current.chapter == "Chapter7") && (current.cinematics == 1) && (current.cutscenes == 0) && (current.levels == "ealth"));
        }

reset
{
    return (current.playarea =="shell");
}

isLoading
{
    return (current.loading1 == 1);
}
