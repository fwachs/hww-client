/*****************************************************************************
filename    mystery_items_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.event

class MysteryItemsController extends ScreenController
{
	
	public function MysteryItemsController(controlledScreen)
	{
		super(controlledScreen);
	}

	override public function screenLoaded()
	{
		Game.hideBanner();		
	}
	
	override public function screenUnloaded()
	{
	}
	
	override public function eventFired(event)
	{		
		super.eventFired(event);
		
		if(event.name == "goback") {
			Game.showBanner(1, 1);
			Game.popScreen();
		}
	}	
}
