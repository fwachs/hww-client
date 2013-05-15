/*****************************************************************************
filename    howsewifewars.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   main game class
*****************************************************************************/

import framework.game

import screens.darkside_screen
import controllers.darkside_controller

import screens.hud_screen
import controllers.hud_controller

import screens.wife_selection_screen
import controllers.wife_selection_controller

import screens.main_screen
import controllers.main_controller

import models.wife

//import framework.timer
import models.mission
import models.furniture
import models.house
import models.husband
import models.darkside
import models.currency
import models.passport
import models.papaya_friend
import models.realestate
import models.mystery_item
import models.shop
import models.achievement
import models.clothing_item

class HousewifeWars extends Game
{
	var wife;
	var house;
	var wallet;
	var hubby;
	var darkSide;
	var milesEarnedTimer;
	var passport;
	var cities;
	var mysteryItems;
	var gifts = null;
	var realestate;
	var unlockedAchievements;
	var timersMap;
	var furnitures = null;
	var furnitureListing;
	var husbandMainMenuScreenMessages;
    var husbandHusbandScreenMessages;
    var furnitureCategories = null;
    var shop = null;
    var achievements;
    var purchasedClothingItems;
    var clothingItems = null;
    var missions = null;
	var clothingCatalogs;

	public function HousewifeWars()
	{
		super();
	}

	override public function run()
	{
		var screen;
		var controller;
		
		this.loadGifts();

		this.furnitureCategories = this.getFurnitureCategories();
		this.wife = new Wife();
		this.wife.cleanUnfinishedRegistration();
		this.hubby = new Husband();
		this.darkSide = new DarkSide();
		this.house = new House();
		this.wallet = new Wallet();
		this.shop = new Shop();
		this.milesEarnedTimer = new earnMilesTimer();
		this.passport = new Passport();
		this.realestate = new Realestate();
		this.purchasedClothingItems = new PurchasedClothingItems();
		this.loadCities();
		this.loadPlayerAchievements();
		this.loadMysteryItems();
		this.loadGifts();
		this.loadHusbandMessages();
		this.loadSounds();
		this.house.loadFurniture();
		this.loadAchievements();
		this.loadClothingItems();
		this.loadMissions();
		
		var hud = new HUDScreen();
		hud.configFile = "screen-cfgs/hud-screen-cfg.xml";
		var hudcontroller = new HUDController(hud);		
		Game.setBanner(hud, 1280);

		Buffs.startBuffs();

//		this.checkForUnlockedAchievements();


		if(wife.firstPlay == 1)
		{
			var startingGameBucks = Game.currentGame.wallet.moneyForCurrency(1000, "GameBucks");
			var returnValue = Game.currentGame.wallet.collect(startingGameBucks);
			
			var startingDiamonds = Game.currentGame.wallet.moneyForCurrency(15, "Diamonds");

			returnValue = Game.currentGame.wallet.collect(startingDiamonds);

			var startingMiles = Game.currentGame.wallet.moneyForCurrency(20000, "Miles");
            returnValue = Game.currentGame.wallet.collect(startingMiles);
			
			screen = new WifeSelectionScreen();
			screen.configFile = "screen-cfgs/wife-selection-screen-cfg.xml";
			controller = new WifeSelectionController(screen);
		}
		else
		{
			Game.sounds.stop();
			Game.sounds.playMusic("themeMusic");
			
			screen = new MainScreen();
			screen.configFile = "screen-cfgs/main-screen-cfg.xml";
			controller = new MainController(screen);

			c_addtimer(60000, this.updateServer, null, 0, -1);
		}

		this.milesEarnedTimer.start();
		Game.pushScreen(screen);
		
		enable_payments();

//        c_addtimer(60000, this.updateLeaderboards, null, 0, -1);
	}
	
	public function checkForUnlockedAchievements()
	{
	    this.wife.checkAchievements();
	    this.hubby.checkAchievements();
	    this.house.checkAchievements();
	    this.passport.checkAchievements();
		
		ppy_listachievements(syncPapayaAccountAchievements, null);
	}
	
	public function syncPapayaAccountAchievements(id, ret, content, param)
	{
		var achievementList = content.get("data");
		trace(str(achievementList));
		
		for(var i = 0; i < len(achievementList); ++i) {
			var unlocked =  achievementList[i].get("unlock");
			
			if(unlocked == 1) {
				unlockAchievement(achievementList[i].get("title"));
			}
		}
	}
	
