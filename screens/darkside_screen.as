/*****************************************************************************
filename    darkside_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class DarkSideScreen extends Screen
{
	public function DarkSideScreen()
	{
		super();
	}
	
	override public function build()
	{
	}
	
	public function highlightDoor(doorNum)
	{
		var ele = this.getElement("door" + str(doorNum));
		var pos = ele.getSprite().pos();
		
		var selector = this.getElement("door-selector");
		
		selector.getSprite().visible(1);
		selector.getSprite().pos(pos[0], pos[1]);
	}
	
	public function hideHighlight()
	{
		var selector = this.getElement("door-selector");		
		selector.getSprite().visible(0);
	}
	
	public function showDiamondsAtDoor(doorNum, count)
	{
		var ele = this.getElement("door" + str(doorNum));
		ele.getSprite().texture("images/dark-side/diamond-safe" + str(count) + ".png");
	}
	
	public function showEmptyAtDoor(doorNum)
	{
		var ele = this.getElement("door" + str(doorNum));
		ele.getSprite().texture("images/dark-side/webs-icon-empty-safe.png");
	}
	
	public function showCopAtDoor(doorNum)
	{
		var ele = this.getElement("door" + str(doorNum));
		ele.getSprite().texture("images/dark-side/jail-safe.png");
	}
}
