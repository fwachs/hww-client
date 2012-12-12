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
import screens.clothing_closet_screen
import controllers.clothing_closet_controller


class ClothingShopController extends ScreenController
{
    var catalogName;
    var previousClothingItem;
    var selectedClothingItem;
    var appliedFilter;

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
        Game.sounds.playSFX("buttonPress");

        var catalog = Game.sharedGame().getCatalog(this.catalogName);
        if(event.name == "gotoMainMenu") {
            if(Game.currentScreen().getScreenName() != "main-screen") {
                Game.sounds.playSFX("buttonPress");
                Game.popToRoot();
            }
        } else if (event.name == "gotoMagazinesScreen") {
            Game.popScreen();
        } else if (event.name == "gotoFashionClosetScreen") {
            var closetScreen = new ClothingClosetScreen();
            closetScreen.configFile = "screen-cfgs/clothing-closet-cfg.xml";
            var closetController = new ClothingClosetController(closetScreen);
    
            Game.pushScreen(closetScreen);
        } else if(event.name == "wearClothingItem") {
            this.previousClothingItem = this.selectedClothingItem;
            this.selectedClothingItem = event.argument;
            Game.sharedGame().wife.testClothingItem(this.selectedClothingItem, this.screen);
            this.screen.displayPurchaseButton(this.selectedClothingItem);
            if (this.previousClothingItem.id != this.selectedClothingItem.id) {
                this.screen.hidePurchaseButton(this.previousClothingItem);
            }
        } else if (event.name == "purchaseClothingItem") {
            var ret = Game.sharedGame().shop.buyClothingItem(this.selectedClothingItem);
            if(ret == 1) {
                Game.sharedGame().purchasedClothingItems.addClothingItem(this.selectedClothingItem);
                this.screen.display(catalog, this.appliedFilter);
            } else {
                this.pushPremiumCurrencyScreen(this.selectedClothingItem);
            }
            this.selectedClothingItem = null;
            this.previousClothingItem = null;
        } else if (event.name == "filterByDress") {
            this.screen.display(catalog, "Dress");
            this.appliedFilter = "Dress";
        } else if (event.name == "filterByShirts") {
            this.screen.display(catalog, "Top");
            this.appliedFilter = "Top";
        } else if (event.name == "filterByPants") {
            this.screen.display(catalog, "Bottom");
            this.appliedFilter = "Bottom";
        } else if (event.name == "filterByShoes") {
            this.screen.display(catalog, "Bottom");
            this.appliedFilter = "Bottom";
        } else if (event.name == "filterByExtras") {
            this.screen.display(catalog, "Accessories");
            this.appliedFilter = "Accessories";
        }  else if (event.name == "filterByHair") {
            this.screen.display(catalog, "Accessories");
            this.appliedFilter = "Accessories";
        } else if (event.name == "showAllFashion") {
            this.screen.display(catalog);
            this.appliedFilter = "All";
        }
    }

    public function pushPremiumCurrencyScreen() {
        var screen = new PremiumCurrencyScreen("viewDiamond");
        screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
        var controller = new PremiumCurrencyController(screen);
        Game.pushScreen(screen);
    }

}