	public function updateServer () {
	    Game.getServer().synchronizeGame();
	    save();
	}
	
	public function loadSounds()
	{
		Game.sounds.addMusic("themeMusic", "sounds/Housewife.Theme.1.mp3");
		Game.sounds.addMusic("darkSideMusic", "sounds/Housewife.darkside.mp3");
		
		Game.sounds.addSound("houseLevelUp", "sounds/HousewifeSFX.Achievement2.mp3");
		Game.sounds.addSound("cleanHouse", "sounds/HousewifeSFX.Clean1.mp3");
		Game.sounds.addSound("hubbyReturnHome", "sounds/HousewifeSFX.ComeHome1.mp3");
		Game.sounds.addSound("buttonPress", "sounds/HousewifeSFX.FunctionButton1.mp3");
		Game.sounds.addSound("generalCollection", "sounds/HousewifeSFX.GeneralCollecting1.mp3");
		Game.sounds.addSound("hubbyHappy", "sounds/HousewifeSFX.HusbandHappy2.mp3");
		Game.sounds.addSound("hubbyLevelUp", "sounds/HousewifeSFX.LevelUp1.mp3");
		Game.sounds.addSound("notify", "sounds/HousewifeSFX.Notification1.mp3");
		Game.sounds.addSound("reward", "sounds/HousewifeSFX.Reward1.mp3");
		Game.sounds.addSound("sabotageGift", "sounds/HousewifeSFX.Sabotage1.mp3");
		Game.sounds.addSound("gainSSP", "sounds/HousewifeSFX.SocialPoint1.mp3");
		Game.sounds.addSound("passportStamp", "sounds/HousewifeSFX.Stamp2.mp3");
		Game.sounds.addSound("unlockItem", "sounds/HousewifeSFX.UnlockItem1.mp3");
		Game.sounds.addSound("spinWheel", "sounds/HousewifeSFX.Wheel2.mp3");
		Game.sounds.addSound("openSafe", "sounds/HousewifeSFX.Vault1.mp3");
	}

	public function rateReward()
	{
		var rateKey = "rate" + Game.getPapayaUserId();
		var db = Game.getDatabase();
		var hasRated = db.get(rateKey); 
		if (hasRated == null) {
			var rewardMoney = Game.currentGame.wallet.moneyForCurrency(5, "Diamonds");
			this.wallet.collect(rewardMoney);
			db.put(rateKey, "true");
		}
	}

	public function loadCities()
	{
		var xmldict = parsexml("game-config/house_styles.xml", 1);
		var xmlcities = xmldict.get("hww-config:travel-cities").get("#children");		
				
		this.cities = dict();
		
		for(var i = 0; i < len(xmlcities); i++) {
			var xmlcity = xmlcities[i].get("hww-config:travel-city");
			var cityattrs = xmlcity.get("#attributes");
			
			var city = new City();
			city.name = cityattrs.get("name");
			city.price = cityattrs.get("price");
			city.currency = cityattrs.get("currency");
			
			this.cities.update(city.name, city);
		}		
	}
	
	public function loadMysteryItems()
	{
		var xmldict = parsexml("game-config/mystery_items.xml", 1);
		var xmlmysteryitems = xmldict.get("hww-config:mystery-items").get("#children");
		this.mysteryItems = new dict();

		for(var i = 0; i < len(xmlmysteryitems); i++) {
			var xmlmysteryitem = xmlmysteryitems[i].get("hww-config:mystery-item");
			var mysteryitemattrs = xmlmysteryitem.get("#attributes");
			trace("Mystery items attributes: ", str(mysteryitemattrs));
			var mysteryItem = new MysteryItem(mysteryitemattrs.get("id"), mysteryitemattrs.get("name"), mysteryitemattrs.get("desc"), mysteryitemattrs.get("fileName"),
									int(mysteryitemattrs.get("stars")), int(mysteryitemattrs.get("points")), mysteryitemattrs.get("reward"), mysteryitemattrs.get("currency"));
			
			this.mysteryItems.update(mysteryItem.id, mysteryItem);
		}		
		trace("loaded mystery items: ", str(this.mysteryItems));
	}

	public function getCities()
	{
		if (cities == null) {
			this.loadCities();
		}
		return cities;
	}

	public function getAchievementByName (Name) {
	    if (this.achievements == null) {
	        this.loadAchievements();
	    }
	    return this.achievements.get(Name);
	}

