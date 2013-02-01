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
        var clothingCatalogs = Game.sharedGame().clothingCatalogs.values();
        this.sort(clothingCatalogs);

        for (var i = 0; i < len(clothingCatalogs); i++) {
            var clothingCatalog = clothingCatalogs[i];
            var params = dict();

            params.update("left_pos", str(left));
            params.update("catalogOptionImage", clothingCatalog.image);
            params.update("catalogOptionAction", "catalogClicked");
            params.update("catalogOptionLocked", "");
            params.update("catalogOptionVisible", "YES");
            /*
            var travelDate = Game.sharedGame().passport.datesCompleted[clothingCatalog.travelIndex];
            if (travelDate == null || travelDate == "") {
                params.update("catalogOptionAction", "catalogLocked");
                params.update("catalogOptionVisible", "NO");
                params.update("catalogOptionLocked", "Go to " + clothingCatalog.name + " and see all the sights first!");
            }
            */

            var scrollCatalogItem = this.controlFromXMLTemplate("CatalogOption", params, "catalog-item.xml");
            scrollCatalogItem.tapEvent.argument = clothingCatalog.name;
            cataloguesOptionsScroll.addChild(scrollCatalogItem);
            left += 550;
        }
        this.getElement("cataloguesOptionsScroll").setContentSize(left, 185);
    }

    public function sort(num) {
        var j;
        var flag = 1;   // set flag to true to begin first pass
        var temp;   //holding variable

        while ( flag == 1)
        {
               flag= 0;    //set flag to false awaiting a possible swap
               for(var j=0;  j < len(num) -1;  j++ )
               {
                      if ( num[ j ] > num[j+1] )   // change to > for ascending sort
                      {
                              temp = num[ j ];                //swap elements
                              num[ j ] = num[ j+1 ];
                              num[ j+1 ] = temp;
                             flag = 1;              //shows a swap occurred  
                     } 
               } 
         } 
    }

    override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
