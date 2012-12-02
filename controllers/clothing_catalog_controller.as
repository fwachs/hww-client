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
    }
    
    override public function eventFired(event)
    {
        var screen;
        var controller;
        
        super.eventFired(event);
        
        if(event.name == "goBack") {
            Game.sounds.playSFX("buttonPress");

            Game.popScreen();
        } else if(event.name == "goToLondonCatalogue") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, "London");
            
            Game.pushScreen(screen);
        } else if(event.name == "goToSanFranciscoCatalogue") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, "San Francisco");
            
            Game.pushScreen(screen);
        } else if(event.name == "goToParisCatalogue") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, "Paris");
            
            Game.pushScreen(screen);
        } else if(event.name == "goToBuenosAiresCatalogue") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, "Buenos Aires");
            
            Game.pushScreen(screen);
        } else if(event.name == "goToTokyoCatalogue") {
            screen = new ClothingShopScreen();
            screen.configFile = "screen-cfgs/clothing-shop-cfg.xml";
            controller = new ClothingShopController(screen, "Tokyo");
            
            Game.pushScreen(screen);
        }
    }
}
