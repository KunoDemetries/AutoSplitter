state("nevermind")
{
    int loading1 : 0x1342198;
}

isLoading
{
    return (current.loading1 != 3);
}