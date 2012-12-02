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
    var appliedFilter;
    var selectedClothingItem;

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
        } else if(event.name == "wearClothingItem") {
            this.selectedClothingItem = event.argument;
            Game.sharedGame().wife.wear(this.selectedClothingItem.clothingItem, this.screen);
        } else if (event.name == "filterByDress") {
            this.screen.display("Dress");
            this.appliedFilter = "Dress";
        } else if (event.name == "filterByShirts") {
            this.screen.display("Top");
            this.appliedFilter = "Top";
        } else if (event.name == "filterByPants") {
            this.screen.display("Bottom");
            this.appliedFilter = "Bottom";
        } else if (event.name == "filterByShoes") {
            this.screen.display("Bottom");
            this.appliedFilter = "Bottom";
        } else if (event.name == "filterByExtras") {
            this.screen.display("Accessories");
            this.appliedFilter = "Accessories";
        }  else if (event.name == "filterByHair") {
            this.screen.display("Accessories");
            this.appliedFilter = "Accessories";
        } else if (event.name == "showAllFashion") {
            this.screen.display();
            this.appliedFilter = "All";
        }
    }
}
