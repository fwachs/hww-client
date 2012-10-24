/*****************************************************************************
filename    house.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   house model class
*****************************************************************************/

//import framework.timer

class TilesGroup
{
    var row;
    var col;
    var height;
    var width;
    var type;
    var room;
    var furniture;
    
    public function copy()
    {
        var newCopy = new TilesGroup();
        newCopy.row = this.row;
        newCopy.col = this.col;
        newCopy.height = this.height;
        newCopy.type = this.type;
        newCopy.furniture = this.furniture;
        
        return newCopy;
    }

    public function getId()
    {
        return str(this.row) + str(this.col);
    }

    public function serialize()
    {
        var map = dict();
        map.update("id", str(row) + str(col));
        map.update("row", this.row);
        map.update("col", this.col);
        map.update("height", this.height);
        map.update("type", this.type);
        map.update("furnitureId", this.furniture.id);
        return map; 
    }

    public static function deserialize(customTile)
    {
        var tilesGroup = new TilesGroup();
        tilesGroup.row = customTile.get("row");
        tilesGroup.col = customTile.get("col");
        tilesGroup.height = customTile.get("height");
        tilesGroup.type = customTile.get("type");
        var furniture = Game.sharedGame().getFurniture(customTile.get("furnitureId"));
        tilesGroup.furniture = furniture;
        return tilesGroup;
    }
}

class Room
{
    var name;
    var level;
    var tiles;
    
    public function Room()
    {
        this.tiles = new Array();
    }
}

class Style
{
    var name;
    var description
    var items;
    
    public function Style()
    {
        this.items = dict();
    }
}

class StyleItem
{
    var resource;
    var width;
    var depth;
    var floor;
    var flip;
}

class Remodel
{
    var id;
    var diamonds;
    var rewardTime;
    var cleanReward;
    var garbageTime;
    var unlockLevel;

    public function toString() {
        return str(id);
    }
}

class House
{
    var furniture;
    var uncollectedPoints;
    var points;
    var pointsTimer;
    var isDirty;
    var cleaningTimer;
    var storage;
    var rows;
    var cols;
    var rooms;
    var styles;
    var selectedStyle;
    var itemId;
    var customTiles;
    var level;
    var remodels;
    var blueprint;
    var mustDraw = 1;
    
    public function House()
    {
        this.furniture = null;
        this.storage = new dict();
        this.customTiles = new dict();
        this.blueprint = new dict();
        
        this.pointsTimer = new HousePointsTimer();
        this.pointsTimer.start();

        this.cleaningTimer = new HouseCleaningTimer();
        this.cleaningTimer.start();
        
        this.uncollectedPoints = 0;
        
        this.itemId = Game.getDatabase().get("lastItemId");
        trace("ItemId: ", str(this.itemId));
        if (this.itemId == null) {
            this.itemId = 0;
        }
        
        this.load();
        this.loadBlueprint();
        this.loadRemodels();
        this.loadMap();
        this.loadStyles();
        
        var styleId = Game.getDatabase().get("houseStyle");
        if (styleId == null) {
            styleId = "brick-yellow";
        }
        this.selectedStyle = this.styles.get(styleId);
    }
    
    public function getLevel()
    {
        return this.level;
    }
    
    public function currentRemodel()
    {
        var remodel = this.remodels[this.getLevel()];
        
        return remodel;
    }
    
    public function nextRemodel()
    {               
        if(this.getLevel() + 1 > len(this.remodels)) return null;

        var remodel = this.remodels[this.getLevel() + 1];   
        if(remodel.unlockLevel <= Game.sharedGame().hubby.careerLevel) {
            return remodel;
        }
        
        return null;
    }
    
    public function remodel()
    {
        var remodel = this.nextRemodel();       
        if(remodel != null) {           
            this.level++;
            this.save();
        }
            
        this.checkAchievements();
    }
        
    public function checkAchievements()
    {
        if(this.level >= 2)
            Game.sharedGame().unlockAchievement("DIY");
        if(this.level >= 5)
            Game.sharedGame().unlockAchievement("Interior Designer");
        if(this.level >= 10)
            Game.sharedGame().unlockAchievement("Real Estate Mogul");
    }

    public function setSelectedStyle(styleId) 
    {
        this.selectedStyle = this.styles.get(styleId);
        Game.getDatabase().put("houseStyle", styleId);
        
        this.mustDraw = 1;
    }
    
    public function wasDrawn()
    {
        this.mustDraw = 0;
    }
    
