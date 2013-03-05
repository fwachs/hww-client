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
		
		this.screen.loadDestination(currentPage);
		
		stampCompletedDateLabel = this.screen.getElement("achievementbadge").getSprite().addlabel(Game.sharedGame().today, Game.getFont(), Game.translateFontSize(24));
		stampCompletedDateLabel.pos(Game.translateX(100), Game.translateY( 140));
		stampCompletedDateLabel.color(0,0,0);
		
		this.checkAchievements();
		
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
