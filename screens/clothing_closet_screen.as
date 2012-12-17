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
        var wife = Game.sharedGame().wife; 
        wife.dress(this);
        this.getElement("fashionScoreTotalText").setText(str(wife.calculateFashionPoints()));
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
        shoppingScroll.getSprite().pos(0,0);
        shoppingScroll.removeAllChildren();
        var left = 0;
        var secondLaneLeft = 0;
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
            params.update("clothing_item_points", str(clothingItem.points));
            params.update("clothing_item_visible", "NO");
            params.update("clothing_item_visible_open", "YES");

            if (clothingItem.type == "Jacket") {
                trace("clothing item sleeves: ", clothingItem.sleeves);
                if (clothingItem.sleeves == "rocker") {
                    params.update("clothing_item_right_sleeve", "Animation/rocker_right_arm/rocker_right_arm0001.png");
                    params.update("clothing_item_left_sleeve", "Animation/rocker_left_arm/rocker_left_arm0001.png");
                } else if (clothingItem.sleeves == "business") {
                    params.update("clothing_item_right_sleeve", "Animation/business_right_arm/business_right_arm0001.png");
                    params.update("clothing_item_left_sleeve", "Animation/business_left_arm/business_left_arm0001.png");
                } else if (clothingItem.sleeves == "retro") {
                    params.update("clothing_item_right_sleeve", "Animation/retro_right_arm/retro_right_arm0001.png");
                    params.update("clothing_item_left_sleeve", "Animation/retro_left_arm/retro_left_arm0001.png");
                }
            }

            if (i%2 != 0) {
                params.update("top_pos", 281);
                params.update("left_pos", str(secondLaneLeft));
            }

            c_invoke(this.asyncItemLoad, i * 300, [params, clothingItems[i]]);

            if (i%2 == 0) {
                left += 230;
            } else {
                secondLaneLeft += 230;
            }
        }
        this.getElement("shoppingScroll").setContentSize(left, 185);
    }

    public function asyncItemLoad(firingTimer, tick, args) {
        var params = args[0];
        var clothingItemInstance = args[1];
        var shoppingScroll = this.getElement("shoppingScroll");
        var templateName = "ClothingItem" + clothingItemInstance.clothingItem.type;
        var scrollClothingItem = this.controlFromXMLTemplate(templateName, params, "clothing/" + templateName + ".xml");
        scrollClothingItem.getSprite().clipping(1);
        scrollClothingItem.tapEvent.argument = clothingItemInstance;
        shoppingScroll.addChild(scrollClothingItem);
    }

    override public function gotFocus()
    {
        Game.showBanner(1, 0);
        this.stopWifeAnimation();
        Game.sharedGame().wife.dress(this, 0);
    }

    override public function lostFocus()
    {
        Game.showBanner(1, 0);
        this.stopWifeAnimation();
    }

    public function stopWifeAnimation()
    {
        this.getElement("rightArm").getSprite().stop();
        this.getElement("leftArm").getSprite().stop();
        this.getElement("rightArmSleeve").getSprite().stop();
        this.getElement("leftArmSleeve").getSprite().stop();
        this.getElement("face").getSprite().stop();
    }
}
