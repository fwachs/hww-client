/*****************************************************************************
filename    wife_customization_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.wife_customization_screen
import screens.husband_selection_screen
import controllers.husband_selection_controller
import screens.name_enter_screen

class WifeCustomizationController extends ScreenController implements INameEnterController
{
	var nameScreen;
	var colorsShown = 0;
	var skinShown = 0;
	
	public function WifeCustomizationController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("WifeCustomizationController screenLoaded!");
		this.screen.getSkinTone();
		this.screen.updateHairStyleSelection();
	}
	
	public function nameChanged(name)
	{
		Game.sharedGame().wife.name = name;
	}
	
	override public function eventFired(event)
	{
		super.eventFired(event);
				
		// hair styles
		if(event.name == "selectHairStyle01"){
			Game.sounds.playSFX("buttonPress");
			Game.sharedGame().wife.hairStyle = 0;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(1);
		}
		else if(event.name == "selectHairStyle02"){
			Game.sounds.playSFX("buttonPress");
			Game.sharedGame().wife.hairStyle = 1;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(2);
		}
		else if(event.name == "selectHairStyle03"){
			Game.sounds.playSFX("buttonPress");
			Game.sharedGame().wife.hairStyle = 2;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(3);
		}
		else if(event.name == "selectHairStyle04"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairStyle = 3;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(4);
	}
		else if(event.name == "selectHairStyle05"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairStyle = 4;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(5);
		}
		else if(event.name == "selectHairStyle06"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairStyle = 5;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairStyleCheckmark(6);
		}
		// hair colors
		else if(event.name == "selectHairColor01"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 0;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(1);
		}
		else if(event.name == "selectHairColor02"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 1;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(2);
		}
		else if(event.name == "selectHairColor03"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 2;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(3);
		}
		else if(event.name == "selectHairColor04"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 3;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(4);
		}
		else if(event.name == "selectHairColor05"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 4;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(5);
		}
		else if(event.name == "selectHairColor06"){
			Game.sounds.playSFX("buttonPress");
			Game.currentGame.wife.hairColor = 5;
			Game.sharedGame().wife.cutAndDyeHair(this.screen);
			this.screen.setHairColorCheckmark(6);
		}
		else if(event.name == "getSliderPosition") {
			this.screen.setSliderStartingPosition(event.x);
		}
		else if(event.name == "skinToneSlider"){
			this.screen.slideSkinToneSlider(event.x);
		}
		else if(event.name == "showHairStyle") {
			Game.sounds.playSFX("buttonPress");
			this.screen.displayCustomizationFrame(0);
		}
		else if(event.name == "showHairColor") {
			Game.sounds.playSFX("buttonPress");
			this.screen.displayCustomizationFrame(1);
			this.colorsShown = 1;
			if(this.skinShown == 1) {
				this.screen.showTutorialStep(3);
			}
		}
		else if(event.name == "showSkinTone") {
			Game.sounds.playSFX("buttonPress");
			this.screen.displayCustomizationFrame(2);
			this.skinShown = 1;
			this.screen.showTutorialStep(2);
		}
		else if(event.name == "chooseHusband") {
			Game.sounds.playSFX("buttonPress");
			
			nameScreen = new NameEnterScreen();
			nameScreen.configFile = "screen-cfgs/name-enter-screen-cfg.xml";
			nameScreen.isWife = 1;
			this.presentModalScreen(nameScreen);
		}
		else if(event.name == "confirm") {
			Game.sounds.playSFX("buttonPress");
			
			// get the text and check if they gave a name
			nameScreen.text = nameScreen.textInput.text();
			
			if(nameScreen.text != "") {
				this.dismissModalScreen();
				
				var husbandScreen = new HusbandSelectionScreen();
				husbandScreen.configFile = "screen-cfgs/husband-selection-screen-cfg.xml";
				var controller = new HusbandSelectionController(husbandScreen);
				Game.sharedGame().saveWife();
				ppy_setscore(0);
				Game.pushScreen(husbandScreen);
			}
		}
		else if(event.name == "cancel") {
			Game.sounds.playSFX("buttonPress");
			this.dismissModalScreen();
		}
	}
	
	public function checkNextTutorialStep()
	{
	}
}
