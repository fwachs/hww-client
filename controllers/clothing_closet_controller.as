/*****************************************************************************
filename    hud_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.premium_currency_screen
import controllers.premium_currency_controller

class ClothingClosetController extends ScreenController
{
    public function ClothingClosetController(controlledScreen)
    {
        super(controlledScreen);
    }
    
    override public function screenLoaded()
    {
        this.screen.display();
    }
    
    override public function eventFired(event)
    {
        var screen;
        var controller;
        
        super.eventFired(event);
        
        if(event.name == "gotoMainMenu") {
            if(Game.currentScreen().getScreenName() != "main-screen") {
                Game.sounds.playSFX("buttonPress");
                Game.popToRoot();
            }
        }
        else if(event.name == "gotoHusband") {
            if(Game.currentScreen().getScreenName() != "husband-screen") {
                Game.sounds.playSFX("buttonPress");
                            
                Game.pushScreen(Game.sharedGame().hubby.husbandScreen);
            }
        }
    }
}
