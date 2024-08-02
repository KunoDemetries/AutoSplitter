state("AmazingFrog") 
{
    int Loading : "mono.dll", 0x0027CAE8, 0x0, 0x20, 0x118;
    byte Loading2 : 0xC825B4;

}

startup
{

}

init
{
    vars.doLoad = false;
}

update
{
    if (current.Loading2 != 0 && current.Loading == 3)
    {
        vars.doLoad = true;
        print("true");
    }

    if (vars.doLoad == true && current.Loading2 == 0 && current.Loading == 0)
    {
        vars.doLoad = false;
        print("false");
    }
   // print (current.Loading.ToString());
}

isLoading
{
	return vars.doLoad;
}
