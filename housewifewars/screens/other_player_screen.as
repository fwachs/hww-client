/*****************************************************************************
filename    wife_customization_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen

class OtherPlayerScreen extends Screen
{
	public function OtherPlayerScreen()
	{
		super();
	}

	override public function build()
	{
	}

	override public function gotFocus()
	{
		Game.showBanner(1,0);
	}

	override public function lostFocus()
	{
		this.stopWifeAnimation();
	}

	public function stopWifeAnimation()
	{
		this.getElement("rightArm").getSprite().stop();
		this.getElement("leftArm").getSprite().stop();
		this.getElement("rightArmSleeve").getSprite().stop();
		this.getElement("leftArmSleeve").getSprite().stop();
		this.getElement("face").getSprite().stop();
	}
}
