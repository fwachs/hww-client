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
import screens.clothing_catalog_screen
import controllers.clothing_catalog_controller

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
        super.eventFired(event);

        var wife = Game.sharedGame().wife;
        var promptScreen;
        Game.sounds.playSFX("buttonPress");
        if(event.name == "gotoMainMenu") {
            if (wife.canLeaveCloset() == 1) {
                if(Game.currentScreen().getScreenName() != "main-screen") {
                    Game.popToRoot();
                }
            } else {
                promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_ClothingValidation);
                promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
                this.presentModalScreen(promptScreen);
            }
        } else if (event.name == "gotoMagazinesScreen") {
            if (wife.canLeaveCloset() == 1) {
                var screen = new ClothingCatalogScreen();
                screen.configFile = "screen-cfgs/clothing-catalog-cfg.xml";
                var controller = new ClothingCatalogController(screen);
                
                Game.pushScreen(screen);
            } else {
                promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_ClothingValidation);
                promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
                this.presentModalScreen(promptScreen);
            
            }
        } else if(event.name == "dismiss") {
            this.dismissModalScreen();
        } else if(event.name == "wearClothingItem") {
            this.selectedClothingItem = event.argument;
            Game.sharedGame().wife.wear(this.selectedClothingItem.clothingItem, this.screen);
        }  else if (event.name == "undress") {
            wife.showNaked(this.screen);
            wife.removeClothingItems();
            this.screen.getElement("fashionScoreTotalText").setText(str(wife.calculateFashionPoints()));
        }  else if (event.name == "filterByDress") {
            this.screen.display("Dress");
            this.appliedFilter = "Dress";
        } else if (event.name == "filterByShirts") {
            this.screen.display("Top");
            this.appliedFilter = "Top";
        } else if (event.name == "filterByPants") {
            this.screen.display("Bottom");
            this.appliedFilter = "Bottom";
        } else if (event.name == "filterByShoes") {
            this.screen.display("Shoes");
            this.appliedFilter = "Shoes";
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
