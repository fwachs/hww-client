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

    override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