    public function shouldDraw()
    {
    	return this.mustDraw;
    }
    
    public function load() 
    {
        var houseMap = Game.getDatabase().get("house" + Game.getPapayaUserId());
        if (houseMap == null) {
            this.level = 1;
            this.isDirty = 0;
            return;
        }

        this.level = houseMap.get("level");
        this.isDirty = houseMap.get("isDirty");
    }

    public function save()
    {
        Game.getDatabase().put("house" + Game.getPapayaUserId(), dict([["level", this.level], ["isDirty", this.isDirty]]));
    }
    
    public function saveFromJSON(jsonHouse) {
        var selectedStyleId = jsonHouse.get("type");
        var level = jsonHouse.get("level");

        this.setSelectedStyle(selectedStyleId);
        if (this.selectedStyle == null) {
            this.setSelectedStyle("brick-yellow");
        }
        if (level == null) {
            level = 1;
        }
        this.level = level;
        this.itemId = jsonHouse.get("itemId");
        if (this.itemId == null || this.itemId == 0) {
            this.itemId = 1000;
        }
        Game.getDatabase().put("lastItemId", this.itemId);
        this.save();

        var customTiles = jsonHouse.get("customTiles");
        for (var i=0; i<len(customTiles); i++) {
            var tg = TilesGroup.deserialize(customTiles[i]);
            this.saveTilesGroup(tg);
        }

        var furnitures = jsonHouse.get("furnitures");
        for (var j=0; j<len(furnitures); j++) {
            var furnitureItem = FurnitureItem.deserialize(furnitures[j]);
            this.saveFurniture(furnitureItem);
        }

        var storage = jsonHouse.get("storage");
        for (var k=0; k<len(storage); k++) {
            var storageItem = FurnitureItem.deserialize(storage[k]);
            this.saveStorageItem(storageItem);
        }
    }

    public function loadBlueprint()
    {
        var xmldict = parsexml("game-config/blueprint-layout.xml", 1);
        
        var blutiles = xmldict.get("hww-config:blueprint-tiles").get("#children");      
        for(var i = 0; i < len(blutiles); i++) {
            var xmlt = blutiles[i].get("hww-config:tile");
            var tileattrs = xmlt.get("#attributes");

            this.blueprint.update(tileattrs.get("row") + "_" + tileattrs.get("col"), tileattrs.get("asset"));
        }       
    }
    
    public function loadMap()
    {
        var xmldict = parsexml("game-config/house_map.xml", 1);
        
        var houses = xmldict.get("hww-config:house-maps").get("#children");     
        var house = houses[0].get("hww-config:house");
        
        var houseAttrs = house.get("#attributes");
        this.rows = int(houseAttrs.get("rows"));
        this.cols = int(houseAttrs.get("cols"));
        
        this.rooms = new Array();
        
        var xmlrooms = house.get("#children");
        for(var i = 0; i < len(xmlrooms); i++) {
            var xmlr = xmlrooms[i].get("hww-config:room");
            var roomattrs = xmlr.get("#attributes");
            
            var room = new Room();
            room.name = roomattrs.get("name");
            room.level = int(roomattrs.get("level"));           
            
            var xmltileGroups = xmlr.get("#children");
            for(var j = 0; j < len(xmltileGroups); j++) {
                var xmltg = xmltileGroups[j].get("hww-config:room-tiles");
                var xmlGroup = xmltg.get("#attributes");
            
                var tileGroup = new TilesGroup();
                tileGroup.col = int(xmlGroup.get("row"));
                tileGroup.row = int(xmlGroup.get("col"));
                tileGroup.width = int(xmlGroup.get("height"));
                tileGroup.height = int(xmlGroup.get("width"));
                tileGroup.type = xmlGroup.get("type");
                tileGroup.room = room;
                
                room.tiles.append(tileGroup);
            }
            
            this.rooms.append(room);
        }       
    }
    
