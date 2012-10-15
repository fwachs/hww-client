/*****************************************************************************
filename    game.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     Papaya-Engine 2clams framework

Brief Description:
   Handles entry point and screen management
*****************************************************************************/

import framework.server
import framework.font
import framework.sounds
import framework.animations

class Game
{
    static var db;
	static var screens;
	static var scene;
	static var currentGame;
	static var server;
	static var font;
	static var bannerScreen = null;
	static var sounds;
	static var animations;
	static var screenScale = 50;
	static var papayaUserId = 0;
	var loadingScreen;
	var loadingBar;
	var loadingBarStart;
	var loadingProgress;
	var loadingBarEnd;
	var loadingText;
	var today;
	var properties;

	public static function getPapayaUserId()
	{
	    return str(papayaUserId);
	}

	public static function sharedGame()
	{
		return Game.currentGame;
	}

    public static function getDatabase()
    {	
    	if (Game.db == null) {
    		Game.initializeDatabase();
    	}
        return Game.db;
    }

	public static function getServer()
	{
		if (Game.server == null) {
    		Game.initializeServer();
    	}
		return Game.server;
	}
	
	public static function audioOn()
	{
	    if (Game.getDatabase().get("soundOn") != null) {
	        return Game.getDatabase().get("soundOn");
	    }
	    Game.getDatabase().put("soundOn", 1);
		return 1;
	}
	
	public static function trackEvent(category, action, label, value)
	{
		ppy_tracker_event(category, action, label, value);
		
		trace("** TRACK EVENT:", category, action, label, value);
	}

	function showLoadingScreen()
	{
		Game.sounds.addMusic("splashMusic", "sounds/Housewife.Splash.1b.mp3");
		Game.sounds.playMusic("splashMusic");
		this.loadingScreen = Game.scene.addsprite("images/2clams-splash.png").pos(Game.translateX(0), Game.translateY( 0));
		c_invoke(transitionLoadingScreen, 2000, null);
	}
	
	function transitionLoadingScreen()
	{
		this.loadingScreen.texture("images/LoadScreen.png");
		this.loadingBar = Game.scene.addsprite("images/tutorial-icons/loadingbar-base.png").pos(Game.translateX(325), Game.translateY( 722));
		this.loadingBarStart = loadingBar.addsprite("images/tutorial-icons/loadingbar-front.png").pos(Game.translateX(0), Game.translateY( 0));
		this.loadingProgress = loadingBar.addsprite("images/tutorial-icons/loadingbar-repeat.png").pos(Game.translateX(20), Game.translateY( 0));
		this.loadingBarEnd = loadingBar.addsprite("images/tutorial-icons/loadingbar-end.png").pos(Game.translateX(577), Game.translateY( 0));
		this.loadingText = this.loadingBar.addsprite("images/tutorial-icons/loading001.png");
		this.loadingBarEnd.visible(0);
		this.loadingProgress.size(Game.translateX(557), Game.translateY( 42));
		this.loadingProgress.scale(0, 100);
		
		Game.screens = new Array();
		this.animations = new Animations();
        Game.initializeServer();
        Game.papayaUserId = ppy_userid();
        trace("### HWW ### - PapayaUserId: ", str(Game.papayaUserId));
        if (Game.papayaUserId == null || Game.papayaUserId == 0 || !ppy_connected()) {
            quitgame();
        }
        var wife = new Wife();
        var shouldSynchronize = Game.getProperty("onGoingSynchronization");
        if (wife.firstPlay == 1 || shouldSynchronize == 1) {
            Game.getServer().synchronize(synchronizeCallback);
        } else {
            c_invoke(loading1, 1, null);
        }
	}

