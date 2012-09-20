/*****************************************************************************
filename    achievement.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class Achievement
{
	var iosID;
	var androidID;
	var name;
	
	public function Achievement(IosID, AndroidID, Name)
	{
		this.iosID = IosID;
		this.androidID = AndroidID;
		this.name = Name;
	}
}
