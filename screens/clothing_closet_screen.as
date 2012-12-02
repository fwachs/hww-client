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

    override public function gotFocus() {
        Game.showBanner(1, 0);
    }
}
