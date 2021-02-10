state("FixitFelixJr")
{
	int start1 :  0x1B294;
	int reset1 : 0x24264;
}

start
{
	if (current.start1 == 4)
	{
		return true;		
	}
}


split
{
	return((current.reset1 == 6));
}

 reset
{
    	return((current.reset1 == 0));
}