	public function synchronizeCallback(request_id, ret_code, response_content) {
        if (ret_code == 1) {
            this.setProperty("onGoingSynchronization", 1);
            var responseMap = json_loads(response_content);
            var jsonWife = responseMap.get("wife");
            if (jsonWife != null) {
                var wife = new Wife();
                trace("### HWWW ### Synchronize Wife Response: ", jsonWife);
                wife.loadFromJSON(jsonWife);
                wife.save();

                var husband = new Husband();
                var jsonHusband = responseMap.get("husband");
                trace("### HWWW ### Synchronize Husband Response: ", jsonHusband);
                husband.loadFromJSON(jsonHusband);
                husband.save();

                var wallet = new Wallet();
                var jsonWallet = responseMap.get("wallet");
                trace("### HWWW ### Synchronize Wallet Response: ", jsonWallet);
                wallet.saveFromJSON(jsonWallet);

                var jsonPassport = responseMap.get("passport");
                if (jsonPassport != null) {
                    var passport = new Passport();
                    passport.saveFromJSON(jsonPassport);
                }

                var house = new House();
                var jsonHouse = responseMap.get("house");
                trace("### HWWW ### Synchronize House Response: ", jsonHouse);
                house.saveFromJSON(jsonHouse);
            }
            this.setProperty("onGoingSynchronization", 0);
        }
        c_invoke(loading1, 1, null);
    }

	function loading1()
	{
		this.loadingProgress.scale(25, 100);
		this.loadingText.texture("images/tutorial-icons/loading002.png");
		c_invoke(loading2, 1000, null);
	}
	
	function loading2()
	{
		this.loadingProgress.scale(50, 100);
		this.loadingText.texture("images/tutorial-icons/loading003.png");
		c_invoke(loading3, 1000, null);
	}
	
	function loading3()
	{
		this.loadingProgress.scale(75, 100);
		this.loadingText.texture("images/tutorial-icons/loading004.png");
		c_invoke(loading4, 1000, null);
	}
	
	function loading4()
	{
		this.loadingText.texture("images/tutorial-icons/loading005.png");
		this.loadingProgress.scale(100, 100);
		this.getServer().getCurrentDateAndTick(this.initializeTimers);
		this.loadingBarEnd.visible(1);
		
	}
	
	function hideLoadingScreen(timer, tick, param)
	{
		this.scene.remove(this.loadingScreen);
		this.scene.remove(this.loadingBar);	
		this.scene.remove(this.loadingBarStart);
		this.scene.remove(this.loadingBarEnd);
		this.scene.remove(this.loadingText);
	}
	
	public static function translateX(xPos)
	{		
		var translatedX = xPos * Game.screenScale / 100;
		
		return translatedX;
	}
	
	public static function translateY(yPos)
	{
		var translatedY = yPos * Game.screenScale / 100;
		
		return translatedY;
	}
	
	public static function translateFontSize(fontSize)
	{
		var translatedSize = fontSize * Game.screenScale / 100;
		
		return translatedSize;
	}
		
	public static function untranslate(value)
	{
		return value * 100 / Game.screenScale;
	}
	
	public function Game()
	{
		Game.initializeDatabase();
		this.loadProperties();
		
		Game.scene = getscene();
		v_scale(Game.translateX(1280), Game.translateY(800));
		this.font = new Font();
		this.sounds = new Sounds();
		this.showLoadingScreen();

		Game.trackEvent("Session", "begin", "", 10);
	}
	
	// starting point for subclasses, must be overriden
	public function run()
	{
	}

	public function start()
	{
	}

	public function initializeTimers(request_id, ret_code, response_content)
	{
		if(ret_code == 1) {
			var response = json_loads(response_content);
			var currentTick = response.get("currentTick");
			var currentDay = response.get("currentDay");
			this.today = currentDay;
			trace("### HWW ### - Today ", currentDay, " CurrentTick: ", str(currentTick));
		}
		else {
			this.today = "";
		}
		
		this.hideLoadingScreen();

		Game.sharedGame().run();

		Timer.startTimers();
	}

    public function initializeServer()
    {
        server = new Server();
    }

    public function initializeDatabase()
    {   
    	trace("Before initializeDatabase");
        db = c_opendb(0, "hww");
    	trace("After initializeDatabase: ", db);
    }
    
    public function cleanDatabase()
    {
        Game.db.destroy();
    	Game.db = null;
    	Game.initializeDatabase();
    }

	public function quit()
	{
		quitgame();
	}
	
	static public function currentScreen()
	{
		return Game.lastScreen();
	}
	
	static public function lastScreen()
	{
		return Game.screens[len(Game.screens) - 1];
	}
	
