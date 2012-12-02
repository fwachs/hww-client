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
import screens.clothing_catalog_screen
import controllers.clothing_catalog_controller

class HUDController extends ScreenController
{
	public function HUDController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("HUDController screenLoaded!");
		
		this.screen.ssp = this.screen.getElement("ssp-text");
		this.screen.ssp.setText(str(Game.sharedGame().wife.socialStatusPoints));

		this.screen.miles = this.screen.getElement("mileage-text");
		this.screen.miles.setText(str(Game.currentGame.wallet.getBalance("Miles")));

		this.screen.gamebucks = this.screen.getElement("gb-text");
		this.screen.gamebucks.setText(str(Game.currentGame.wallet.getBalance("GameBucks")));
		this.screen.diamonds = this.screen.getElement("diamond-text");
		this.screen.diamonds.setText(str(Game.currentGame.wallet.getBalance("Diamonds")));
		
		this.screen.screenUpdateTimer.start();
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
		else if(event.name == "gotoHouse") {
			Game.sounds.playSFX("buttonPress");
			
			Game.sounds.stop();
			Game.sounds.addMusic("houseMusic", "sounds/Housewife.House_Decorating.mp3");
			Game.sounds.playMusic("houseMusic");
			
			var house = Game.sharedGame().house;
			screen = new HouseScreen(house);
			screen.configFile = "screen-cfgs/house-screen-cfg.xml";
			controller = new HouseController(screen, house);
	
			Game.pushScreen(screen);
		}
		else if(event.name == "gotoTravel") {
			Game.sounds.playSFX("buttonPress");
			
			Game.sounds.stop();
			Game.sounds.addMusic("travelMusic", "sounds/Housewife.Travel2b.mp3");
			Game.sounds.playMusic("travelMusic");
			
			screen = new TravelScreen();
			screen.configFile = "screen-cfgs/travel-screen-cfg.xml";
			controller = new TravelController(screen);

			Game.pushScreen(screen);
		}
		else if(event.name == "gotoGossip") {
			Game.sounds.playSFX("buttonPress");
			
			screen = new GossipScreen();
			screen.configFile = "screen-cfgs/gossip-screen-cfg.xml";
			controller = new GossipController(screen);
	
			Game.pushScreen(screen);
		}
		else if(event.name == "viewLeaderboards") {
			Game.sounds.playSFX("buttonPress");
			openUrl("static_leaderboard", 1);
		}
		else if(event.name == "gotoCurrencyGb") {
			Game.sounds.playSFX("buttonPress");
			
			screen = new PremiumCurrencyScreen("viewGameBucks");
			screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
			controller = new PremiumCurrencyController(screen);
	
			Game.pushScreen(screen);
		}
		else if(event.name == "gotoCurrencyDiamonds") {
			Game.sounds.playSFX("buttonPress");
			
			screen = new PremiumCurrencyScreen("viewDiamond");
			screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
			controller = new PremiumCurrencyController(screen);
	
			Game.pushScreen(screen);
		}
		else if(event.name == "gotoCatalog") {
		    Game.sounds.playSFX("buttonPress");
		    screen = new ClothingCatalogScreen();
		    screen.configFile = "screen-cfgs/clothing-catalog-cfg.xml";
		    controller = new ClothingCatalogController(screen);
            
		    Game.pushScreen(screen);
        }
		else if(event.name == "gotoCloset") {
		    Game.sounds.playSFX("buttonPress");
            
            screen = new ClothingClosetScreen();
            screen.configFile = "screen-cfgs/clothing-closet-cfg.xml";
            controller = new ClothingClosetController(screen);
    
            Game.pushScreen(screen);
        }
	}
}
