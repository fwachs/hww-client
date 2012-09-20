/*****************************************************************************
filename    map_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event

class MapController extends ScreenController
{
	public function MapController(controlledScreen)
	{
		super(controlledScreen);
	}

	override public function screenLoaded()
	{
		trace("MapController screenLoaded!");

		var ev = new GoBackEvent();		
		ev.node = this.screen.background;
		ev.eventType = EVENT_TOUCH;
		ev.controller = this;
		
		Event.addEvent(ev);
	}	
}
