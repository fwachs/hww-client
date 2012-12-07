/*****************************************************************************
filename    hud_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/
class ClothingCatalogScreen extends Screen
{
    public function ClothingCatalogScreen()
    {
        super();
    }

    override public function build()
    {
    }

    public function fillScroll() {
        var cataloguesOptionsScroll = this.getElement("cataloguesOptionsScroll");
        var left = 0;
        var clothingCatalogs = Game.sharedGame().clothingCatalogs;
        var clothingCatalogsKeys = Game.sharedGame().clothingCatalogs.keys();
        for (var i = 0; i < len(clothingCatalogsKeys); i++) {
            var clothingCatalog = clothingCatalogs.get(clothingCatalogsKeys[i]);
            var params = dict();

            params.update("left_pos", str(left));
            params.update("catalogOptionImage", clothingCatalog.image);
            params.update("catalogOptionAction", "catalogClicked");
            params.update("catalogOptionLocked", "");
            var travelDate = Game.sharedGame().passport.datesCompleted[clothingCatalog.travelIndex];
            if (travelDate == null || travelDate == "") {
                params.update("catalogOptionAction", "catalogLocked");
                params.update("catalogOptionLocked", "Visit " + clothingCatalog.name + " and buy all gift items to unlock!");
            }

            var scrollCatalogItem = this.controlFromXMLTemplate("CatalogOption", params, "catalog-item.xml");
            scrollCatalogItem.tapEvent.argument = clothingCatalog.name;
            cataloguesOptionsScroll.addChild(scrollCatalogItem);
            left += 550;
        }
        this.getElement("cataloguesOptionsScroll").setContentSize(left, 185);
    }

    override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
