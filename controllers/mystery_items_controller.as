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
    }
}