    public function loadStyles()
    {
        var xmldict = parsexml("game-config/house_styles.xml", 1);
        var xmlstyles = xmldict.get("hww-config:house-styles").get("#children");        
                
        this.styles = dict();
        
        for(var i = 0; i < len(xmlstyles); i++) {
            var xmlstyle = xmlstyles[i].get("hww-config:house-style");
            var styleattrs = xmlstyle.get("#attributes");
            
            var style = new Style();
            style.name = styleattrs.get("name");
            style.description = styleattrs.get("description");
            
            var xmlstyleItems = xmlstyle.get("#children");
            for(var j = 0; j < len(xmlstyleItems); j++) {
                var xlst = xmlstyleItems[j].get("hww-config:style-item");
                var xmlItem = xlst.get("#attributes");
                
                var stItem = new StyleItem();
                stItem.resource = xmlItem.get("resource");
                stItem.width = int(xmlItem.get("width"));
                stItem.depth = int(xmlItem.get("depth"));
                
                if(xmlItem.get("floor")) {
                    stItem.floor = 1;
                }
                else {
                    stItem.floor = 0;
                }

                if(xmlItem.get("flip")) {
                    stItem.flip = 1;
                }
                else {
                    stItem.flip = 0;
                }
                                
                style.items.update(xmlItem.get("type"), stItem);
            }
            
            this.styles.update(style.name, style);
        }       
    }
    
    public function loadRemodels()
    {
        var xmldict = parsexml("game-config/remodels.xml", 1);
        var xmlstyles = xmldict.get("hww-config:house-remodels").get("#children");      
                
        this.remodels = new Array();
        this.remodels.append(new Remodel());
        
        for(var i = 0; i < len(xmlstyles); i++) {
            var xmlremodel = xmlstyles[i].get("hww-config:remodel");
            var remodelattrs = xmlremodel.get("#attributes");
            
            var remodel = new Remodel();
            remodel.id = int(remodelattrs.get("remodel"));
            remodel.diamonds = int(remodelattrs.get("diamonds"));
            remodel.rewardTime = int(remodelattrs.get("rewardTime"));
            remodel.cleanReward = int(remodelattrs.get("cleanReward"));
            remodel.garbageTime = int(remodelattrs.get("garbageTime"));
            remodel.unlockLevel = int(remodelattrs.get("unlockLevel"));
                        
            this.remodels.append(remodel);
        }
        
        trace("*** REMODELS");
        for(i = 0; i < len(this.remodels); i++) {
            trace("***** REMODEL: ", i, this.remodels[i].id, this.remodels[i].unlockLevel);
        }
    }
    
    public function putFurniture(item)
    {
        trace("Putting Item: ", str(item.getId()));
        if (item.itemId == null) {
            this.incrementAndSaveItemId();
            item.itemId = this.itemId;
            trace("### HWW ### - FurnitureId", str(this.itemId));
        }
        
        this.furniture.update(item.getId(), item);
        this.saveFurniture(item);
    }
    
    public function updateFurniture(item)
    {
        trace("Updating Item: ", str(item.serialize()));
        if (item.getId() == null) {
            return;
        }
        
        this.furniture.update(item.getId(), item);
        this.saveFurniture(item);
    }
    
    public function storeFurniture(item)
    {
        this.storage.update(item.getId(), item);
        this.removeFurniture(item);
        this.saveStorageItem(item); 
    }
    
    public function unstoreFurniture(item)
    {
    	this.removeFromStorage(item);
        this.putFurniture(item);
    }
    
    public function removeFromStorage(item)
    {
        this.storage.pop(item.getId());
        this.deleteStorageItem(item);
    }

    public function deleteStorageItem(storageItem)
    {
        var key = "storage-" + Game.getPapayaUserId();

        var savedStorageItems = Game.getDatabase().get(key);
        if (savedStorageItems == null) {
            savedStorageItems = dict();
        }
        trace("Deleting Item - ", str(storageItem.getId()));
        var deletedObject = savedStorageItems.pop(storageItem.getId());
        trace("Deleting Item - ", str(deletedObject));
        Game.getDatabase().put(key, savedStorageItems);
    }

    public function removeFurniture(item)
    {
        this.furniture.pop(item.getId());
        this.deleteFurniture(item);
    }
    
    public function sellFurniture(item)
    {
    	this.removeFromStorage(item);
    	
		var furniture = item.furnitureType;
		var price = furniture.gameBucks / 10;
		
		var payment = Game.sharedGame().wallet.moneyForCurrency(price, "GameBucks");
		var ret = Game.sharedGame().wallet.collect(payment);
    }
    
    public function flipFurniture(item)
    {
        if(item.isFlipped == 0) {
            item.isFlipped = 1;
        }
        else {
            item.isFlipped = 0;
        }
        this.updateFurniture(item);
    }
    
    public function setCustomTiles(tilesGroup, type, furniture)
    {
        var tilesId = str(tilesGroup.row) + str(tilesGroup.col);        
        var tg = this.customTiles.get(tilesId);
        
        if(tg == null) {
            tg = tilesGroup.copy();
            this.customTiles.update(tilesId, tg);
        }

        tg.type = type;
        tg.furniture = furniture;
        this.saveTilesGroup(tg);
    }

