state("game")
{
    byte loading1 : "Core.dll", 0xCCF60;
    byte splitter : "Core.dll", 0x1CC11B;
}


isLoading
{
    return (current.loading1 == old.loading1);
}