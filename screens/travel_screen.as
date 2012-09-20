/*****************************************************************************
filename    travel_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class TravelScreen extends Screen
{
	public function TravelScreen()
	{
		super();
	}
	
	override public function gotFocus()
	{
		Game.showBanner(1,0);
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
	
	override public function build()
	{
	}
}
