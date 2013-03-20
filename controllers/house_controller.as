/*****************************************************************************
filename    house_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

import framework.screen_controller
import framework.event

class HouseController extends ScreenController implements TimerListener
{
    var pointsShowing = 0;
    var cleanUpShowing;
    var selectedFloor = null;
    var selectedPaint = null;
    var currentItem = null;
    var house = null;
    var selectedFurniture = null;
    var selectedStorageFurniture = null;
    var sellItemId = -1;

    public function HouseController(controlledScreen, pHouse)
    {
        super(controlledScreen);
        this.house = pHouse;
    }

    override public function screenLoaded()
    {
        this.screen.buildStorageList(house.loadStorage());

        this.showPointsToCollect();
        this.showHouseNeedsCleanUp();
    }

    override public function showTutorial()
    {
        this.showMessageBox(MessageBoxScreen.MB_HouseTutorial);
    }

    override public function screenUnloaded()
    {
        Timer.unregisterListener("HousePointsTimer", this);
    }

    override public function eventFired(event)
    {
        super.eventFired(event);

        if(event.name == "categoryTapped") {
            Game.sounds.playSFX("buttonPress");
            this.categoryTapped(event.argument);
        }
        else if(event.name == "subcategoryTapped") {
            Game.sounds.playSFX("buttonPress");
            this.subcategoryTapped(event.argument);
        }
        else if(event.name == "furnitureTapped") {
            Game.sounds.playSFX("buttonPress");
            this.furnitureTapped(event.argument);
        }
        else if(event.name == "done") {
            Game.sounds.playSFX("buttonPress");

            Game.sounds.stop();
            Game.sounds.addMusic("themeMusic", "sounds/Housewife.Theme.1.mp3");
            Game.sounds.playMusic("themeMusic");

            Game.popScreen();
        }
        else if(event.name == "collectPoints") {
            this.collectPoints();
            Game.sounds.playSFX("reward");
        }
        else if(event.name == "cleanHouse") {
            Game.sounds.playSFX("cleanHouse");
            this.cleanHouse();
        }
        else if(event.name == "decorate") {
            Game.sounds.playSFX("buttonPress");
            this.startDecorator();
        }
        else if(event.name == "showStorage") {
            Game.sounds.playSFX("buttonPress");
            this.showStorage();
        }
        else if(event.name == "forSale") {
            Game.sounds.playSFX("buttonPress");
            this.forSale();
        }
        else if(event.name == "hideCategories") {
            Game.sounds.playSFX("buttonPress");
            this.stopDecorator();
        }
        else if(event.name == "hideStorage") {
            Game.sounds.playSFX("buttonPress");
            this.hideStorage();
        }
        else if(event.name == "storageTapped") {
            Game.sounds.playSFX("buttonPress");
            this.storageTapped(event.argument);
        }
        else if(event.name == "remodelPrompt") {
            Game.sounds.playSFX("buttonPress");
            this.promptForRemodel();
        }
        else if(event.name == "remodel") {
            this.doRemodel();
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "sellItem") {
        	this.sellItem(event.argument);
        }
        else if(event.name == "doNothing") {
        }
        else if(event.name == "showTutorialHelp") {
        	Game.hideBanner();
        	this.screen.getElement("tutorialPrompt").getSprite().visible(1);
        }
        else if(event.name == "hideTutorialHelp") {
        	this.screen.getElement("tutorialPrompt").getSprite().visible(0);
        	Game.showBanner(1, 0);
        } 
        else if (event.name == "displayMissions") {
            Game.sounds.playSFX("buttonPress");
            var db = Game.getDatabase();
            var missionId = db.get("lastMissionId");
            if (missionId == null) {
                missionId = 1;
            }
            var mission = Game.sharedGame().getMission(missionId);
            if (mission != null) {
                var missionsScreen = new MissionsScreen(mission);
                missionsScreen.configFile = "screen-cfgs/missions-screen-cfg.xml";
                this.presentModalScreen(missionsScreen);
            }
        }
        else if (event.name == "collectMission") {
            Game.sounds.playSFX("houseLevelUp");
            var database = Game.getDatabase();
            var lastMissionId = database.get("lastMissionId");
            if (lastMissionId == null) {
                lastMissionId = 1;
            }
            var lastMission = Game.sharedGame().getMission(lastMissionId);
            // collect
            if (lastMission != null) {
                var costGB = this.getGameBucks(lastMission.gameBucks);
                var costD = this.getDiamonds(lastMission.diamonds);
                Game.sharedGame().wallet.collect(costGB);
                Game.sharedGame().wallet.collect(costD);
                var wife = Game.sharedGame().wife;
                wife.incSocialStatusPoints(lastMission.ssp);
                wife.save();
                lastMissionId++;
                database.put("lastMissionId", lastMissionId);
            }
            this.dismissModalScreen();
        }
    }

    public function getGameBucks(amount)
    {
        return Game.sharedGame().wallet.moneyForCurrency(amount, "GameBucks");
    }

    public function getDiamonds(amount)
    {
        return Game.sharedGame().wallet.moneyForCurrency(amount, "Diamonds");
    }

    public function promptForRemodel()
    {
        var promptScreen;

        var remodel = this.house.nextRemodel();
        if(remodel != null) {
            promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_RemodelHousePrompt, remodel);
            promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
            this.presentModalScreen(promptScreen);
        }
        else {
            promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_CantUnlockRemodel);
            promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
            this.presentModalScreen(promptScreen);
        }
    }

    public function doRemodel()
    {
        var remodel = this.house.nextRemodel();

        var ret = Game.sharedGame().shop.buyHouseRemodel(remodel);
        if(ret == 1) {
            Game.sounds.playSFX("houseLevelUp");
            //ppy_postnewsfeed(Game.sharedGame().wife.name + " has remodeled their home.", "http://www.2clams.com", null);
            this.house.remodel();
            this.dismissModalScreen();
        }
        else {
            this.pushPremiumCurrencyScreen();
        }
    }

    public function pushPremiumCurrencyScreen() {
        var screen = new PremiumCurrencyScreen("viewDiamond");
        screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
        var controller = new PremiumCurrencyController(screen);
        Game.pushScreen(screen);
    }

    public function startDecorator()
    {
        this.showDecorator();
    }

    public function stopDecorator()
    {
        var map = this.screen.getElement("map");
        map.cancelAdding();

        this.hideDecorator();
    }

    public function showStorage()
    {
        this.stopDecorator();

        this.screen.showStorage();
    }

    public function hideStorage()
    {
        this.screen.hideStorage();
    }

    public function forSale()
    {
        var screen = new HouseSelectionScreen();
        screen.configFile = "screen-cfgs/house-selection-screen-cfg.xml";
        var controller = new HouseSelectionController(screen);
        Game.pushScreen(screen);
    }

    public function collectPoints()
    {
        this.pointsShowing = 0;

        this.screen.getElement("collectPoints").getSprite().visible(0);
        house.collectPoints();
    }

    public function showPointsToCollect()
    {
        if(this.pointsShowing == 1) return;

        var points = house.uncollectedPoints;
        if(points > 0) {
            this.screen.getElement("collectPoints").getSprite().visible(1);
            this.pointsShowing = 1;
        }
    }

    public function showHouseNeedsCleanUp()
    {
        if(house.needsCleaning() == 0) return;

        this.screen.getElement("cleanHouse").getSprite().visible(1);
    }

    public function cleanHouse()
    {
        house.clean();
        this.screen.getElement("cleanHouse").getSprite().visible(0);
    }

    public function timerFired(timer)
    {
        if(timer.name == "HousePointsTimer") {
            this.showPointsToCollect();
        }
    }

    public function categoryTapped(category)
    {
        var map = this.screen.getElement("map");
        map.cancelAdding();

        this.screen.buildSubcategories(category.subcategories);

        this.screen.showSubcategories();
    }

    public function subcategoryTapped(subcategory)
    {
        this.screen.buildFurnitureList(subcategory.furniture);

        this.screen.showItems();
    }

    public function furnitureTapped(furniture)
    {
        var map = this.screen.getElement("map");

        if(furniture.subcategory.name == "Paint" || furniture.subcategory.name == "Wallpaper") {
            this.selectedPaint = furniture;
        }
        else if(furniture.subcategory.name == "Floor") {
            this.selectedFloor = furniture;
        }
        else {
            this.selectedFurniture = furniture;
            Event.setHook(this, EVENT_TOUCH);
        }

        this.hideDecorator();
    }

    override public function hookFired(ev)
    {
        if(ev.name == "ontouch") {
            var event = this.screen.iso.translateEvent(ev);

            trace("hookFired: ", event, event.name, event.x, event.y, "-", ev.x, ev.y);

            var tilePos = this.screen.iso.tileFromPos(event.x, event.y);
            
            if(this.selectedFurniture) {
	            this.addSelectedFurniture(abs(tilePos[0]), abs(tilePos[1]));
            }
            else if(this.selectedStorageFurniture) {
            	this.storeFurniture(abs(tilePos[0]), abs(tilePos[1]));
            }

            Event.clearHook(this, EVENT_TOUCH);
            Event.setHook(this, EVENT_UNTOUCH);
        }
        else {
            Event.clearHook(this, EVENT_UNTOUCH);
        }

        return 1;
    }

    public function addSelectedFurniture(tileX, tileY)
    {
        trace("Add furniture to tile: ", tileX, tileY, this.selectedFurniture);

        if(this.selectedFurniture) {
            var centeredX = tileX + this.selectedFurniture.depth / 2;
            var centeredY = tileY + this.selectedFurniture.width / 2;

            trace("Add funriture centered: ", centeredX, centeredY, this.selectedFurniture.width, this.selectedFurniture.depth);

            var map = this.screen.getElement("map");
            var frnture = new IsometricItem("images/" + this.selectedFurniture.image, this.selectedFurniture.width, this.selectedFurniture.depth);

            if(map.testPlacement(frnture, centeredX, centeredY) == 1) {
                frnture.ref = new FurnitureItem(this.selectedFurniture, centeredX, centeredY, 0);
                map.newItem(frnture, centeredX, centeredY);
            }

            this.selectedFurniture = null;
        }
    }

    public function showDecorator()
    {
        this.screen.showDecorator();

        this.hideStorage();
    }

    public function hideDecorator()
    {
        this.screen.hideDecorator();
    }

    public function areaTapped(area)
    {
        if(this.selectedFloor != null) {
            if (area.row == null || area.col==null) {
                this.selectedFloor = null;
                return;
            }

            var furniture = this.selectedFloor;
            var ret = Game.sharedGame().shop.buyFurniture(furniture);
            if(ret == 1) {
                house.setCustomTiles(area, "custom-floor", this.selectedFloor);
                var map = this.screen.getElement("map");

                this.screen.setFloor(area, this.selectedFloor);
                this.selectedFloor = null;
            }
            else {
                this.pushPremiumCurrencyScreen();
            }
        }
    }

    public function itemTapped(item)
    {
        if(this.selectedPaint != null) {
            var area = item.tiles[0].area;
            trace("### HWW ### - Area:", area.serialize());
            if(area.type == "Paint") {
                var furniture = this.selectedPaint;

                var ret = Game.sharedGame().shop.buyFurniture(furniture);
                if(ret == 1) {
                    house.setCustomTiles(area, "custom-paint", this.selectedPaint);
                    this.screen.setPaint(area, this.selectedPaint);
                }
                else {
                    this.pushPremiumCurrencyScreen();
                }
            }

            this.selectedPaint = null;
        }
    }

    public function itemAccepted(item)
    {
        var furniture = item.ref.furnitureType;

        trace("Item accepted: ", furniture.gameBucks, furniture.diamonds);

        var ret = Game.sharedGame().shop.buyFurniture(furniture);
        if(ret == 1) {
            Game.sounds.playSFX("reward");
            Game.sharedGame().wife.incSocialStatusPoints(furniture.points);
            this.house.putFurniture(item.ref);
            item.hideAcceptButton();
        }
        else {
            var map = this.screen.getElement("map");
            map.removeItem(item);

            var screen = new PremiumCurrencyScreen("viewGameBucks");
            screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
            var controller = new PremiumCurrencyController(screen);
            Game.pushScreen(screen);
        }
    }

    public function itemRemoved(item)
    {
        house.removeFurniture(item.ref);
    }

    public function itemMoved(item, x, y)
    {
        trace("Item moved: ", x, y);

        item.ref.left = x;
        item.ref.top = y;
        house.updateFurniture(item.ref);
    }

    public function itemFlipped(item)
    {
        trace("### flipping furniture ### - ", item.ref);
        house.flipFurniture(item.ref);
    }

    public function moveItemToStorage(item)
    {
        house.removeFurniture(item.ref);
        house.storeFurniture(item.ref);

        this.screen.buildStorageList(house.loadStorage());

        var map = this.screen.getElement("map");
        map.removeItem(item);
    }

    public function storageTapped(item)
    {
        this.selectedStorageFurniture = item;
        Event.setHook(this, EVENT_TOUCH);

        this.hideStorage();
    }
    
    public function storeFurniture(tileX, tileY)
    {
        if(this.selectedStorageFurniture) {
        	var item = this.selectedStorageFurniture;
        	var furniture = item.furnitureType;
        	
        	var centeredX = tileX;
            var centeredY = tileY;
        	if (furniture != null) {
        	    centeredX = tileX + furniture.depth / 2;
        	    centeredY = tileY + furniture.width / 2;
        	}

            trace("Furniture: ", furniture.name, " id: ", furniture.id);
            trace("Add storage funriture centered: ", centeredX, centeredY, furniture.width, furniture.depth);

            var map = this.screen.getElement("map");
            var frnture = new IsometricItem("images/" + furniture.image, furniture.width, furniture.depth);
            frnture.ref = item;

            if(map.testPlacement(frnture, centeredX, centeredY) == 1) {
                map.newItem(frnture, centeredX, centeredY);
        		map.addingItem = null;

                frnture.hideAcceptButton();

                house.unstoreFurniture(item);

                this.screen.buildStorageList(house.loadStorage());
            }

            this.selectedStorageFurniture = null;
        }
    }
    
    public function sellItem(itemId)
    {    	
    	this.sellItemId = int(itemId);
    	var item = this.house.storage.get(this.sellItemId);

		var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_SellFurniture, item);
		promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
		promptScreen.okCallBack = this.itemSold;
		promptScreen.cancelCallBack = this.cancelItemSell;
		
		this.presentModalScreen(promptScreen);
    }
    
    public function itemSold()
    {
    	var item = this.house.storage.get(this.sellItemId);    	
    	trace("itemSold: ", this.sellItem, item);
    	
    	this.house.sellFurniture(item);
        this.screen.buildStorageList(this.house.loadStorage());
    	
    	this.sellItemId = -1;
    }
    
    public function cancelItemSell()
    {
    	this.sellItemId = -1;
    }
}
