state("MID-Win64-Shipping", "Martha is Dead Demo")
{
    int Loader : 0x04A693D8, 0x4E0;
}

state("MID-Win64-Shipping", "Martha is Dead V4.27")
{
    int Loader : 0x05CD4600, 0x4F8;
}

update
{
    print(modules.First().ModuleMemorySize.ToString());
}

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case 84725760 : version = "Martha is Dead Demo"; 
            break;
        case 104284160 : version = "Martha is Dead V4.27"; 
            break;
        default:        version = ""; 
            break;
    }

}

isLoading
{
    return (current.Loader == 0);
}