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

class ClothingShopController extends ScreenController
{
    var catalogName;
    public function ClothingShopController(controlledScreen, catalogName)
    {
        super(controlledScreen);
        this.catalogName = catalogName;
    }
    
    override public function screenLoaded()
    {
        var catalog = Game.sharedGame().getCatalog(this.catalogName);
        this.screen.display(catalog);
    }
    
    override public function eventFired(event)
    {
        var screen;
        var controller;
        
        super.eventFired(event);
        
        var catalog = Game.sharedGame().getCatalog(this.catalogName);
        if(event.name == "gotoMainMenu") {
            if(Game.currentScreen().getScreenName() != "main-screen") {
                Game.sounds.playSFX("buttonPress");
                Game.popToRoot();
            }
        } else if(event.name == "wearClothingItem") {
            var clothingItem = event.argument;
            trace("clothing item: ", clothingItem.name);
        } else if (event.name == "filterByDress") {
            this.screen.display(catalog, "Dress");
        } else if (event.name == "filterByShirts") {
            this.screen.display(catalog, "Top");
        } else if (event.name == "filterByPants") {
            this.screen.display(catalog, "Bottom");
        } else if (event.name == "filterByShoes") {
            this.screen.display(catalog, "Bottom");
        } else if (event.name == "filterByExtras") {
            this.screen.display(catalog, "Accessories");
        }  else if (event.name == "filterByHair") {
            this.screen.display(catalog, "Accessories");
        } else if (event.name == "showAllFashion") {
            this.screen.display(catalog);
        }
    }
}
