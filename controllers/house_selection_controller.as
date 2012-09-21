/*****************************************************************************
filename    house_selection_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

import framework.screen_controller
import framework.event

class HouseSelectionController extends ScreenController
{
    var showingHouse;
    var selectedHouse;

    public function HouseSelectionController(controlledScreen)
    {
        super(controlledScreen);
    }

    override public function screenLoaded()
    {
        if(this.screen.firstTime == 1) {
            this.displayHouse(this.screen.houseListing[0]);
            this.selectHouse();
            this.screen.getElement("tutorial-step-1").getSprite().visible(1);
//          this.screen.showNextTutorial();
        }
        else {
            this.selectedHouse = this.getSelectedHouse();
            this.displayHouse(this.selectedHouse);
            this.selectHouse();
        }
    }

    override public function screenUnloaded()
    {
    }

    override public function eventFired(event)
    {
        super.eventFired(event);

        if(event.name == "houseSelected") {
            this.selectHouse();
        }
        else if(event.name == "showHouse") {
            Game.sounds.playSFX("buttonPress");
            displayHouse(event.argument);
        }
        else if(event.name == "buyWithDiamonds") {
            Game.sounds.playSFX("buttonPress");
            buyHouse();
        }
        else if(event.name == "buyWithGameBucks") {
            Game.sounds.playSFX("buttonPress");
            buyHouse();
        }
        else if(event.name == "goback") {
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

    public function selectHouse()
    {
        // make sure we own the house that is showing before we can select it.
        if(Game.sharedGame().realestate.propertyListing[int(this.showingHouse.fileNumber) - 1] == 1) {
            this.selectedHouse = this.showingHouse;
            this.updateCheckmark();
            Game.sharedGame().house.setSelectedStyle(this.selectedHouse.houseStyle);
        }
    }

    public function buyHouse()
    {
        if(Game.sharedGame().hubby.careerLevel >= int(this.showingHouse.hubbyLvlReq)) {
            trace("### HWW ### - House price " + this.showingHouse.price);

            var ret = Game.sharedGame().shop.buyHouse(this.showingHouse);
            if(ret == 1) {
                Game.sharedGame().realestate.propertyListing[int(this.showingHouse.fileNumber) - 1] = 1;
                Game.sharedGame().saveRealestate();

                if(this.showingHouse.type == "Premium")
                    Game.sharedGame().unlockAchievement("Living Large");

                this.screen.getElement("buyButtonDiamonds").getSprite().visible(0);
                this.screen.getElement("buyButtonGameBucks").getSprite().visible(0);
                this.screen.getElement("owned").getSprite().visible(1);

                var houseSelectionBar = this.screen.getElement("houseSelectionBar");
                houseSelectionBar.removeAllChildren();
                this.screen.displayHouses();

                Game.sharedGame().house.setSelectedStyle(this.showingHouse.houseStyle);
            }
            else {
                var screen;
                var controller;

                if(this.showingHouse.currency == "GameBucks") {
                    screen = new PremiumCurrencyScreen("viewGameBucks");
                    screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
                    controller = new PremiumCurrencyController(screen);
                    Game.pushScreen(screen);
                }
                else if(this.showingHouse.currency == "Diamonds") {
                    screen = new PremiumCurrencyScreen("viewDiamond");
                    screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
                    controller = new PremiumCurrencyController(screen);
                    Game.pushScreen(screen);
                }
            }
        }
        else {
            var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_House_Select_Insufficient_Level);
            promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
            this.presentModalScreen(promptScreen);
        }
    }

    public function updateCheckmark()
    {
        var asset = "";

        if(this.showingHouse == this.selectedHouse) {
            asset = "images/tutorial-icons/check-select.png";
        }
        else {
            asset = "images/house-select/house-select-screen/check-box-open.png";
        }

        this.screen.getElement("checkHouse").getSprite().texture(asset)
    }

    public function displayHouse(house)
    {
        trace("Display house: ", house.fileNumber);
        this.screen.getElement("houseOnDisplay").getSprite().texture("images/house-select/house-select-screen/house-" + house.fileNumber + ".jpg");
        this.screen.houseNameLabel.setText(house.name);

        this.showingHouse = house;

        this.updateCheckmark();

        if(Game.sharedGame().realestate.propertyListing[int(house.fileNumber) - 1] == 0) {
            if(house.currency == "Diamonds") {
                this.screen.getElement("buyButtonDiamonds").getSprite().visible(1);
                this.screen.getElement("buyButtonGameBucks").getSprite().visible(0);
                this.screen.getElement("owned").getSprite().visible(0);
                this.screen.costDiamondsLabel.setText(house.price);
            }
            else if(house.currency == "GameBucks") {
                this.screen.getElement("buyButtonDiamonds").getSprite().visible(0);
                this.screen.getElement("buyButtonGameBucks").getSprite().visible(1);
                this.screen.getElement("owned").getSprite().visible(0);
                this.screen.costGameBucksLabel.setText(house.price);
            }
            else {
                trace("Unknown house currency: " + str(house.currency));
            }
        }
        else {
            this.screen.getElement("buyButtonDiamonds").getSprite().visible(0);
            this.screen.getElement("buyButtonGameBucks").getSprite().visible(0);
            this.screen.getElement("owned").getSprite().visible(1);
        }
    }

    public function getSelectedHouse()
    {
        for(var i = 0; i < len(this.screen.houseListing); i++) {

            var house = this.screen.houseListing[i];
            var houseStyleId = Game.sharedGame().house.styles.get(house.houseStyle);

            if(houseStyleId == Game.sharedGame().house.selectedStyle) {
                return house;
            }
        }

        // couldn't find house by skin return first free house.
        return this.screen.houseListing[4];
    }
}