    public function loadCustomTiles()
    {
        var papayaUserId = Game.getPapayaUserId();
        var key = "customTiles-" + Game.getPapayaUserId();

        var savedCustomTiles = Game.getDatabase().get(key);
        if (savedCustomTiles == null) {
            this.customTiles = dict();
            return;
        }

        var customTiles = dict();
        var savedCustomTilesArray = savedCustomTiles.values();
        for (var i=0; i < len(savedCustomTilesArray); i++) {
            var tg = TilesGroup.deserialize(savedCustomTilesArray[i]);
            customTiles.update(tg.getId(), tg);
        }
        this.customTiles = customTiles;
    }

    public function saveTilesGroup(tg)
    {
        var papayaUserId = Game.getPapayaUserId();
        var key = "customTiles-" + Game.getPapayaUserId();

        var customTiles = Game.getDatabase().get(key);
        if (customTiles == null) {
            customTiles = dict();
        }
        customTiles.update(tg.getId(), tg.serialize());
        Game.getDatabase().put(key, customTiles);
    }

    public function serializeCustomTiles()
    {
        var serializedCustomTiles = new Array();
        var customTilesArray = this.customTiles.values();
        for (var i=0; i<len(customTilesArray); i++) {
            var customTile = customTilesArray[i];
            serializedCustomTiles.append(customTile.serialize());
        }
        return serializedCustomTiles;
    }

    public function pointsIncrement()
    {       
    	var furniturePoints = calculateFurniturePlacedPoints();
    	var customTilePoints = calculateCustomTilesPoints();
    	
    	var totalPoints = furniturePoints + customTilePoints;
    	
    	if(totalPoints > 0) {
    		return totalPoints;
    	}
    	else {
    		// receive at least 1 point
            return 1;
    	}
    }
    
    public function calculateFurniturePlacedPoints()
    {
    	var keys = new Array();
        keys = this.furniture.keys();
        var length = len(keys);
        
        var result = 0;
        
        for(var count = 0; count < length; ++count) {
            var item = this.furniture.get(keys[count]);
            result += item.furnitureType.points;
        }
        
        trace("### HWW ### - Total furniture points: " + str(result));
    	
    	return result;
    }
    
    public function calculateCustomTilesPoints()
    {
    	var keys = new Array();
        keys = this.customTiles.keys();
        var length = len(keys);
    	
        var result = 0;
        
        for(var count = 0; count < length; ++count) {
            var tg = this.customTiles.get(keys[count]);
            result += tg.furniture.points;
        }
        
        trace("### HWW ### - Total custom tile points: " + str(result));
    	
    	return result;
    }
    
    public function addPoints()
    {
        this.uncollectedPoints = this.pointsIncrement();
    }
    
    public function collectPoints()
    {
        Game.sharedGame().wife.incSocialStatusPoints(this.uncollectedPoints);
        this.uncollectedPoints = 0;     
        this.pointsTimer.restart();
        this.pointsTimer.changeRunningTime(this.currentRemodel().rewardTime);

        trace("House points collected ", this.points);
    }
    
    public function setDirty()
    {
        this.isDirty = 1;
    }
    
    public function needsCleaning()
    {
        return this.isDirty;
    }
    
    public function clean()
    {
        this.isDirty = 0;
        this.cleaningTimer.restart();
        this.cleaningTimer.changeRunningTime(this.currentRemodel().garbageTime);
        
        var payment = Game.currentGame.wallet.moneyForCurrency(this.currentRemodel().cleanReward, "GameBucks");
        var ret = Game.currentGame.wallet.collect(payment);     
    }
    
    public function visit()
    {
        this.cleaningTimer.restart();
    }
    
    public function loadStorage()
    {
        var key = "storage-" + Game.getPapayaUserId();
        
        var serializedStorage = Game.getDatabase().get(key);
        if (serializedStorage == null) {
            this.storage = dict();
            return this.storage.values();
        }

        var storage = dict();
        var serializedStorageArray = serializedStorage.values();
        for (var i=0; i<len(serializedStorageArray); i++) {
            var furnitureItem = FurnitureItem.deserialize(serializedStorageArray[i]);
            storage.update(furnitureItem.getId(), furnitureItem);
        }
        this.storage = storage;
        return this.storage.values();
    }

