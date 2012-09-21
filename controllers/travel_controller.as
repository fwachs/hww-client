/*****************************************************************************
filename    travel_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen_controller

import framework.event
import screens.gift_shop_screen
import controllers.gift_shop_controller

class City
{
    var name;
    var price
    var currency;

    public function City()
    {
    }
}

class TravelController extends ScreenController
{
    var startLocation;
    var endLocation;

    var LondonCostText;
    var SanFranciscoCostText;
    var ParisCostText;
    var BuenosAiresCostText;
    var TokyoCostText;
    var SydneyCostText;

    var LondonCost;
    var SanFranciscoCost;
    var ParisCost;
    var BuenosAiresCost;
    var TokyoCost;
    var SydneyCost;

    var LondonUnlocked;
    var SanFranciscoUnlocked;
    var ParisUnlocked;
    var BuenosAiresUnlocked;
    var TokyoUnlocked;
    var SydneyUnlocked;

    var travelTimer;

    public function TravelController(controlledScreen)
    {
        super(controlledScreen);
    }

    override public function screenLoaded()
    {
        trace("TravelController screenLoaded!");

        LondonCost = Game.sharedGame().shop.getTravelCost("London");
        SanFranciscoCost = Game.sharedGame().shop.getTravelCost("SanFrancisco");
        ParisCost = Game.sharedGame().shop.getTravelCost("Paris");
        BuenosAiresCost = Game.sharedGame().shop.getTravelCost("BuenosAires");
        TokyoCost = Game.sharedGame().shop.getTravelCost("Tokyo");
        SydneyCost = Game.sharedGame().shop.getTravelCost("Sydney");

        LondonCostText = this.screen.getElement("LondonCostText").getSprite().addlabel("Only " + getCostTest(LondonCost) + " Miles", "Arial",Game.translateFontSize(30));
        SanFranciscoCostText = this.screen.getElement("SanFranciscoCostText").getSprite().addlabel("Only " + getCostTest(SanFranciscoCost) + " Miles", "Arial",Game.translateFontSize(30));
        ParisCostText = this.screen.getElement("ParisCostText").getSprite().addlabel("Only " + getCostTest(ParisCost) + " Miles", "Arial",Game.translateFontSize(30));
        BuenosAiresCostText = this.screen.getElement("BuenosAiresCostText").getSprite().addlabel("Only " + getCostTest(BuenosAiresCost) + " Miles", "Arial",Game.translateFontSize(30));
        TokyoCostText = this.screen.getElement("TokyoCostText").getSprite().addlabel("Only " + getCostTest(TokyoCost) + " Miles", "Arial",Game.translateFontSize(30));
        SydneyCostText = this.screen.getElement("SydneyCostText").getSprite().addlabel("Only " + getCostTest(SydneyCost) + " Diamonds", "Arial",Game.translateFontSize(30));

        this.travelTimer = new planeTravelTimer();
    }

    override public function showTutorial()
    {
        this.showMessageBox(MessageBoxScreen.MB_TravelTutorial);
    }

    override public function eventFired(event)
    {
        super.eventFired(event);

        if(event.name == "getLocation") {
            trace("get location");
            startLocation = event.x;
            trace(str(startLocation));
        }
        else if(event.name == "slideCities") {
            trace("slide cities");
            endLocation = event.x;
            trace(str(endLocation));

            var slider = this.screen.getElement("travelOptionsFrame").getSprite();
            var dist = endLocation - startLocation;
            trace(str(dist));

            var posX = slider.pos()[0];
            var posY = slider.pos()[1];
            slider.pos(posX + dist, posY);

            trace(str(slider.pos()[0]));

            // clamp
            if(slider.pos()[0] < Game.translateX(-2350))
                slider.pos(Game.translateX(-2350), posY);

            if(slider.pos()[0] > Game.translateX(50))
                slider.pos(Game.translateX(50), posY);
        }
        else if (event.name == "goToLondon") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("goToLondon").getSprite().texture("images/travel-screen/go-button-highlight.png");
            buyTicketToLondon();
        }
        else if (event.name == "goToSanFrancisco") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("goToSanFrancisco").getSprite().texture("images/travel-screen/go-button-highlight.png");
            buyTicketToSanFrancisco();
        }
        else if (event.name == "goToParis") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("goToParis").getSprite().texture("images/travel-screen/go-button-highlight.png");
            buyTicketToParis();
        }
        else if (event.name == "goToBuenosAires") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("goToBuenosAires").getSprite().texture("images/travel-screen/go-button-highlight.png");
            buyTicketToBuenosAires();
        }
        else if (event.name == "goToTokyo") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("goToTokyo").getSprite().texture("images/travel-screen/go-button-highlight.png");
            buyTicketToTokyo();
        }
        else if (event.name == "goToSydney") {
            if(Game.sharedGame().passport.citiesVisited >= 5) {
                Game.sounds.playSFX("buttonPress");
                this.screen.getElement("goToSydney").getSprite().texture("images/travel-screen/go-button-highlight.png");
                buyTicketToSydney();
            }
            else {
                var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Travel_Sydney);
                promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
                this.presentModalScreen(promptScreen);
            }
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "goback") {
            Game.sounds.playSFX("buttonPress");

            Game.sounds.stop();
            Game.sounds.addMusic("themeMusic", "sounds/Housewife.Theme.1.mp3");
            Game.sounds.playMusic("themeMusic");

            Game.popScreen();
        }
        else if(event.name == "doNothing") {
        }
    }

    public function getCostTest(value)
    {
        var thousands = value / 1000;
        var hundreds = value - (thousands * 1000);
        var costText;

        if (thousands != 0) {
            costText = str(thousands) + ",000";
        }
        else {
            costText = str(hundreds);
        }

        return costText;
    }

    public function flyTo(location)
    {
        this.screen.getElement("travelOptionsFrame").getSprite().visible(0);
        this.screen.getElement("travelPortalFrame").getSprite().visible(1);
        var travelImage = this.screen.getElement("travelImage").getSprite();

        if(location == "London") {
            if(Game.sharedGame().passport.londonFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(1500);
                Game.sharedGame().passport.londonFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to London");
            GiftShopController.travelDestination = "London";
            travelImage.texture("images/travel-portal/london-travel.png");
        }
        else if(location == "SanFrancisco") {
            if(Game.sharedGame().passport.SanFranciscoFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(3000);
                Game.sharedGame().passport.SanFranciscoFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to SanFrancisco");
            GiftShopController.travelDestination = "SanFrancisco";
            travelImage.texture("images/travel-portal/sf-travel.png");
        }
        else if(location == "Paris") {
            if(Game.sharedGame().passport.ParisFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(6000);
                Game.sharedGame().passport.ParisFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to Paris");
            GiftShopController.travelDestination = "Paris";
            travelImage.texture("images/travel-portal/paris-travel.png");
        }
        else if(location == "BuenosAires") {
            if(Game.sharedGame().passport.BuenosAiresFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(11000);
                Game.sharedGame().passport.BuenosAiresFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to BuenosAires");
            GiftShopController.travelDestination = "BuenosAires";
            travelImage.texture("images/travel-portal/buenos-aires-travel.png");
        }
        else if(location == "Tokyo") {
            if(Game.sharedGame().passport.TokyoFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(24000);
                Game.sharedGame().passport.TokyoFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to Tokyo");
            GiftShopController.travelDestination = "Tokyo";
            travelImage.texture("images/travel-portal/tokyo-travel.png");
        }
        else if(location == "Sydney") {
            if(Game.sharedGame().passport.SydneyFirstVisit) {
                Game.sharedGame().wife.incSocialStatusPoints(30000);
                Game.sharedGame().passport.SydneyFirstVisit = 0;
                Game.sharedGame().passport.citiesVisited += 1;
            }

            trace("off to Sydney");
            GiftShopController.travelDestination = "Sydney";
            travelImage.texture("images/travel-portal/sydney-travel.png");
        }

        //ppy_postnewsfeed(Game.sharedGame().wife.name + " has traveled to " + location + ".", "http://www.2clams.com", null);

        Game.shardGame().savePassport();
        Game.shardGame().saveWife();

        this.screen.getElement("plane").getSprite().addaction(moveby(Game.translateX(5800), Game.translateX(1300),0));
        c_invoke(this.showGiftShopScreen, 5800, null);
    }

    public function showGiftShopScreen() {
        var giftShopScreen = new GiftShopScreen();
        giftShopScreen.configFile = "screen-cfgs/gift-shop-screen-cfg.xml";
        var controller = new GiftShopController(giftShopScreen);

        Game.pushScreen(giftShopScreen);
    }
    /*****************************************************************************
    Message Box Functions
    *****************************************************************************/

    function buyTicketTo(destination)
    {
        var ret = Game.currentGame.shop.buyTripTo(destination);
        if(ret == 1) {
            flyTo(destination);
        }
        else {
            var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Insufficient_Miles);
            promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
            this.presentModalScreen(promptScreen);
        }
    }

    function buyTicketToLondon()
    {
        buyTicketTo("London");
    }

    function buyTicketToSanFrancisco()
    {
        buyTicketTo("SanFrancisco");
    }

    function buyTicketToParis()
    {
        buyTicketTo("Paris");
    }

    function buyTicketToBuenosAires()
    {
        buyTicketTo("BuenosAires");
    }

    function buyTicketToTokyo()
    {
        buyTicketTo("Tokyo");
    }

    function buyTicketToSydney()
    {
        buyTicketTo("Sydney");
    }
}

/*****************************************************************************
Timers
*****************************************************************************/

class planeTravelTimer extends Timer
{
    public function planeTravelTimer()
    {
        super("planeTravelTimer", 6, 1);
    }

    override public function tick()
    {
        this.stop();
        var giftShopScreen = new GiftShopScreen();
        giftShopScreen.configFile = "screen-cfgs/gift-shop-screen-cfg.xml";
        var controller = new GiftShopController(giftShopScreen);

        Game.pushScreen(giftShopScreen);
    }
}
