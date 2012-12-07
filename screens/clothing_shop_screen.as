/*****************************************************************************
filename    hud_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class ClothingShopScreen extends Screen
{
	public function ClothingShopScreen()
	{
		super();		
	}
	
	override public function build()
	{
	    Game.sharedGame().wife.showNaked(this);
	}

	public function display(catalog, categoryName) {
	    var clothingItems = new Array();
	    if (categoryName != null && categoryName != "All") {
	        var category = catalog.categories.get(categoryName);
	        clothingItems = this.filter(category.clothingItems);
	        this.fillScroll(clothingItems);
	    } else {
	        var categories = catalog.categories.values();
	        for (var i=0; i<len(categories); i++) {
	            var categoryClothingItems = categories[i].clothingItems;
	            for (var j = 0; j<len(categoryClothingItems); j++) {
	                clothingItems.append(categoryClothingItems[j]);
	            }
	        }
	        clothingItems = this.filter(clothingItems);
	        this.fillScroll(clothingItems);
	    }
	}

	public function filter(clothingItems) {
	    var purchasedClothingItemsMap = Game.sharedGame().purchasedClothingItems.getPurchasedClothingItemsMap();
	    var filteredClothingItems = new Array();
	    for (var i=0; i< len(clothingItems); i++) {
	        if (!purchasedClothingItemsMap.has_key(clothingItems[i].id)) {
	            filteredClothingItems.append(clothingItems[i]);
	        }
	    }
	    return filteredClothingItems;
	}

	public function fillScroll(clothingItems) {
        var shoppingScroll = this.getElement("shoppingScroll");
        shoppingScroll.removeAllChildren();
        var left = 0;
        var secondLaneLeft = 0;
        var rowsClothingItems = len(clothingItems) / 2;      
        var secondRow = 0;

        for (var i = 0; i < len(clothingItems); i++) {
            var clothingItem = clothingItems[i];
            var params = dict();

            params.update("left_pos", str(left));
            params.update("top_pos", 0);
            params.update("clothing_item_id", clothingItem.id);
            params.update("clothing_item_name", clothingItem.name);
            params.update("clothing_item_image", clothingItem.image);
            params.update("clothing_item_stars", clothingItem.stars);
            params.update("clothing_item_currency_image", clothingItem.getCurrencyImage());
            params.update("clothing_item_price", clothingItem.getPrice());
            params.update("clothing_item_star_one", clothingItem.getStar(1));
            params.update("clothing_item_star_two", clothingItem.getStar(2));
            params.update("clothing_item_star_three", clothingItem.getStar(3));
            params.update("clothing_item_visible", "YES");

            if (i%2 != 0) {
                params.update("top_pos", 281);
                params.update("left_pos", str(secondLaneLeft));
            }

            c_invoke(this.asyncItemLoad, i * 300, [params, clothingItem]);

            if (i%2 == 0) {
                left += 230;
            } else {
                secondLaneLeft += 230;
            }
        }
        this.getElement("shoppingScroll").setContentSize(left, 185);
	}

	public function asyncItemLoad(firingTimer, tick, args) {
	    var shoppingScroll = this.getElement("shoppingScroll");
	    var clothingItem = args[1]; 
	    var scrollClothingItem = this.controlFromXMLTemplate("ClothingItem" + clothingItem.type, args[0], "clothing-item.xml");
        scrollClothingItem.getSprite().clipping(1);
        trace("clothing item image: ", clothingItem.image);
        scrollClothingItem.tapEvent.argument = clothingItem;
        shoppingScroll.addChild(scrollClothingItem);
    }

	public function displayPurchaseButton(clothingItem) {
	    this.getElement("purchaseButton_" + str(clothingItem.id)).getSprite().visible(1);
	}

	public function hidePurchaseButton(clothingItem) {
	    if (clothingItem != null) {
	        this.getElement("purchaseButton_" + str(clothingItem.id)).getSprite().visible(0);
	    }
	}

	override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
