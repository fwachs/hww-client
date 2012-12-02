/*****************************************************************************
filename    hud_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class ClothingClosetScreen extends Screen
{
    public function ClothingClosetScreen()
    {
        super();
    }

    override public function build()
    {
        Game.sharedGame().wife.dress(this);
    }

    public function display(categoryName) {
        var clothingItemInstances = Game.sharedGame().purchasedClothingItems.clothingItemInstances;
        if (categoryName == null || categoryName == "All") {
            this.fillScroll(clothingItemInstances);
        } else {
            var clothingItems = new Array();
            for (var i=0; i<len(clothingItemInstances); i++) {
                var clothingItem = clothingItemInstances[i].clothingItem;
                if (categoryName == clothingItem.category.name) {
                    clothingItems.append(clothingItemInstances[i]);
                }
            }
            this.fillScroll(clothingItems);
        }
    }

    public function fillScroll(clothingItems) {
        var shoppingScroll = this.getElement("shoppingScroll");
        shoppingScroll.removeAllChildren();
        var left = 0;
        var rowsClothingItems = len(clothingItems) / 2;      
        var secondRow = 0;
        for (var i = 0; i < len(clothingItems); i++) {
            var clothingItem = clothingItems[i].clothingItem;
            var params = dict();

            params.update("left_pos", str(left));
            params.update("top_pos", 0);
            params.update("clothing_item_id", clothingItem.id);
            params.update("clothing_item_name", clothingItem.name);
            params.update("clothing_item_image", clothingItem.image);
            params.update("clothing_item_stars", clothingItem.stars);
            params.update("clothing_item_currency", clothingItem.getCurrency());
            params.update("clothing_item_price", clothingItem.getPrice());
            params.update("clothing_item_star_one", clothingItem.getStar(1));
            params.update("clothing_item_star_two", clothingItem.getStar(2));
            params.update("clothing_item_star_three", clothingItem.getStar(3));

            if (i >= rowsClothingItems) {
                params.update("top_pos", 281);
                
                if (secondRow == 0 ) {
                    params.update("top_pos", 281);
                    left = 0;
                    params.update("left_pos",0);
                    secondRow = 1
                }
            }

            var scrollClothingItem = this.controlFromXMLTemplate("ClothingItem" + clothingItem.type, params, "clothing-item.xml");
            scrollClothingItem.getSprite().clipping(1);
            scrollClothingItem.tapEvent.argument = clothingItems[i];
            shoppingScroll.addChild(scrollClothingItem);
            left += 230;
        }
        this.getElement("shoppingScroll").setContentSize(left, 185);
    }

    override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