	public function loadAchievements()
	{
		var xmldict = parsexml("game-config/ppy_achievements.xml", 1);
		var xmlachievements = xmldict.get("hww-config:ppy-achievements").get("#children");		
				
		this.achievements = dict();
		
		for(var i = 0; i < len(xmlachievements); i++) {
			var xmlachievement = xmlachievements[i].get("hww-config:ppy-achievement");
			var achievementattrs = xmlachievement.get("#attributes");
			
			var achievement = new Achievement(int(achievementattrs.get("iosID")), int(achievementattrs.get("androidID")), achievementattrs.get("name"));		
			this.achievements.update(achievement.name, achievement);
		}		
	}


	public function unlockAchievement(Name)
	{
	    
	    var achievement = Game.sharedGame().getAchievementByName(Name);
	    var achievementID;
	    
	    // check if we are using an Android device
	    if(getmodel() == 6) {
	        achievementID = achievement.androidID;
	        this.unlockedAchievements[achievementID - 2526] = 1;
	    }
	    else {
	        achievementID = achievement.iosID;
	        this.unlockedAchievements[achievementID - 2329] = 1;
	    }
	    
	    ppy_unlockachievement(achievementID, null);
	    this.saveAchievements();
	}

	public function loadGifts()
	{
		var xmldict = parsexml("game-config/gifts.xml", 1);
		var xmlGifts = xmldict.get("hww-config:gifts").get("#children");		
				
		this.gifts = dict();
		
		for(var i = 0; i < len(xmlGifts); i++) {
			var xmlGift = xmlGifts[i].get("hww-config:gift");
			var giftAttrs = xmlGift.get("#attributes");
			
			var gift = GiftItem.newGiftFromAttributes(giftAttrs);
			this.gifts.update(gift.id, gift);
		}		
	}

	public function checkForReceivedGifts()
	{
		Game.getServer().getGifts(this.saveGiftsCallback);
	}

	public function saveGiftsCallback(request_id, ret_code, response_content)
	{
		if(ret_code == 0) return;
		
		trace("Response: ", str(response_content));
		var response = json_loads(response_content);
		var gifts = response.get("gifts");
		var storedGifts = Game.getDatabase().get("storedGifts");
		if (storedGifts == null) {
			storedGifts = new Array();
		}
		for (var i=0;i<len(gifts);i++) {
			storedGifts.append(gifts[i]);
		}
		Game.getDatabase().put("storedGifts", storedGifts);
		
		var rewards = response.get("rewards");
		var storedRewards = Game.getDatabase().get("storedRewards");
        if (storedRewards == null) {
            storedRewards = new Array();
        }
        for (var j=0;j<len(rewards);j++) {
            storedRewards.append(rewards[j]);
        }
        Game.getDatabase().put("storedRewards", storedRewards);
		
	}

	public function getGift(giftId)
	{
		return this.gifts.get(giftId);
	}
	public function getGifts()
	{
		return gifts.values();
	}

	override public function save()
	{
		this.saveWife();
		this.saveHusband();
		this.saveWallet();
		this.saveRealestate();
		this.passport.save();
		this.saveAchievements();
	}

	public function saveHusband()
	{
		this.hubby.save();
	}

	public function saveWife()
	{
		this.wife.save();
	}

	public function saveWallet()
	{
		this.wallet.save();
	}
	
	public function saveRealestate()
	{
		this.realestate.save();
	}
	
	public function loadPlayerAchievements()
	{
	   var papayaUserId = Game.getPapayaUserId();
	   var achievementMap = Game.getDatabase().get("achievements" + Game.getPapayaUserId());
	   trace("### HWW ### - Fetched Achievements from DB: ", str(achievementMap));

	   if (achievementMap == null)
	   {
	       this.unlockedAchievements = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	       this.checkForUnlockedAchievements();

	       return;
	   }

	   this.unlockedAchievements = achievementMap.get("propertyListing");
	}

	public function loadAchievementsFromJSON(achievementMap)
	{
	   this.unlockedAchievements = achievementMap.get("unlockedAchievements");
	}

	public function saveAchievements()
	{
		if (this.unlockedAchievements == null) {
		       this.unlockedAchievements = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		       this.checkForUnlockedAchievements();
		   }
		
	   var papayaUserId = Game.getPapayaUserId();
	   var serializedAchievements = this.serializeAchievements();
	   trace("### HWW ### - Saving Achievements:", str(serializedAchievements));
	   Game.getDatabase().put("achievements" + Game.getPapayaUserId(), serializedAchievements);
	}

