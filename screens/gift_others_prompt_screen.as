/*****************************************************************************
filename    wife_customization_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen

class GiftOthersPromptScreen extends Screen
{
	public function GiftOthersPromptScreen()
	{
		super();
	}

	override public function build()
	{
	}

	public function drawGiftsWall()
	{
		var giftsScroll = this.getElement("giftsScroll");
		var left = 45;
		var yTop = 50;
		var gifts = Game.sharedGame().getGifts();
		var rowsGift = len(gifts) / 2;		
		var secondRow = 0;

		for (var i = 0; i < len(gifts); i++) {
			var gift = gifts[i];
			var params = dict();

			params.update("left_pos", str(left));
			params.update("top_pos", 50);
			params.update("gift_name", gift.title);
			params.update("gift_image", gift.smallImage);

			if (i >= rowsGift) {
				params.update("top_pos", 281);
				
				if (secondRow == 0 ) {
					params.update("top_pos", 281);
					left = 45;
					params.update("left_pos",45);
					secondRow = 1
				}
			}

			var scrollGiftItem = this.controlFromXMLTemplate("GiftOthersItem", params, "gift-others-item.xml");	
			scrollGiftItem.tapEvent.argument = gift;
			giftsScroll.addChild(scrollGiftItem);
			left += 230;
		}
		
		this.getElement("giftsScroll").setContentSize(left, 185);
	}
	public function showGiftItemPromt(gift) {
		this.getElement("giftImage").getSprite().texture("images/" + gift.image);
		this.getElement("giftTitle").setText(gift.title);
		this.getElement("giftDescription").setText(gift.itemDescription);
		var currencyIcon = "images/gift-others-prompt/game-buck.png";		
		if (gift.currency == "Diamonds") {
			currencyIcon = "images/gift-others-prompt/diamond-icon.png";
		}
		this.getElement("giftCurrencyIcon").getSprite().texture(currencyIcon);
		this.getElement("giftCurrencyAmount").setText(gift.amount);
		this.toggleFrameStack(1);
	}

	public function toggleFrameStack(visible) {
		this.getElement("confirmFrameStack").getSprite().visible(visible);
	}

	override public function gotFocus() {
		Game.showBanner(1, 1);
	}
}
