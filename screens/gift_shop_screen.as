/*****************************************************************************
filename    gift_shop_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class GiftShopScreen extends Screen
{
	public function GiftShopScreen()
	{
		super();
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
		this.startGiftShopIdleAnimation();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
		this.stopGiftShopIdleAnimation();
		this.stopGiftShopEndAnimation();
	}
	
	public function startGiftShopIdleAnimation()
	{
		//var balloonsAnimation = this.getElement("balloonsAnimation").getSprite();
		//var action = Game.animations.getAnimation("gift_shop_balloons");
		//balloonsAnimation.stop();
		//balloonsAnimation.addaction(repeat(action));
		
		var peopleAnimation = this.getElement("peopleAnimation").getSprite();
		var action = Game.animations.getAnimation("gift_shop_people");
		peopleAnimation.stop();
		peopleAnimation.addaction(repeat(action));
	}
	
	public function stopGiftShopIdleAnimation()
	{
		//this.getElement("balloonsAnimation").getSprite().stop();
		this.getElement("peopleAnimation").getSprite().stop();
	}
	
	public function startGiftShopEndAnimation()
	{
		//var balloonsAnimation = this.getElement("balloonsAnimation").getSprite();
		//var action = Game.animations.getAnimation("gift_shop_balloons");
		//balloonsAnimation.stop();
		//balloonsAnimation.addaction(repeat(action));
		// stop animation after 21 run-thrus
		//c_invoke(stopBalloonAnimation, 8736, null);
		//c_invoke(stopBalloonAnimation, 4160, null);
		
		var peopleAnimation = this.getElement("peopleAnimation").getSprite();
		var action = Game.animations.getAnimation("gift_shop_end");
		peopleAnimation.stop();
		peopleAnimation.addaction(repeat(action));
	}
	
	public function stopBalloonAnimation()
	{
		//this.getElement("balloonsAnimation").getSprite().stop();
	}
	
	public function stopGiftShopEndAnimation()
	{
		this.getElement("peopleAnimation").getSprite().stop();
	}
}
