/*****************************************************************************
filename    font.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   Represents a displayable font
*****************************************************************************/

class Font
{
	var fontType;
	var fontTypeBold;
	var smallSize;
	var mediumSize;
	var largeSize;
	
	public function Font()
	{
		this.fontType = "Arial";
		this.fontTypeBold = "Arial";
		if (getmodel() == 6) {
			this.fontType = "fonts/calibri.ttf";
			this.fontTypeBold = "fonts/calibrib.ttf";
		}
		this.smallSize = 30 * Game.screenScale / 100;
		this.mediumSize = 60 * Game.screenScale / 100;
		this.largeSize = 72 * Game.screenScale / 100;
	}
	
	public function getFont()
	{
		return this.fontType;
	}
	
	public function getBoldFont()
	{
		return this.fontTypeBold;
	}
	
	public function setFont(newFontType)
	{
		this.fontType = newFontType;
	}
	
	public function getSmallFontSize()
	{
		return this.smallSize;
	}
	
	public function getLargeFontSize()
	{
		return this.largeSize;
	}
}
