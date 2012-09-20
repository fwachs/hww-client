/*****************************************************************************
filename    wife_customization_controller.as
author      Corey Blackburn
DP email    diego.burgos@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import models.gift_item

class GiftOthersPromptController extends ScreenController
{
	var currentGift = null;
	var player;

	public function GiftOthersPromptController(controlledScreen, player)
	{
		super(controlledScreen);
		this.player = player;
	}
	
	override public function screenLoaded()
	{
		trace("controlledScreen screenLoaded!");
		this.screen.drawGiftsWall(Game.sharedGame().getGifts().values());
	}

	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if(event.name == "goBack") {
			Game.sounds.playSFX("buttonPress");
			Game.popScreen();
		} else if (event.name == "showGiftItemPromt") {
			this.currentGift = event.argument;
			this.screen.showGiftItemPromt(this.currentGift);
		}
		 else if (event.name == "dontSendItem") {
			Game.sounds.playSFX("buttonPress");
			this.currentGift = null;
			this.screen.toggleFrameStack(0);
		}
		 else if (event.name == "sendItem") {
			var ret = Game.currentGame.shop.buyGift(this.currentGift);
			if (ret == 1) {
				this.screen.toggleFrameStack(0);			
				var params = dict();
				params.update("senderName", Game.sharedGame().wife.name);
				trace("### HWW ### sender name: " + Game.sharedGame().wife.name);
				params.update("id", this.currentGift.id);
				params.update("papayaUserId", this.player.papayaUserId);
				Game.sharedGame().getServer().sendGift(params);
				
				ppy_query("send_notification", dict([["message", Game.sharedGame().wife.name + " has sent you a gift."], ["uid", this.player.papayaUserId]]) , null, null);
				
				if(this.currentGift.type == "GIFT") {
					Game.sounds.playSFX("buttonPress");
					Game.sharedGame().unlockAchievement("Generosity");				
				}
				
				if(this.currentGift.type == "TRAP") {
					Game.sounds.playSFX("sabotageGift");
					Game.sharedGame().unlockAchievement("Backstabber");
				}
			} else {
				var screen;
				var controller;
				
				if(this.currentGift.currency == "GameBucks") {
					screen = new PremiumCurrencyScreen("viewGameBucks");
					screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
					controller = new PremiumCurrencyController(screen);
					Game.pushScreen(screen);
				}
				else if(this.currentGift.currency == "Diamonds") {
					screen = new PremiumCurrencyScreen("viewDiamond");
					screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
					controller = new PremiumCurrencyController(screen);
					Game.pushScreen(screen);
				}
			}
		}
	}
	
	
}//end class
