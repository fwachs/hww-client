/*****************************************************************************
filename    passport_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class PassportScreen extends Screen
{
	var souvinirPurchase;
	
	public function PassportScreen(purchase)
	{
		super();
		this.souvinirPurchase = purchase;
	}
	
	override public function build()
	{
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
}