	static public function pushScreen(screenToPush)
	{
		var scrSize = screensize();		
		var newCanvas = Game.scene.addsprite().size(scrSize).pos(Game.translateX(1280), 0);
		screenToPush.canvas = newCanvas;

		var lastScreen = Game.lastScreen();

		Game.screens.append(screenToPush);
		
		if(len(Game.screens) > 1) {
			lastScreen.willLoseFocus();
			lastScreen.lostFocus();
			lastScreen.canvas.addaction(moveto(250, Game.translateX( -1280), Game.translateY( 0)));
			screenToPush.canvas.addaction(moveto(250, Game.translateX( 0), Game.translateY( 0)));
			screenToPush.create();
		}
		else {
			screenToPush.canvas.pos(Game.translateX(0), Game.translateY( 0));
			screenToPush.create();
		}
		
		screenToPush.controller.screenLoaded();
		screenToPush.gotFocus();
		screenToPush.willGetFocus();
		screenToPush.controller.screenPostLoaded();
	}
	
	static public function popToRoot()
	{
		while(Game.lastScreen().isRoot == 0) {
			Game.sharedGame().popScreen();		
		}
		Game.lastScreen().gotFocus();
	}
	
	public function popScreen()
	{
		var screenToPop = Game.screens.pop();
		screenToPop.lostFocus();
		screenToPop.willLoseFocus();
		
		var lastScreen = Game.lastScreen();
		lastScreen.gotFocus();
		lastScreen.willGetFocus();
		
//		screenToPop.canvas.addaction(moveto(250, Game.translateX( 1280), Game.translateY( 0)));
//		lastScreen.canvas.addaction(moveto(250, Game.translateX( 0), Game.translateY( 0)));
		lastScreen.canvas.pos(Game.translateX(0), Game.translateY( 0));
		
		screenToPop.destroy();
		this.scene.remove(screenToPop.canvas);
		screenToPop.controller.screenUnloaded();
	}
	
	static public function setBanner(banner, bannerHeight)
	{
		if(Game.bannerScreen != null) {
			Game.scene.remove(Game.bannerScreen.canvas);
		}
	
		Game.bannerScreen = banner;
		
		var newCanvas = Game.scene.addsprite().size(Game.translateX(screensize()[0]), Game.translateY( bannerHeight)).pos(Game.translateX(0), Game.translateY( -bannerHeight));
		Game.bannerScreen.canvas = newCanvas;
		Game.bannerScreen.create();
		Game.bannerScreen.controller.screenLoaded();
	}

	static public function showBanner(top, bottom)
	{		
//		Game.bannerScreen.canvas.addaction(moveto(250, Game.translateX( 0), Game.translateY( 0)));
		Game.bannerScreen.canvas.pos(Game.translateX(0), Game.translateY( 0));
		
		Game.bannerScreen.getElement("hudFrameTop").getSprite().visible(top);
		Game.bannerScreen.getElement("hudFrameBottom").getSprite().visible(bottom);
		
		Game.bannerScreen.gotFocus();
		Game.bannerScreen.canvas.bringtofront();
	}
	
	public function hideBanner()
	{
//		Game.bannerScreen.canvas.addaction(moveto(250, Game.translateX( -Game.bannerScreen.canvas.size(Game.translateX()[0])), Game.translateY( Game.translateY( 0))));
		
		Game.bannerScreen.gotFocus();
		Game.bannerScreen.canvas.bringtoback();
		Game.bannerScreen.getElement("hudFrameTop").getSprite().visible(0);
		Game.bannerScreen.getElement("hudFrameBottom").getSprite().visible(0);
	}
	
	public function startButtonShineAnimation()
	{
		var buttonShineAnimation = Game.bannerScreen.getElement("buttonShineAnimation").getSprite();
		buttonShineAnimation.visible(1);
		var action = Game.animations.getAnimation("button_shine");
		buttonShineAnimation.stop();
		buttonShineAnimation.addaction(repeat(action));
		
		buttonShineAnimation.addaction(repeat(delaytime(832),callfunc(Game.buttonShineUpdateFunction)));
		trace("### HWW ### - " + Game.currentScreen().getScreenName());
	}
	
