//Made with US version of the game and PCSX2 Nightly
state("LiveSplit")
{
}

init
{
    vars.doneMaps = new List<string>(); 
	vars.timeTotal = 0;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).CreateInstance("PS2");

    vars.Helper.Load = (Func<dynamic, bool>)(emu => 
    {
        emu.Make<int>("IGT", 0x324130);
        emu.Make<int>("CurMapID", 0x324128);

        return true;
    });

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

    //creates text components for variable information
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
	        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
	        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
	        if (textSetting == null)
	        {
	        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
	        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
	        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
	
	        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
	        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
	        }
	
	        if (textSetting != null)
	        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    //Parent setting
	settings.Add("Variable Information", true, "Variable Information");
	//Child settings that will sit beneath Parent setting
	settings.Add("MK", false, "Current Number of Monsters Killed This Level", "Variable Information");
}

update
{
    int timeDiff = (current.IGT - old.IGT);

    if ( timeDiff > 0 )
	{
		vars.timeTotal += timeDiff;
	}

    //Prints the current map to the Livesplit layout if the setting is enabled
        if(settings["MK"]) 
    {
        vars.SetTextComponent("Monsters Killed This Level: ",current.MonstersKilled.ToString());
        if (old.MonstersKilled != current.MonstersKilled) print("Monsters Killed This Level: " + current.MonstersKilled.ToString());
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
