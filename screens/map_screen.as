/*****************************************************************************
filename    map_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class MapScreen
{
	var elements;
	var controller;
	var canvas;
	var background;
	
	override public function build()
	{
		this.background = this.canvas.addsprite("map.png");
	}
}
