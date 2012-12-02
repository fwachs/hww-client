/*****************************************************************************
filename    hud_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/
import framework.event
import screens.clothing_shop_screen
import controllers.clothing_shop_controller

class ClothingCatalogController extends ScreenController
{
    public function ClothingCatalogController(controlledScreen)
    {
        super(controlledScreen);
    }
    
    override public function screenLoaded()
    {
        this.screen.fillScroll();
    }
    
    override public function eventFired(event)
    {
        var screen;
        var controller;
        
        super.eventFired(event);
        
        if(event.name == "goBack") {
            Game.sounds.playSFX("buttonPress");

            Game.popScreen();
        } else if (event.name == "catalogClicked") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, event.argument);
            
            Game.pushScreen(screen);
        }
    }
}
