/*****************************************************************************
filename    wife_customization_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller

class PremiumCurrencyController extends ScreenController
{
	public function PremiumCurrencyController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("controlledScreen screenLoaded!");
		
		if (this.screen.defaultView == "viewGameBucks" ) {
			this.screen.getElement("viewGameBucks").getSprite().visible(1);
			this.screen.getElement("viewDiamond").getSprite().visible(0);
		} else {
			this.screen.getElement("viewGameBucks").getSprite().visible(0);
			this.screen.getElement("viewDiamond").getSprite().visible(1);
		}
	}
	
	
	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if(event.name == "goBack") {
			Game.popScreen();
		}
		else if(event.name == "dismiss") {
			Game.sounds.playSFX("buttonPress");
			this.dismissModalScreen();
		}
		else if(event.name == "showPurchasePapayas") {
		    openUrl("static_getpapayas", 1);
        }
		else if (event.name == "closePopup") {
			this.screen.hideFirstTimeBuyerPopup();
		}
		else if(event.name == "cancelButton") {
			this.screen.getElement("getmoreBox").getSprite().visible(0);
		}
		else if(event.name == "diamondViewButton") {
			this.screen.getElement("viewGameBucks").getSprite().visible(0);
			this.screen.getElement("viewDiamond").getSprite().visible(1);
		}
		else if(event.name == "gbViewButton"){
			this.screen.getElement("viewGameBucks").getSprite().visible(1);
			this.screen.getElement("viewDiamond").getSprite().visible(0);
		}
		var diamonds = event.name.replace("dispatchDiamond", "");
		trace("diamonds: " + str(diamonds));
		var gameBucks = event.name.replace("dispatchGameBucks", "");
		trace("game bucks : " + str(gameBucks));
		if (diamonds != event.name || gameBucks != event.name) {
			var currencyName;
			var description;
			var title;
			var amount;
			var papayas;
			var paymentParams;
			if (diamonds != event.name) {
				currencyName = "Diamonds";
				title = "Purchase Diamonds?";
				description = "Start living the fab life now!";
				paymentParams = diamonds.split(",");
				amount = int(paymentParams[1]);
				papayas = int(paymentParams[2]);
			} else {
				currencyName = "GameBucks";
				title = "Purchase GameBucks?";
				description = "Start living the fab life now!";
				paymentParams = gameBucks.split(",");
				amount = int(paymentParams[1]);
				papayas = int(paymentParams[2]);
			}
			start_payment(title, description, "", papayas, onPaymentFinished, dict([["amount", amount], ["currency", currencyName]]));
		}
	}
	
	public function onPaymentFinished(pid, ret, tid, receipt, param) {
		trace("onPaymentFinished", tid, receipt); 
		if (ret == 1) {
			var wallet = Game.sharedGame().wallet;
			var amount = param.get("amount");
			var currency = param.get("currency");
			var money = wallet.moneyForCurrency(amount, currency);
			wallet.purchaseCurrency(money, this);
			trace("### HWW ### - User purchased: ", amount, " ", currency);
			
			if(currency == "Diamonds") {
				Game.sounds.playSFX("reward");
				Game.sharedGame().unlockAchievement("High Roller");
			}
			
			if(currency == "GameBucks") {
				Game.sounds.playSFX("reward");
				Game.sharedGame().unlockAchievement("Big Spender");
			}
			
			var db = Game.getDatabase();
			var purchaseCount = db.get("user.purchase");
			if (purchaseCount == null) {
				db.put("user.purchase", 1);
				this.screen.showFirstTimeBuyerPopup();
			} else {
				db.put("user.purchase", purchaseCount++);
				Game.sounds.playSFX("gainSSP");
				Game.sharedGame().wife.incSocialStatusPoints(1000);
				Game.sharedGame.saveWife();
			}
			Game.trackEvent("Premium Purchase", "purchase-success", currency + "-"+ str(amount), 1);
		} else if( ret == -1) {
			var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Insufficient_Papayas);
			promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
			this.presentModalScreen(promptScreen);
			Game.trackEvent("Premium Purchase", "purchase-fail", currency + "-"+ str(amount), 1);
		} 
	}

}//end class
