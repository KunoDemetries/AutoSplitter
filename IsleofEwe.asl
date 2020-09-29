state("Isle of Ewe") {
	int checkpointloading : "UnityPlayer.dll", 0x014E2E68, 0x520, 0x268;
	}

init {
	string logPath = Environment.GetEnvironmentVariable("appdata")+"\\..\\LocalLow\\No Ewe Productions\\Isle Of Ewe\\output_log.txt";
	try {
	FileStream fs = new FileStream(logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
	fs.SetLength(0);
	fs.Close();
	} catch {
	print("Cant open log");
	}
	vars.line = "";
	vars.reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	vars.CurrentCheckpoint = ""; 
	vars.CurrentScene = ""; 
	vars.oldcheckpoint = "";
	vars.doneMaps = "";
	vars.sheepcounter = "";
	}

update {
		if (vars.reader == null) return false;
		vars.line = vars.reader.ReadLine();
	
		if (vars.line !=null) {
		if (vars.line.StartsWith("Checkpoint")) {
		vars.CurrentCheckpoint = (vars.line.Split(' ')[1]);
		}
		}

		if (vars.line !=null) {
		if (vars.line.StartsWith("Scene")) {
		vars.CurrentScene = (vars.line.Split(' ')[1]);
		}
		}

		if (vars.line !=null) {
		if (vars.line.StartsWith("Sheep rescued")) {
		vars.sheepcounter = (vars.line.Split(' ')[2]);
		}
		}

		if (settings["sheep_count"]) {vars.SetTextComponent("Sheep Counter", (vars.sheepcounter).ToString()); }
		}	

startup {
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
	settings.Add("sheep_count", true, "Sheep Count");
  //  settings.Add("21212r", true, "Some of the Splits can't be disabled/ are not in the correct location, most notibly mushroom, section 2/3.");
	


	vars.missions = new Dictionary<string,string> { 
	//{"6","Learned Double Jump"},
	//{"2","Lion King Refrenece"},
//	{"7","Golem Boss Fight"},
	//{"15","Return baaarbra/ Learn Sprint"},
	{"11","Section 2 Entrance"},
	//{"0002332","Bouncy House Mushroom Edition"},
	//{"4","indiana Jones Refrenece"},
	{"1","Scene 3 Entrance"},
	//{"3","Double Stream Lava"},
	//{"0001112","Lava Staircase"},
	};

	vars.missionList = new List<string>();
	foreach (var Tag in vars.missions) {
    settings.Add(Tag.Key, true, Tag.Value);
    vars.missionList.Add(Tag.Key); };
	vars.splits = new List<string>();
	}


isLoading {
    return (current.checkpointloading != 0); 
	}

start {
	if (vars.line !=null) {
	if (vars.line.StartsWith("Save not found")) {
	return true; 
	}
	}
	}

reset {
	if(vars.line !=null) {
	if (vars.line.StartsWith("Loading Menu...")) {
	return true; 
	}
	}
	}

split
{
	if (vars.oldcheckpoint != vars.CurrentCheckpoint) 
	{
		if (settings[vars.CurrentCheckpoint]) 
		{
			vars.oldcheckpoint = vars.CurrentCheckpoint;
			return true;	
		}	
	}
}

exit {
	vars.reader = null;
	}
//Thanks to The amazing Goose-thing Rythin, and DerKO
