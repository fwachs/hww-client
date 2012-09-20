/*****************************************************************************
filename    wife_customization_controller.as
author      Corey Blackburn
DP email    diego.burgos@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import models.gift_item

class ReceiveGiftController extends ScreenController
{
	var receivedGift;
	public function ReceiveGiftController(controlledScreen, receivedGift)
	{
		super(controlledScreen);
		this.receivedGift = receivedGift;
	}

	override public function screenLoaded()
	{
		trace("controlledScreen screenLoaded!");
	}

	override public function presentModalScreen(modalScreen)
	{
		super.presentModalScreen(modalScreen);
		var giftDescription = this.screen.getElement("state1GiftDescription");
		giftDescription.setText(receivedGift.get("senderName") + " sent you a gift.");
	}
	
	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if (event.name == "dontOpenItem") {
			this.screen.getElement("State1").getSprite().visible(0);
			this.dismissModalScreen();
		}
		else if (event.name == "openItem") {
			this.screen.getElement("State1").getSprite().visible(0);
			
			var gift = Game.sharedGame().getGift(str(receivedGift.get("id")));
			trace("open gift: ", gift.id, gift.description, gift.buffType, gift.buffFactor, gift.buffTime);
			
			this.screen.getElement("giftImage").getSprite().texture("images/" + gift.smallImage);
			this.screen.getElement("giftTitle").setText(gift.title);
			this.screen.getElement("giftDescription").setText(gift.description);
			this.screen.getElement("State2").getSprite().visible(1);

			Buffs.createBuffFromGift(gift);

		}
		else if (event.name == "btnOK") {
			this.dismissModalScreen();
		}
	}

}//end class