    public function loadFurniture()
    {
        if(this.furniture == null) {
            var key = "furnitures-" + Game.getPapayaUserId();
            
            var savedFurnitures = Game.getDatabase().get(key);
            if (savedFurnitures == null) {
                this.furniture = dict();
                return this.furniture.values();
            }
            
            trace("Load furnitures: ", savedFurnitures);
    
            var furniture = dict();
            var savedFurnituresArray = savedFurnitures.values();
            for (var i=0; i < len(savedFurnituresArray); i++) {
                if(savedFurnituresArray[i]) {
                    var furnitureItem = FurnitureItem.deserialize(savedFurnituresArray[i]);
                    furniture.update(furnitureItem.getId(), furnitureItem);
                }
            }
            this.furniture = furniture;
        }
        
        return this.furniture.values();
    }

    public function deleteFurniture(furniture)
    {
        var key = "furnitures-" + Game.getPapayaUserId();

        var savedFurnitures = Game.getDatabase().get(key);
        if (savedFurnitures == null) {
            savedFurnitures = dict();
        }
        savedFurnitures.pop(furniture.getId());
        Game.getDatabase().put(key, savedFurnitures);
    }

    public function saveFurniture(furniture)
    {
        var key = "furnitures-" + Game.getPapayaUserId();

        var savedFurnitures = Game.getDatabase().get(key);
        if (savedFurnitures == null) {
            savedFurnitures = dict();
        }
        savedFurnitures.update(furniture.getId(), furniture.serialize());
        trace("Saved furnitures: ", savedFurnitures);
        Game.getDatabase().put(key, savedFurnitures);
    }

    public function saveNewStorageItem(furniture)
    {
        this.incrementAndSaveItemId();
        var furnitureItem = new FurnitureItem(furniture, 0, 0, 0);
        furnitureItem.itemId = this.itemId;
        this.saveStorageItem(furnitureItem);
        trace("### HWW ### - FurnitureId", str(this.itemId));
    }

    public function incrementAndSaveItemId() {
        this.itemId++;
        Game.getDatabase().put("lastItemId", this.itemId);
    }

    public function saveStorageItem(storageItem)
    {
        var key = "storage-" + Game.getPapayaUserId();

        var savedStorageItems = Game.getDatabase().get(key);
        if (savedStorageItems == null) {
            savedStorageItems = dict();
        }
        savedStorageItems.update(storageItem.getId(), storageItem.serialize());
        Game.getDatabase().put(key, savedStorageItems);
    }

    public function serialize()
    {
        var houseMap = dict();

        houseMap.update("papayaUserId", Game.getPapayaUserId());
        houseMap.update("furnitures", this.serializeFurniture());
        houseMap.update("storage", this.serializeStorage());
        houseMap.update("customTiles", this.serializeCustomTiles());
        houseMap.update("level", this.level);
        houseMap.update("type", this.selectedStyle.name);
        houseMap.update("itemId", this.itemId);
        return houseMap;
    }

    public function serializeStorage()
    {
        var serializedStorage = new Array();
        var storageArray = this.storage.values();
        for (var i=0; i<len(storageArray); i++) {
            var furnitureItem = storageArray[i];
            trace("furnitureItem to serialize: ", furnitureItem);
            serializedStorage.append(furnitureItem.serialize());
        }
        return serializedStorage;
    }

    public function serializeFurniture()
    {
        var furnitureArray = this.furniture.values();
        var furnitures = new Array();
        for (var i = 0; i< len(furnitureArray); i++) {
            var furnitureItem = furnitureArray[i];
            furnitures.append(furnitureItem.serialize());
        }
        return furnitures;
    }
    
    public function isEditable()
    {
        return 1;
    }
}

class OtherPlayerHouse extends House
{
    public function OtherPlayerHouse()
    {
        super();
    }

    override public function loadFurniture()
    {
        return this.furniture.values();
    }

    override public function loadStorage()
    {
        return this.storage.values();
    }

    override public function loadCustomTiles()
    {
    }

    override public function isEditable()
    {
        return 0;
    }

    override public function setSelectedStyle(styleId) 
    {
        this.selectedStyle = this.styles.get(styleId);
    }
}

class HousePointsTimer extends Timer
{
    public function HousePointsTimer()
    {
        super("HousePointsTimer", 4 * 60, 1);
    }
    
    override public function tick()
    {
        Game.currentGame.house.addPoints();
    }
}

class HouseCleaningTimer extends Timer
{
    public function HouseCleaningTimer()
    {
        super("HouseCleaningTimer", 4 * 3600, 1);
    }
    
    override public function tick()
    {
        Game.currentGame.house.setDirty();
    }
}
