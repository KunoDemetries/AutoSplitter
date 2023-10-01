state("AmazingFrog") {}
//General ASL setup from Ero, taken from his ANNO: Mutationem ASL
startup
{
	vars.Log = (Action<object>)(output => print("[AmazingFrog] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var rm = helper.GetClass("Assembly-CSharp", "Fade");

		vars.Unity.Make<bool>(rm.Static, rm["waitTime"]).Name = "loading";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();
}

isLoading
{
	return !vars.Unity["loading"].Current;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}
