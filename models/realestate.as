/*****************************************************************************
filename    realestate.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   Users realestate showing what properties have been bought.
*****************************************************************************/

class Realestate
{
	var propertyListing;
	
	public function Realestate()
	{
		this.load();
	}
	
	public function load() 
	{
        var papayaUserId = Game.getPapayaUserId();
        var realestateMap = Game.getDatabase().get("realestate" + Game.getPapayaUserId());
        trace("### HWW ### - Fetched Realestate from DB: ", str(realestateMap));
        
        if (realestateMap == null) 
        {
    		propertyListing = [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
			
			return;
        }
        
        propertyListing = realestateMap.get("propertyListing");
	}

	public function loadFromJSON(realstateMap) {
	    this.propertyListing = realstateMap.get("propertyListing");
	}

    public function save()
    {
        var papayaUserId = Game.getPapayaUserId();
        var serializedRealestate = this.serialize();
        trace("### HWW ### - Saving Realestate:", str(serializedRealestate));
        Game.getDatabase().put("realestate" + Game.getPapayaUserId(), serializedRealestate);
    }

    public function serialize()
    {
        var papayaUserId = Game.getPapayaUserId();
        var realestateArray = [];
        realestateArray.append(["id", papayaUserId]);
        realestateArray.append(["propertyListing", propertyListing]);
        
        return dict(realestateArray);
    }
}