	public function buttonShineUpdateFunction()
	{
		var buttonShineAnimation = Game.bannerScreen.getElement("buttonShineAnimation").getSprite();
		var location;
		
		trace("### HWW ### - " + Game.currentScreen().getScreenName());
		
		if(Game.currentScreen().getScreenName() == "main-screen") {
			location = rand(12, 5) + 1;
			
			if(location == 1) {
				buttonShineAnimation.pos(Game.translateX(158), Game.translateY(650));
			}
			else if(location == 2) {
				buttonShineAnimation.pos(Game.translateX(262), Game.translateY(741));
			}
			else if(location == 3) {
				buttonShineAnimation.pos(Game.translateX(345), Game.translateY(708));
			}
			else if(location == 4) {
				buttonShineAnimation.pos(Game.translateX(503), Game.translateY(684));
			}
			else if(location == 5) {
				buttonShineAnimation.pos(Game.translateX(573), Game.translateY(681));
			}
			else if(location == 6) {
				buttonShineAnimation.pos(Game.translateX(286), Game.translateY(6));
			}
			else if(location == 7) {
				buttonShineAnimation.pos(Game.translateX(582), Game.translateY(6));
			}
			else if(location == 8) {
				buttonShineAnimation.pos(Game.translateX(869), Game.translateY(6));
			}
			else if(location == 9) {
				buttonShineAnimation.pos(Game.translateX(1156), Game.translateY(6));
			}
			else if(location == 10) {
				buttonShineAnimation.pos(Game.translateX(1169), Game.translateY(698));
			}
			else if(location == 11) {
				buttonShineAnimation.pos(Game.translateX(1165), Game.translateY(487));
			}
			else if(location == 12) {
				buttonShineAnimation.pos(Game.translateX(1168), Game.translateY(329 ));
			}
		}
		else if(Game.currentScreen().getScreenName() == "husband-screen") {
			location = rand(13, 5) + 1;
			
			if(location == 1) {
				buttonShineAnimation.pos(Game.translateX(158), Game.translateY(650));
			}
			else if(location == 2) {
				buttonShineAnimation.pos(Game.translateX(262), Game.translateY(741));
			}
			else if(location == 3) {
				buttonShineAnimation.pos(Game.translateX(345), Game.translateY(708));
			}
			else if(location == 4) {
				buttonShineAnimation.pos(Game.translateX(503), Game.translateY(684));
			}
			else if(location == 5) {
				buttonShineAnimation.pos(Game.translateX(573), Game.translateY(681));
			}
			else if(location == 6) {
				buttonShineAnimation.pos(Game.translateX(286), Game.translateY(6));
			}
			else if(location == 7) {
				buttonShineAnimation.pos(Game.translateX(582), Game.translateY(6));
			}
			else if(location == 8) {
				buttonShineAnimation.pos(Game.translateX(869), Game.translateY(6));
			}
			else if(location == 9) {
				buttonShineAnimation.pos(Game.translateX(1156), Game.translateY(6));
			}
			else if(location == 10) {
				buttonShineAnimation.pos(Game.translateX(944), Game.translateY(944));
			}
			else if(location == 11) {
				buttonShineAnimation.pos(Game.translateX(1146), Game.translateY(360));
			}
			else if(location == 12) {
				buttonShineAnimation.pos(Game.translateX(1074), Game.translateY(280));
			}
			else if(location == 13) {
				buttonShineAnimation.pos(Game.translateX(1074), Game.translateY(430));
			}
		}
		else {
			// shouldn't be on any other screen.
		}
	}
	
	public function stopButtonShineAnimation()
	{
		Game.bannerScreen.getElement("buttonShineAnimation").getSprite().stop();
		Game.bannerScreen.getElement("buttonShineAnimation").getSprite().visible(0);
		trace("### HWW ### - " + Game.currentScreen().getScreenName());
	}

	public function loadProperties()
	{
        this.properties = Game.getDatabase().get("game_properties");
        if(this.properties == null)  {
        	this.properties = dict();
        }
	}

    public function saveProperties()
    {
        Game.getDatabase().put("game_properties", this.properties);
    }
    
    public function setProperty(key, value)
    {
    	this.properties.update(key, value);
    	this.saveProperties();
    }
    
    public function getProperty(key)
    {
    	return this.properties.get(key);
    }
}
