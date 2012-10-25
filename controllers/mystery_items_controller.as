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
    }

    override public function showTutorial()
    {
        this.showMessageBox(MessageBoxScreen.MB_MysteryTutorial);
    }

    override public function screenUnloaded()
    {
    }

    override public function eventFired(event)
    {
        super.eventFired(event);

        if(event.name == "goback") {
            Game.sounds.playSFX("buttonPress");
            Game.popScreen();
        }
        else if(event.name == "doNothing") {
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "showTutorialHelp") {
        	Game.hideBanner();
        	this.screen.getElement("tutorialPrompt").getSprite().visible(1);
        }
        else if(event.name == "hideTutorialHelp") {
        	this.screen.getElement("tutorialPrompt").getSprite().visible(0);
        	Game.hideBanner();
        }
    }
}
