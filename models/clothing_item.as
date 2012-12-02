
class ClothingCatalog {
    var name;
    var categories;
    
    public function ClothingCatalog(catName)
    {
        this.name = catName;
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
    var rarity;
    var type;
    var category;
    var element;

    public function ClothingItem (id, name, image, gameBucks, diamonds, stars, points, rarity, type, element) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.gameBucks = gameBucks;
        this.diamonds = diamonds;
        this.stars = stars;
        this.points = points;
        this.rarity = rarity;
        this.type = type;
        this.element = element;
    }

    public function getCurrency() {
        if (this.diamonds == null || this.diamonds == 0) {
            return "GameBucks";
        }
        return "Diamonds";
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
        this.id = getLatestFreeId();
    }

    public function incrementAndSaveItemId() {
        this.id++;
        Game.getDatabase().put("clothingItemInstanceId", this.id);
    }

    public function getLatestFreeId () {
        var latestId = Game.getDatabase().get("clothingItemInstanceId");
        trace("Clothing Item Instance Id: ", str(latestId));
        if (latestId == null) {
            latestId = 0;
        }
        latestId++;
        return latestId;
    }

    public function save() {
        var serializedClothingItem = this.serialize();
        this.incrementAndSaveItemId();
        return 
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
    
    public function PurchasedClothingItems() {
        this.load();
    }

    public function load() {
        this.clothingItemInstances = new Array();
        var serializedClothingItems = Game.getDatabase().get("purchasedClothingItems");
        if (serializedClothingItems != null) {
            for (var i=0; i<len(serializedClothingItems); i++ ) { 
                // TODO: deserialize objects and put them on the clothing item instances array
            }
        }
    }

    public function addClothingItem(clothingItemInstance) {
        this.clothingItemInstances.append(clothingItemInstance);
        this.save();
    }

    public function save() {
        var serializedClothingItems = this.serialize();
        Game.getDatabase().put("purchasedClothingItems", serializedClothingItems);
    }

    public function serialize() {
        var serializedClothingItems = dict();
        for (var i=0; i< len(this.clothingItemInstances); i++) {
            var clothingItemInstance = this.clothingItemInstances[i];
            var serializedClothingItem = clothingItemInstance.serialize();
            serializedClothingItems.update(clothingItemInstance.id, serializedClothingItem);
        }
        return serializedClothingItems;
    }
}
