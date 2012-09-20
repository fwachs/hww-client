/*****************************************************************************
filename    wife_selection_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.wife_customization_screen
import controllers.wife_customization_controller

class WifeSelectionController extends ScreenController
{	
	public function WifeSelectionController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("WifeSelectionController screenLoaded!");
	}
	
	override public function eventFired(event)
	{		
		super.eventFired(event);
		
		if(event.name == "showModern") {
			Game.sounds.playSFX("buttonPress");
			this.screen.updateSelection(0);
			this.screen.showTutorialStep(3);
		}
		if(event.name == "showRetro") {
			Game.sounds.playSFX("buttonPress");
			this.screen.updateSelection(1);
			this.screen.showTutorialStep(3);
		}
		if(event.name == "showCeleb") {
			Game.sounds.playSFX("buttonPress");
			this.screen.updateSelection(2);
			this.screen.showTutorialStep(3);
		}
		if(event.name == "showBusiness") {
			Game.sounds.playSFX("buttonPress");
			this.screen.updateSelection(3);
			this.screen.showTutorialStep(3);
		}
		else if(event.name == "showRocker") {
			Game.sounds.playSFX("buttonPress");
			this.screen.updateSelection(4);
			this.screen.showTutorialStep(3);
		}
		else if(event.name == "customizeWife") {
			Game.sounds.playSFX("buttonPress");
			
			var screen = new WifeCustomizationScreen();
			screen.configFile = "screen-cfgs/wife-customization-screen-cfg.xml";
			var controller = new WifeCustomizationController(screen);
			
			Game.pushScreen(screen);
		}
	}
}
