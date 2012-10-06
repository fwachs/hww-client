/*****************************************************************************
filename    hud_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class HUDScreen extends Screen
{
	var ssp;
	var miles;
	var gamebucks;
	var diamonds;
	var screenUpdateTimer;
	
	public function HUDScreen()
	{
		super();		
	}
	
	override public function build()
	{
        c_addtimer(1000, this.update, null, 0, -1);
	}
	
	public function update()
	{
		trace("CURRENT SSPs: ", Game.currentGame.wife.socialStatusPoints);
		ssp.setText(str(Game.currentGame.wife.socialStatusPoints));
		miles.setText(str(Game.currentGame.wallet.getBalance("Miles")));
		gamebucks.setText(str(Game.currentGame.wallet.getBalance("GameBucks")));
		diamonds.setText(str(Game.currentGame.wallet.getBalance("Diamonds")));
	}
	
	public function showSSPsBuffIcon(icon)
	{
		var sprt = this.getElement("ssp-buff-icon").getSprite();
		sprt.visible(1)
		sprt.texture(icon);
	}
	
	public function hideSSPsBuffIcon()
	{
		var sprt = this.getElement("ssp-buff-icon").getSprite();
		sprt.visible(0);
	}
}
