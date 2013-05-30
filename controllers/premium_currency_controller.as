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
	static var activeScreen = null;
	static var activeController = null;
	
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
		
		PremiumCurrencyController.activeScreen = this.screen;
		PremiumCurrencyController.activeController = this;
	}
	
	override public function screenUnloaded()
	{
		PremiumCurrencyController.activeScreen = null;
		PremiumCurrencyController.activeController = null;
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
		else if(event.name == "dispatchDiamond") {
			start_payment(event.argument);
		}
		else if(event.name == "dispatchGameBucks") {
			start_payment(event.argument);
		}
	}
	
	public static function onPaymentFinished(packageName, result, error, param) 
	{
		var amount = 0;
		var currency = "";
		
		if (result == 1) {
			if(packageName == "fablife002") {
				currency = "Diamonds";
				amount = 10;
			}
			else if(packageName == "fablife003") {
				currency = "Diamonds";
				amount = 21;
			}
			else if(packageName == "fablife004") {
				currency = "Diamonds";
				amount = 55;
			}
			else if(packageName == "fablife005") {
				currency = "Diamonds";
				amount = 115;
			}
			else if(packageName == "fablife006") {
				currency = "GameBucks";
				amount = 10000;
			}
			else if(packageName == "fablife007") {
				currency = "GameBucks";
				amount = 21000;
			}
			else if(packageName == "fablife008") {
				currency = "GameBucks";
				amount = 55000;
			}
			else if(packageName == "fablife009") {
				currency = "GameBucks";
				amount = 115000;
			}
			
			var wallet = Game.sharedGame().wallet;
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
				if(PremiumCurrencyController.activeScreen) {
					PremiumCurrencyController.activeScreen.showFirstTimeBuyerPopup();
				}
			} else {
				db.put("user.purchase", purchaseCount++);
				Game.sounds.playSFX("gainSSP");
				Game.sharedGame().wife.incSocialStatusPoints(1000);
				Game.sharedGame().saveWife();
			}
			Game.trackEvent("Premium Purchase", "purchase-success", currency + "-"+ str(amount), 1);
		} 
		else  {
			if(PremiumCurrencyController.activeController) {
				PremiumCurrencyController.activeController.alert("Purchase failed: " + error);
			}
			Game.trackEvent("Premium Purchase", "purchase-fail", currency + "-"+ str(amount), 1);
		} 
	}

}//end class
