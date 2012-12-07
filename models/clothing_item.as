
class ClothingCatalog {
    var name;
    var image;
    var travelIndex;
    var categories;
    
    public function ClothingCatalog(catName, image, travelIndex)
    {
        this.name = catName;
        this.image = image;
        this.travelIndex = travelIndex;
        this.categories = dict();
    }
    
    public function addCategory(category)
    {
        category.catalog = this;
        this.categories.update(category.name, category);
    }
}

class ClothingCategory {
    var name;
    var clothingItems;
    var catalog;
    
    public function ClothingCategory(name)
    {
        this.name = name;
        this.clothingItems = new Array();
    }
    
    public function addClothingItem(clothingItem)
    {
        clothingItem.category = this;
        this.clothingItems.append(clothingItem);
    }
}

class ClothingItem {
    var id;
    var name;
    var image;
    var gameBucks;
    var diamonds;
    var stars;
    var points;
    var type;
    var category;
    var element;

    public function ClothingItem (id, name, image, gameBucks, diamonds, stars, points, type, element) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.gameBucks = gameBucks;
        this.diamonds = diamonds;
        this.stars = stars;
        this.points = points;
        this.type = type;
        this.element = element;
    }

    public function getCurrency() {
        if (this.diamonds == null || this.diamonds == 0) {
            return "GameBucks";
        }
        return "Diamonds";
    }

    public function getCurrencyImage() {
        if (this.diamonds == null || this.diamonds == 0) {
            return "game-buck-med.png";
        }
        return "diamonds-med.png";
    }

    public function getPrice() {
        if (this.diamonds == null || this.diamonds == 0) {
            return this.gameBucks;
        } else {
            return this.diamonds;
        }
    }

    public function getStar(num) {
        if (num<=this.stars) {
            return "full";
        }
        return "faded";
    }

    public function toString() {
        return str(this.id);
    }
}

class ClothingItemInstance {
    var id;
    var clothingItem;

    public function ClothingItemInstance (clothingItem) {
        this.clothingItem = clothingItem;
    }

    public function serialize()
    {
        var map = dict();
        map.update("id", this.id);
        map.update("clothingItemId", this.clothingItem.id);
        return map;
    }
}

class PurchasedClothingItems {
    var clothingItemInstances;
    var itemId;
    
    public function PurchasedClothingItems() {
        this.itemId = Game.getDatabase().get("lastClothingItemId");
        trace("ItemId: ", str(this.itemId));
        if (this.itemId == null) {
            this.itemId = 0;
        }
        this.load();
    }

    public function load() {
        this.clothingItemInstances = new Array();
        var serializedClothingItems = Game.getDatabase().get("purchasedClothingItems");
        trace("serialized clothing items: ", serializedClothingItems);
        if (serializedClothingItems != null) {
            var serializedItemKeys = serializedClothingItems.keys();
            for (var i=0; i<len(serializedItemKeys); i++ ) {
                var serializedClothingItem = serializedClothingItems.get(serializedItemKeys[i]);
                var clothingItemId = serializedClothingItem.get("clothingItemId");
                var clothingItemInstanceId = serializedClothingItem.get("id");
                
                var clothingItem = Game.sharedGame().getClothingItemById(clothingItemId);
                var clothingItemInstance = new ClothingItemInstance(clothingItem);
                clothingItemInstance.id = clothingItemInstanceId;
                this.clothingItemInstances.append(clothingItemInstance);
            }
        }
    }

    public function addClothingItem(clothingItem) {
        var clothingItemInstance = new ClothingItemInstance(clothingItem);
        clothingItemInstance.id = this.itemId;
        this.incrementAndSaveItemId();
        this.clothingItemInstances.append(clothingItemInstance);
        this.save();
    }

    public function save() {
        var serializedClothingItems = this.serialize();
        trace("saving clothing items: ", serializedClothingItems);
        Game.getDatabase().put("purchasedClothingItems", serializedClothingItems);
    }

    public function incrementAndSaveItemId() {
        this.itemId++;
        Game.getDatabase().put("lastClothingItemId", this.itemId);
    }

    public function serialize() {
        var serializedClothingItems = dict();
        for (var i=0; i< len(this.clothingItemInstances); i++) {
            var clothingItemInstance = this.clothingItemInstances[i];
            var serializedClothingItem = clothingItemInstance.serialize();
            trace("saving clothing item: ", serializedClothingItem);
            serializedClothingItems.update(clothingItemInstance.id, serializedClothingItem);
        }
        return serializedClothingItems;
    }

    public function getPurchasedClothingItemsMap() {
        var purchasedClothingItemsMap = dict();
        for (var i=0; i< len(this.clothingItemInstances); i++) {
            var clothingItem = this.clothingItemInstances[i].clothingItem;
            purchasedClothingItemsMap.update(clothingItem.id, 1);
        }
        return purchasedClothingItemsMap;
    }
}
