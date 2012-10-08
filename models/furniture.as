/*****************************************************************************
filename    furniture.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   furniture model classes
*****************************************************************************/

class FurnitureCategory
{
    var name;
    var image;
    var breadCrumb;
    var subcategories;
    
    public function FurnitureCategory(catName, image, breadCrumb)
    {
        this.name = catName;
        this.image = image;
        this.breadCrumb = breadCrumb;
        this.subcategories = new Array();
    }
    
    public function addSubcategory(subCat)
    {
        subCat.category = this;
        this.subcategories.append(subCat);
    }
}

class FurnitureSubcategory
{
    var name;
    var image;
    var furniture;
    var category;
    
    public function FurnitureSubcategory(subCatName, image)
    {
        this.name = subCatName;
        this.image = image;
        this.furniture = new Array();
    }
    
    public function addFurniture(furnit)
    {
        furnit.subcategory = this;
        this.furniture.append(furnit);
    }
}

class Furniture
{
    var id;
    var name;
    var image;
    var level;
    var width;
    var depth;
    var subcategory;
    var gameBucks;
    var diamonds;
    var stars;
    var points;
    var remodelRequirement;
    
    public function Furniture(id, name, image, width, depth, level, gameBucks, diamonds, stars, points, remodelRequirement)
    {
        this.id = id;
        this.name = name;
        this.image = image;
        this.width = width;
        this.depth = depth;
        this.level = level;
        this.gameBucks = gameBucks;
        this.diamonds = diamonds;
        this.stars = stars;
        this.points = points;
        this.remodelRequirement = remodelRequirement;
    }

    public function toString() {
        return str(this.id) + "-" + this.name;
    }
}

class FurnitureItem
{
    var itemId;
    var furnitureType;
    var left;
    var top;
    var isFlipped;
    
    public function FurnitureItem(furniture, left, top, flipped)
    {
        this.itemId = null;
        this.furnitureType = furniture;
        this.left = left;
        this.top = top;
        this.isFlipped = flipped;
    }

    public function getId()
    {
        return this.itemId;
    }

    public static function deserialize(serializedItem)
    {
        var itemId = serializedItem.get("itemId");
        var furnitureTypeId = serializedItem.get("furnitureType");
        var furnitureType = Game.sharedGame().getFurniture(str(furnitureTypeId));
        var left = serializedItem.get("left");
        var top = serializedItem.get("top");
        var isFlipped = serializedItem.get("isFlipped");
        var furnitureItem = new FurnitureItem(furnitureType, left, top, isFlipped);
        furnitureItem.itemId = itemId;

        return furnitureItem; 
    }

    public function serialize()
    {
        var map = dict();
        map.update("itemId", this.itemId);
        map.update("furnitureType", str(this.furnitureType.id));
        map.update("left", this.left);
        map.update("top", this.top);
        map.update("isFlipped", this.isFlipped);
        return map; 
    }

}