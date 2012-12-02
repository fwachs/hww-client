/*****************************************************************************
filename    passport_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event
//import screens.main_screen
//import controllers.main_controller

class PassportController extends ScreenController
{
	var currentPage;
	var souvenirTopLeftCaption;
	var souvenirTopRightCaption;
	var souvenirBottomLeftCaption;
	var souvenirBottomRightCaption;
	var souvenirMiddleCaption;
	
	var souvenirTopLeftIcon;
	var souvenirTopRightIcon;
	var souvenirBottomLeftIcon;
	var souvenirBottomRightIcon;
	var souvenirMiddleIcon;
	
	var stampCompletedDateLabel;

	public function PassportController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("PassportController screenLoaded!");
		
		// check if we are traveling or just looking at our passport
		if(GiftShopController.travelDestination == null) {
			currentPage = "London";
		}
		else {
			currentPage = GiftShopController.travelDestination;
		}
		
		stampCompletedDateLabel = this.screen.getElement("achievementbadge").getSprite().addlabel(Game.sharedGame().today, Game.getFont(), Game.translateFontSize(24));
		stampCompletedDateLabel.pos(Game.translateX(100), Game.translateY( 140));
		stampCompletedDateLabel.color(0,0,0);
		
		// Souvenir Icons
		souvenirTopLeftIcon = this.screen.getElement("souvenirTopLeftIcon").getSprite();
		souvenirTopLeftIcon.pos(Game.translateX(170), Game.translateY( 151));
		souvenirTopLeftIcon.rotate(-29);
		
		
		souvenirTopRightIcon = this.screen.getElement("souvenirTopRightIcon").getSprite();
		souvenirTopRightIcon.pos(Game.translateX(910), Game.translateY( 88));
		souvenirTopRightIcon.rotate(21);
		
		
		souvenirBottomLeftIcon = this.screen.getElement("souvenirBottomLeftIcon").getSprite();
		souvenirBottomLeftIcon.pos(Game.translateX(295), Game.translateY( 405));
		souvenirBottomLeftIcon.rotate(21);
		
		
		souvenirBottomRightIcon = this.screen.getElement("souvenirBottomRightIcon").getSprite();
		souvenirBottomRightIcon.pos(Game.translateX(805), Game.translateY( 488));
		souvenirBottomRightIcon.rotate(-29);
		
		
		souvenirMiddleIcon = this.screen.getElement("souvenirMiddleIcon").getSprite();
		souvenirMiddleIcon.pos(Game.translateX(515), Game.translateY( 370));
		souvenirMiddleIcon.rotate(-12);
		
		// Souvenir Captions
		souvenirTopLeftCaption = this.screen.getElement("souvenirTopLeftCaption").getSprite().addlabel("Working!", Game.getFont(), Game.translateFontSize(24));
		souvenirTopLeftCaption.rotate(-29);
		souvenirTopLeftCaption.color(0,0,0);
		
		souvenirTopRightCaption = this.screen.getElement("souvenirTopRightCaption").getSprite().addlabel("Working!", Game.getFont(), Game.translateFontSize(24));
		souvenirTopRightCaption.rotate(21);
		souvenirTopRightCaption.color(0,0,0);
		
		souvenirBottomLeftCaption = this.screen.getElement("souvenirBottomLeftCaption").getSprite().addlabel("Working!", Game.getFont(), Game.translateFontSize(24));
		souvenirBottomLeftCaption.rotate(21);
		souvenirBottomLeftCaption.color(0,0,0);
		
		souvenirBottomRightCaption = this.screen.getElement("souvenirBottomRightCaption").getSprite().addlabel("Working!", Game.getFont(), Game.translateFontSize(24));
		souvenirBottomRightCaption.rotate(-29);
		souvenirBottomRightCaption.color(0,0,0);
		
		souvenirMiddleCaption = this.screen.getElement("souvenirMiddleCaption").getSprite().addlabel("Working!", Game.getFont(), Game.translateFontSize(24));
		souvenirMiddleCaption.rotate(-12);
		souvenirMiddleCaption.color(0,0,0);
		
		setPage();
		
		if(this.screen.souvinirPurchase == 1) {
			Game.sounds.playSFX("unlockItem");
		}
	}
	
	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if(event.name == "goback") {
			Game.sounds.playSFX("buttonPress");
			Game.popScreen();
		}
		else if(event.name == "gotomainmenu") {
			Game.sounds.playSFX("buttonPress");
			
			var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Travel_Return);
			promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
			this.presentModalScreen(promptScreen);
		}
		else if(event.name == "travelReturn") {
			Game.sounds.playSFX("buttonPress");
			this.dismissModalScreen();
			hreturnhome();
		}
		else if(event.name == "dismiss") {
			Game.sounds.playSFX("buttonPress");
			this.dismissModalScreen();
		}
	}
	
	public function setPage()
	{
		// reset souvenirs
		this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame.png");
		this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame.png");
		this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame.png");
		this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame.png");
		this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame.png");
				
		if(currentPage == "London") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/london-bg.jpg");
			souvenirTopLeftCaption.text("Bulldog");
			souvenirTopRightCaption.text("Gin");
			souvenirBottomLeftCaption.text("Big Ben");
			souvenirBottomRightCaption.text("Buckingham Palace");
			souvenirMiddleCaption.text("Fish and Chips");
			
			// set icons to default
			souvenirTopLeftIcon.texture("images/gift-shop-icons/bulldog2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/gin2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/big-ben2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/buckingham-palace2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/fish-n-chips2.png");
			
			// check for unlocks
			if(Game.currentGame.passport.LondonSouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/bulldog.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/gin.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/big-ben.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/buckingham-palace.png");
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/fish-n-chips.png");
			}
		}
		else if(currentPage == "SanFrancisco") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/sf-bg.jpg");
			souvenirTopLeftCaption.text("Sourdough Bread");
			souvenirTopRightCaption.text("Golden Gate");
			souvenirBottomLeftCaption.text("Dim Sum");
			souvenirBottomRightCaption.text("Cable Car");
			souvenirMiddleCaption.text("Alcatraz");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/sourdough-bread2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/gg-bridge2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/dim-sum2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/cable-car2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/alcatraz2.png");
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/sourdough-bread.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/gg-bridge.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/dim-sum.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/cable-car.png");
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/alcatraz.png");
			}
		}
		else if(currentPage == "Paris") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/paris-bg.jpg");
			souvenirTopLeftCaption.text("Baguette");
			souvenirTopRightCaption.text("Eiffel Tower");
			souvenirBottomLeftCaption.text("Poodle");
			souvenirBottomRightCaption.text("Dress");
			souvenirMiddleCaption.text("Wine");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/baguette2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/eiffel-tower2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/poodle2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/dress2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/wine2.png");
			
			if(Game.currentGame.passport.ParisSouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/baguette.png");
			}	
			
			if(Game.currentGame.passport.ParisSouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/eiffel-tower.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/poodle.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/dress.png");
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/wine.png");
			}	
		}
		else if(currentPage == "BuenosAires") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/paris-bg.jpg");
			souvenirTopLeftCaption.text("El Obelisco");
			souvenirTopRightCaption.text("Tango");
			souvenirBottomLeftCaption.text("Puente de la Mujer");
			souvenirBottomRightCaption.text("Yerba Mate");
			souvenirMiddleCaption.text("Caminito");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/el-obelisco2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/do-the-tango2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/puente-de-la-mujer2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/mate2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/el-caminito2.png");
			
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/el-obelisco.png");
			}	
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/do-the-tango.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/puente-de-la-mujer.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/mate.png");
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/el-caminito.png");
			}	
		}
		else if(currentPage == "Tokyo") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/tokyo-bg.jpg");
			souvenirTopLeftCaption.text("Sushi");
			souvenirTopRightCaption.text("Sake");
			souvenirBottomLeftCaption.text("Shinkansen");
			souvenirBottomRightCaption.text("Kinkakuji");
			souvenirMiddleCaption.text("Kimono");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/sushi2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/sake2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/bullet-train2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/kinkakuji2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/kimono2.png");
			
			
			if(Game.currentGame.passport.TokyoSouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/sushi.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/sake.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/bullet-train.png");
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/kinkakuji.png");
			}	
			
			if(Game.currentGame.passport.TokyoSouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/kimono.png");
			}
		}
		else if(currentPage == "Sydney") {
			this.screen.getElement("background").getSprite().texture("images/passport-screen/ba-bg.jpg");
			souvenirTopLeftCaption.text("Koala");
			souvenirTopRightCaption.text("Opera House");
			souvenirBottomLeftCaption.text("Sydney Harbor Bridge");
			souvenirBottomRightCaption.text("Kangaroo");
			souvenirMiddleCaption.text("Manly Ferry");
			
			// set to defaults
			souvenirTopLeftIcon.texture("images/gift-shop-icons/koala2.png");
			souvenirTopRightIcon.texture("images/gift-shop-icons/opera-house2.png");
			souvenirBottomLeftIcon.texture("images/gift-shop-icons/harbour-bridge2.png");
			souvenirBottomRightIcon.texture("images/gift-shop-icons/kangaroo2.png");
			souvenirMiddleIcon.texture("images/gift-shop-icons/manly-ferry.png");
			
			if(Game.currentGame.passport.SydneySouvenirs[0] == 1) {
				this.screen.getElement("souvenir1").getSprite().texture("images/passport-screen/t-left-frame-light.png");
				souvenirTopLeftIcon.texture("images/gift-shop-icons/koala.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[1] == 1) {
				this.screen.getElement("souvenir2").getSprite().texture("images/passport-screen/t-right-frame-light.png");
				souvenirTopRightIcon.texture("images/gift-shop-icons/opera-house.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[2] == 1) {
				this.screen.getElement("souvenir3").getSprite().texture("images/passport-screen/b-left-frame-light.png");
				souvenirBottomLeftIcon.texture("images/gift-shop-icons/harbour-bridge.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[3] == 1) {
				this.screen.getElement("souvenir4").getSprite().texture("images/passport-screen/b-right-frame-light.png");
				souvenirBottomRightIcon.texture("images/gift-shop-icons/kangaroo.png");
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[4] == 1) {
				this.screen.getElement("souvenir5").getSprite().texture("images/passport-screen/mid-frame-light.png");
				souvenirMiddleIcon.texture("images/gift-shop-icons/manly-ferry.png");
			}	
		}

		checkAchievements();
	}
	
	public function checkAchievements()
	{
	    var showModal = 0;
	    var catalogName = null;
		if(currentPage == "London") {
			if(Game.currentGame.passport.LondonSouvenirs[0] == 1 && Game.currentGame.passport.LondonSouvenirs[1] == 1 && Game.currentGame.passport.LondonSouvenirs[2] == 1 &&
					Game.currentGame.passport.LondonSouvenirs[3] == 1 && Game.currentGame.passport.LondonSouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[0] == "") {
					Game.sharedGame().passport.datesCompleted[0] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "London";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[0]);
			}
		}
		else if(currentPage == "SanFrancisco") {
			if(Game.currentGame.passport.SanFranciscoSouvenirs[0] == 1 && Game.currentGame.passport.SanFranciscoSouvenirs[1] == 1 && Game.currentGame.passport.SanFranciscoSouvenirs[2] == 1 &&
					Game.currentGame.passport.SanFranciscoSouvenirs[3] == 1 && Game.currentGame.passport.SanFranciscoSouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[1] == "") {
					Game.sharedGame().passport.datesCompleted[1] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "San Francisco";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[1]);
			}
		}
		else if(currentPage == "Paris") {
			if(Game.currentGame.passport.ParisSouvenirs[0] == 1 && Game.currentGame.passport.ParisSouvenirs[1] == 1 && Game.currentGame.passport.ParisSouvenirs[2] == 1 &&
					Game.currentGame.passport.ParisSouvenirs[3] == 1 && Game.currentGame.passport.ParisSouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[2] == "") {
					Game.sharedGame().passport.datesCompleted[2] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "Paris";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[2]);
			}
		}
		else if(currentPage == "BuenosAires") {
			if(Game.currentGame.passport.BuenosAiresSouvenirs[0] == 1 && Game.currentGame.passport.BuenosAiresSouvenirs[1] == 1 && Game.currentGame.passport.BuenosAiresSouvenirs[2] == 1 &&
					Game.currentGame.passport.BuenosAiresSouvenirs[3] == 1 && Game.currentGame.passport.BuenosAiresSouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[3] == "") {
					Game.sharedGame().passport.datesCompleted[3] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "Buenos Aires";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[3]);
			}
		}
		else if(currentPage == "Tokyo") {
			if(Game.currentGame.passport.TokyoSouvenirs[0] == 1 && Game.currentGame.passport.TokyoSouvenirs[1] == 1 && Game.currentGame.passport.TokyoSouvenirs[2] == 1 &&
					Game.currentGame.passport.TokyoSouvenirs[3] == 1 && Game.currentGame.passport.TokyoSouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[4] == "") {
					Game.sharedGame().passport.datesCompleted[4] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "Tokyo";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[4]);
			}
		}
		else if(currentPage == "Sydney") {
			if(Game.currentGame.passport.SydneySouvenirs[0] == 1 && Game.currentGame.passport.SydneySouvenirs[1] == 1 && Game.currentGame.passport.SydneySouvenirs[2] == 1 &&
					Game.currentGame.passport.SydneySouvenirs[3] == 1 && Game.currentGame.passport.SydneySouvenirs[4] == 1) {
				this.screen.getElement("achievementbadge").getSprite().visible(1);
				
				// check if not yet unlocked
				if(Game.sharedGame().passport.datesCompleted[5] == "") {
					Game.sharedGame().passport.datesCompleted[5] = Game.sharedGame().today;
					Game.sharedGame().passport.save();
					Game.sounds.playSFX("passportStamp");
					showModal = 1;
					catalogName = "Sydney";
				}
				
				this.stampCompletedDateLabel.text(Game.sharedGame().passport.datesCompleted[5]);
			}
		}
		
		if (showModal == 1) {
		    var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_UnlockCatalog, catalogName);
	        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
	        this.presentModalScreen(promptScreen);
		}
		
	}
	
	/*****************************************************************************
    Message Box Functions
	*****************************************************************************/
	
	function hreturnhome()
	{
		Game.sounds.stop();
		Game.sounds.addMusic("themeMusic", "sounds/Housewife.Theme.1.mp3");
		Game.sounds.playMusic("themeMusic");
		
		Game.popToRoot();
	}
}
