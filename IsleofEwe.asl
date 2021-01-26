// Original script by Kuno Demetries, rythin.
// Enhancements by Ero.

state("Isle of Ewe") {
	int cpLoading : "UnityPlayer.dll", 0x14E2E68, 0x520, 0x268;
}

startup {
	var sB = new Dictionary<string, string> {
		//{"6", "Learned Double Jump"},
		//{"2", "Lion King Refrenece"},
		//{"7", "Golem Boss Fight"},
		//{"15", "Return baaarbra/ Learn Sprint"},
		{"11", "Section 2 Entrance"},
		//{"0002332", "Bouncy House Mushroom Edition"},
		//{"4", "Indiana Jones Refrenece"},
		{"1", "Scene 3 Entrance"},
		//{"3", "Double Stream Lava"},
		//{"0001112", "Lava Staircase"}
	};

	settings.Add("sheep_count", true, "Sheep Count");

	foreach (var s in sB)
		settings.Add(s.Key, true, s.Value);

	timer.CurrentTimingMethod = TimingMethod.GameTime;

	vars.SetTextComponent = (Action<string, string>)((id, text) => {
		var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null) {
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

			textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
			textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}

		if (textSetting != null) textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});
}

init {
	string logPath = Environment.GetEnvironmentVariable("appdata")+"\\..\\LocalLow\\No Ewe Productions\\Isle Of Ewe\\output_log.txt";
	try {
		FileStream fs = new FileStream(logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
		fs.SetLength(0);
		fs.Close();
	} catch {
		print(">>>>> Cannot open log!");
	}

	vars.line = "";
	vars.reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	vars.currCP = "";
	vars.oldCP = "";
	vars.sheepCount = "";
}

update {
	if (vars.reader == null) return false;
	vars.line = vars.reader.ReadLine();

	if (vars.line != null)
		if (vars.line.StartsWith("Checkpoint")) {
			vars.oldCP = vars.currCP;
			vars.currCP = vars.line.Split(' ')[1];
		} else if (vars.line.StartsWith("Sheep rescued")) vars.sheepCount = vars.line.Split(' ')[2];

	if (settings["sheep_count"]) vars.SetTextComponent("Sheep Counter", vars.sheepCount);
}

start {
	return vars.line != null && vars.line.StartsWith("Save not found");
}

split {
	if (vars.oldCP != vars.currCP && settings[vars.currCP]) {
		vars.oldCP = vars.currCP;
		return true;
	}
}

reset {
	return vars.line != null && vars.line.StartsWith("Loading Menu...");
}

isLoading {
	return current.cpLoading != 0;
}

exit {
	vars.reader = null;
}
