/*****************************************************************************
filename    wife_customization_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen

class PremiumCurrencyScreen extends Screen
{
	var background;
	var defaultView;

	public function PremiumCurrencyScreen(defaultView)
	{
		super();
		this.defaultView = defaultView
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}

	override public function build()
	{
	}

	public function showFirstTimeBuyerPopup()
	{
		this.getElement("firstTimeBuyerPopup").getSprite().visible(1);
	}

	public function hideFirstTimeBuyerPopup()
	{
		this.getElement("firstTimeBuyerPopup").getSprite().visible(0);
	}
}