	public function serializeAchievements()
	{
	   var papayaUserId = Game.getPapayaUserId();
	   var achievementsArray = [];
	   achievementsArray.append(["id", papayaUserId]);
	   achievementsArray.append(["unlockedAchievements", unlockedAchievements]);

	   return dict(achievementsArray);
	}

	public function updateLeaderboards()
	{
		ppy_setscore(this.wife.socialStatusPoints, "housewifewarsSSP01");
		ppy_setscore(this.hubby.careerLevel, "housewifewarsHCL01");
	}

	public function getFurniture(furnitureId)
	{
		if (this.furnitures == null) {
			this.getFurnitureCategories();
		}
		return this.furnitures.get(furnitureId);
	}

	public function getFurnitureCategories()
	{
		var furnitures = dict();
		var categories = new Array();
		this.furnitureListing = new Array();
		var xmldict = parsexml("game-config/furniture.xml", 1);
		var xmlFurnitures = xmldict.get("hww-config:furnitures").get("#children");		
				
		for(var i = 0; i < len(xmlFurnitures); i++) {
			var xmlCategory = xmlFurnitures[i].get("hww-config:furniture-category");
			var catAttrs = xmlCategory.get("#attributes");
			
			var category = new FurnitureCategory(catAttrs.get("name"), catAttrs.get("image"));

			var xmlSubCategories = xmlCategory.get("#children");
			for(var j = 0; j < len(xmlSubCategories); j++) {
				var xmlSubCat = xmlSubCategories[j].get("hww-config:furniture-sub-category");
				var subCatAttrs = xmlSubCat.get("#attributes");
				var subCategory = new FurnitureSubcategory(subCatAttrs.get("name"), subCatAttrs.get("image"));
				
				var xmlFurnitureItems = xmlSubCat.get("#children");
				for (var k = 0; k < len(xmlFurnitureItems); k++) {
					var xmlFurniture = xmlFurnitureItems[k].get("hww-config:furniture");
					var furnitureAttrs = xmlFurniture.get("#attributes");
					var furniture = new Furniture(furnitureAttrs.get("id"), furnitureAttrs.get("name"), furnitureAttrs.get("image"),
						 int(furnitureAttrs.get("width")), int(furnitureAttrs.get("depth")), int(furnitureAttrs.get("level")), int(furnitureAttrs.get("gameBucks")), 
						 int(furnitureAttrs.get("diamonds")), int(furnitureAttrs.get("stars")), int(furnitureAttrs.get("points")), int(furnitureAttrs.get("remodelRequirement")));
					furnitures.update(furniture.id, furniture);
					this.furnitureListing.append(furniture);
					subCategory.addFurniture(furniture);
				}
				category.addSubcategory(subCategory);
			}
			categories.append(category);
		}

		this.furnitures = furnitures;
		
		return categories;
	}

	public function getClothingItemById(clothingItemId) {
	    if (this.clothingItems == null) { 
	        this.loadClothingItems();
	    }
	    return this.clothingItems.get(clothingItemId);
	}

	public function loadMissions () {
	    var missions = new Array();
	    var xmldict = parsexml("game-config/missions.xml", 1);
	    if (xmldict == null) {
	        return;
	    }
	    var xmlMissions = xmldict.get("hww-config:missions").get("#children");
	    for(var i = 0; i < len(xmlMissions); i++) {
	        var xmlMission = xmlMissions[i].get("hww-config:mission");
            var missionAttrs = xmlMission.get("#attributes");
            var mission = new Mission(missionAttrs.get("id"), missionAttrs.get("name"), missionAttrs.get("type"), 
                    int(missionAttrs.get("ssp")), int(missionAttrs.get("gameBucks")), int(missionAttrs.get("diamonds")), missionAttrs.get("image"));

            var xmlMissionTasks = xmlMission.get("#children");
            for (var k = 0; k < len(xmlMissionTasks); k++) {
                var xmlMissionTask = xmlMissionTasks[k].get("hww-config:task");
                var missionTaskAttrs = xmlMissionTask.get("#attributes");
                var missionTask = null;
                if (mission.type == "furniture" || mission.type == "purchase") {
                    missionTask = new MissionTask(missionTaskAttrs.get("itemId"), missionTaskAttrs.get("name"), int(missionTaskAttrs.get("amount")));
                } else {
                    missionTask = new RemodelMissionTask(missionTaskAttrs.get("name"), int(missionTaskAttrs.get("level")));
                }
                mission.addTask(missionTask);
            }
            missions.append(mission);
	    }
	    this.missions = missions;
	}

