/*****************************************************************************
filename    husband_selection_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen_controller
import screens.main_screen
import controllers.main_controller

class HusbandSelectionController extends ScreenController implements INameEnterController
{
    var nameScreen;

    public function HusbandSelectionController(controlledScreen)
    {
        super(controlledScreen);
    }

    override public function screenLoaded()
    {
        trace("HusbandSelectionController screenLoaded!");
    }

    public function nameChanged(name)
    {
        Game.sharedGame().hubby.name = name;
    }

    override public function eventFired(event)
    {
        super.eventFired(event);

        if(event.name == "showExecutive") {
            Game.sounds.playSFX("buttonPress");
            Game.sharedGame().hubby.occupation = this.screen.updateSelection(0);
            this.screen.showTutorialStep(2);
        }
        if(event.name == "showDoctor") {
            Game.sounds.playSFX("buttonPress");
            Game.sharedGame().hubby.occupation = this.screen.updateSelection(1);
            this.screen.showTutorialStep(2);
        }
        if(event.name == "showBanker") {
            Game.sounds.playSFX("buttonPress");
            Game.sharedGame().hubby.occupation = this.screen.updateSelection(2);
            this.screen.showTutorialStep(2);
        }
        if(event.name == "showAthlete") {
            Game.sounds.playSFX("buttonPress");
            Game.sharedGame().hubby.occupation = this.screen.updateSelection(3);
            this.screen.showTutorialStep(2);
        }
        else if(event.name == "showLawyer") {
            Game.sounds.playSFX("buttonPress");
            Game.sharedGame().hubby.occupation = this.screen.updateSelection(4);
            this.screen.showTutorialStep(2);
        }
        else if(event.name == "done") {
            Game.sounds.playSFX("buttonPress");

            nameScreen = new NameEnterScreen();
            nameScreen.configFile = "screen-cfgs/name-enter-screen-cfg.xml";
            nameScreen.isWife = 0;
            this.presentModalScreen(nameScreen);
        }
        else if(event.name == "confirm") {
            Game.sounds.playSFX("buttonPress");

            // get the text and check if they gave a name
            nameScreen.text = nameScreen.textInput.text();

            if(nameScreen.text != "") {
                Game.sharedGame().saveHusband();

                this.dismissModalScreen();

                this.screen.showNextTutorial();
            }
        }
        else if(event.name == "completed") {
            Game.sounds.playSFX("buttonPress");
            Game.sounds.stop();
            Game.sounds.playMusic("themeMusic");

            var mainScreen = new MainScreen();
            mainScreen.configFile = "screen-cfgs/main-screen-cfg.xml";
            var controller = new MainController(mainScreen);
            Game.pushScreen(mainScreen);

            Game.pushScreen(Game.sharedGame().hubby.husbandScreen);

            screen = new HouseSelectionScreen();
            screen.configFile = "screen-cfgs/house-selection-screen-cfg.xml";
            controller = new HouseSelectionController(screen);
            Game.pushScreen(screen);
        }
        else if(event.name == "cancel") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "doNothing") {
        }
    }
}
