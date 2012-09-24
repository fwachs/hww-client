/*****************************************************************************
filename    mystery_item.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class MysteryItem
{
	var id = null;
	var name = null;
	var desc = null;
	var image = null;
	var stars = null;
	var points = null;
	var reward = null;
	var currency = null;
	
	public function MysteryItem(pId, pName, pDesc, pFileName, pStars, pPoints, pReward, pCurrency)
	{
		this.id = pId;
		this.name = pName;
		this.desc = pDesc;
		this.image = pFileName;
		this.stars = pStars;
		this.points = pPoints;
		if (pReward != null) {
		    this.reward = int(pReward);
		}
		this.currency = pCurrency;
	}

}