	public function getMission (missionId) {
	    return this.missions[missionId-1];
	}

	public function loadClothingItems()
    {
        this.clothingItems = dict();
        var catalogs = dict();
        var xmldict = parsexml("game-config/clothing-items.xml", 1);
        var xmlClothingItems = xmldict.get("hww-config:clothing-items").get("#children");      
                
        for(var i = 0; i < len(xmlClothingItems); i++) {
            var xmlCatalog = xmlClothingItems[i].get("hww-config:clothing-catalog");
            var catalogAttrs = xmlCatalog.get("#attributes");
            
            var catalog = new ClothingCatalog(catalogAttrs.get("name"), catalogAttrs.get("image"), int(catalogAttrs.get("travelIndex")));

            var xmlCategories = xmlCatalog.get("#children");
            for(var j = 0; j < len(xmlCategories); j++) {
                var xmlCat = xmlCategories[j].get("hww-config:clothing-category");
                var catAttrs = xmlCat.get("#attributes");
                var category = new ClothingCategory(catAttrs.get("name"));

                var xmlClothingItemChildren = xmlCat.get("#children");
                for (var k = 0; k < len(xmlClothingItemChildren); k++) {
                    var xmlClothingItem = xmlClothingItemChildren[k].get("hww-config:clothing-item");
                    var clothingAttrs = xmlClothingItem.get("#attributes");
                    var clothingItem = new ClothingItem(clothingAttrs.get("id"), clothingAttrs.get("name"), clothingAttrs.get("image"),
                         int(clothingAttrs.get("gameBucks")), int(clothingAttrs.get("diamonds")), int(clothingAttrs.get("stars")),
                         int(clothingAttrs.get("points")), clothingAttrs.get("type"), clothingAttrs.get("element"), clothingAttrs.get("sleeves"));
                    clothingItems.update(clothingItem.id, clothingItem);
                    category.addClothingItem(clothingItem);
                }
                catalog.addCategory(category);
            }
            catalogs.update(catalog.name, catalog);
        }

        this.clothingCatalogs = catalogs;
    }

	public function getCatalog(name) {
	    return this.clothingCatalogs.get(name);
	}

    public function loadHusbandMessages()
    {
        this.husbandMainMenuScreenMessages = new Array();
        this.husbandHusbandScreenMessages = new Array();
        var xmldict = parsexml("game-config/husband_messages.xml", 1);
        
        var blutiles = xmldict.get("hww-config:husband-messages").get("#children");      
        for(var i = 0; i < len(blutiles); i++) {
            var xmlt = blutiles[i].get("hww-config:message");
            var tileattrs = xmlt.get("#attributes");

            if (tileattrs.get("screen") == "main-menu") {
                this.husbandMainMenuScreenMessages.append(tileattrs.get("text"));
            } else {
                this.husbandHusbandScreenMessages.append(tileattrs.get("text"));
            }
        }
    }

    public function getRandomMessage(screenName) {
        var message = null;
        var messagesCount = null;
        if (screenName == "main-menu") {
            messagesCount = len(this.husbandMainMenuScreenMessages);
            message = this.husbandMainMenuScreenMessages[rand(messagesCount-1)];
        } else {
            messagesCount = len(this.husbandHusbandScreenMessages);
            message = this.husbandHusbandScreenMessages[rand(messagesCount-1)];
        }
        return message;
    }
}

/*****************************************************************************
    Timers
*****************************************************************************/

class earnMilesTimer extends Timer
{
	public function earnMilesTimer()
	{
		super("earnMilesTimer", 60, -1);
	}
	
	override public function tick()
	{
	    var wife = Game.sharedGame().wife;
	    var ssp = wife.calculateFashionPoints();
	    wife.incSocialStatusPoints(ssp);
		var milesEarned = Game.currentGame.wallet.moneyForCurrency(100, "Miles");
		var ret = Game.currentGame.wallet.collect(milesEarned);
	}	
}

/*
export("onpause",onpause);
function onpause()
{
	trace("### HWW ### - Pausing game.");
	Game.sounds.pause();
	Game.sharedGame().save();
	Game.trackEvent("Session", "paused", "", 10);
}

export("onresume",onresume);
function onresume()
{
	trace("### HWW ### - Resuming game.");
	Game.sounds.resume();
	Game.trackEvent("Session", "resumed", "", 10);
}

var theGame = new HousewifeWars();
Game.currentGame = theGame;
Game.start();
*/


