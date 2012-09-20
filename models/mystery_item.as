/*****************************************************************************
filename    mystery_item.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class MysteryItem
{
	var id;
	var name;
	var desc;
	var image;
	var stars;
	var points;
	
	public function MysteryItem(pId, pName, pDesc, pFileName, pStars, pPoints)
	{
		this.id = pId;
		this.name = pName;
		this.desc = pDesc;
		this.image = pFileName;
		this.stars = pStars;
		this.points = pPoints;
	}
}
