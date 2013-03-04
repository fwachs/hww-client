/*****************************************************************************
filename    passport_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class PassportScreen extends Screen
{
	var souvinirPurchase;
	
	public function PassportScreen(purchase)
	{
		super();
		this.souvinirPurchase = purchase;
	}
	
	override public function build()
	{
		
	}
	
	public function loadDestination(currentPage)
	{
		// reset souvenirs
		this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame.png");
		this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame.png");
		this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame.png");
		this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame.png");
		this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame.png");

		var souvenirTopLeftIcon = this.getElement("souvenirTopLeftIcon").getSprite();
		var souvenirTopRightIcon = this.getElement("souvenirTopRightIcon").getSprite();
		var souvenirBottomLeftIcon = this.getElement("souvenirBottomLeftIcon").getSprite();
		var souvenirBottomRightIcon = this.getElement("souvenirBottomRightIcon").getSprite();
		var souvenirMiddleIcon = this.getElement("souvenirMiddleIcon").getSprite();		
		
		if(currentPage == "London") {
			this.getElement("background").getSprite().texture("images/passport-screen/london-bg.jpg");
			
			// set icons to default
			souvenirTopLeftIcon.texture("images/gift-shop-icons/bulldog2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/gin2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/big-ben2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/buckingham-palace2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/fish-n-chips2.png");
			
			// check for unlocks
			if(Game.currentGame.passport.LondonSouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/bulldog.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/gin.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/big-ben.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/buckingham-palace.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/fish-n-chips.png");
			}
		}
		else if(currentPage == "SanFrancisco") {
			this.getElement("background").getSprite().texture("images/passport-screen/sf-bg.jpg");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/sourdough-bread2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/gg-bridge2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/dim-sum2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/cable-car2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/alcatraz2.png");
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/sourdough-bread.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/gg-bridge.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/dim-sum.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/cable-car.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/alcatraz.png");
			}
		}
		else if(currentPage == "Paris") {
			this.getElement("background").getSprite().texture("images/passport-screen/paris-bg.jpg");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/baguette2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/eiffel-tower2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/poodle2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/dress2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/wine2.png");
			
			if(Game.currentGame.passport.ParisSouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/baguette.png");
			}	
			
			if(Game.currentGame.passport.ParisSouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/eiffel-tower.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/poodle.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/dress.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/wine.png");
			}	
		}
		else if(currentPage == "BuenosAires") {
			this.getElement("background").getSprite().texture("images/passport-screen/paris-bg.jpg");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/el-obelisco2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/do-the-tango2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/puente-de-la-mujer2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/mate2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/el-caminito2.png");
			
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/el-obelisco.png");
			}	
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/do-the-tango.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/puente-de-la-mujer.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/mate.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/el-caminito.png");
			}	
		}
		else if(currentPage == "Tokyo") {
			this.getElement("background").getSprite().texture("images/passport-screen/tokyo-bg.jpg");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/sushi2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/sake2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/bullet-train2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/kinkakuji2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/kimono2.png");
			
			
			if(Game.currentGame.passport.TokyoSouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/sushi.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/sake.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/bullet-train.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/kinkakuji.png");
			}	
			
			if(Game.currentGame.passport.TokyoSouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/kimono.png");
			}
		}
		else if(currentPage == "Sydney") {
			this.getElement("background").getSprite().texture("images/passport-screen/ba-bg.jpg");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/koala2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/opera-house2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/harbour-bridge2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/kangaroo2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/manly-ferry.png");
			
			if(Game.currentGame.passport.SydneySouvenirs[0] == 1) {
				this.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/koala.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[1] == 1) {
				this.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/opera-house.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[2] == 1) {
				this.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/harbour-bridge.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[3] == 1) {
				this.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/kangaroo.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[4] == 1) {
				this.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/manly-ferry.png");
			}	
		}
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
		Game.sharedGame().passport.checkAchievements();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
}
