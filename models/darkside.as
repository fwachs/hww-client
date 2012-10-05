/*****************************************************************************
filename    darkside.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   DarkSide model
*****************************************************************************/

class DarkSide
{
	var timer = null;
	var prizes = null;
	var doors = null;
	var isActive = 0;
	var requirementsChecked = 0;
	var accumulatedDiamonds = 0;
	var isChallengeAccepted = 0;
	
	public function DarkSide()
	{
		this.timer = new DarkSideTimer();
		
		this.load();
	}
	
	public function acceptChallenge()
	{
		this.isChallengeAccepted = 1;
		this.save();
	}
	
	public function challengeAccepted()
	{
		return this.isChallengeAccepted;
	}
	
	public function checkRequirements()
	{
    	if(this.requirementsChecked == 1) return 1;
    	
        // change for prod version 
        //var mysteryItemsCount = len(Game.sharedGame().mysteryItems);
    	var mysteryItemsCount = 1;
        var wifeItemsCount = len(Game.sharedGame().wife.mysteryItemCollection);
        
        if(wifeItemsCount >= mysteryItemsCount) {
    		this.requirementsChecked = 1;
    		this.activate();
        	
        	return 1;
        }
        
        return 0;
	}
	
	public function activate()
	{
		this.isActive = 1;
		this.doors = null;
		this.accumulatedDiamonds = 0;
		
		this.save();
	}
	
	public function deactivate()
	{
		this.isActive = 0;
		
		this.timer.restart();
		
		this.save();
	}
	
	public function isDoorOpen(doorNum)
	{
		if(this.doors == null) {
			this.doors = [0, 0, 0, 0, 0, 0, 0, 0, 0];
			this.prizes = [0, -1, -1, -1, 1, 1, 2, 2, 4];
			this.accumulatedDiamonds = 0;
		}
		
		return this.doors[doorNum];
	}
	
	public function openDoor(doorNum)
	{
		if(this.isDoorOpen(doorNum)) return null;
		
		var ret = 0;
				
		if(this.doors[doorNum] == 0) {
			this.doors[doorNum] = 1;

			var prizeIndex = rand(len(this.prizes));
			ret = this.prizes.pop(prizeIndex);	
			
			if(ret > 0) {
				this.accumulatedDiamonds += ret;
			}
			else if(ret < 0) {
				this.gotBusted();
			}
		}
		
		return ret;
	}
	
	public function gotBusted()
	{
		this.accumulatedDiamonds = 0;
		Game.sharedGame().shop.buyBailout();
	}
	
	public function getAway()
	{
		var diamonds = Game.currentGame.wallet.moneyForCurrency(this.accumulatedDiamonds, "Diamonds");
		Game.currentGame.wallet.collect(diamonds);
	}
	
	public function load() 
	{
        var papayaUserId = Game.getPapayaUserId();
        var darkSideMap = Game.getDatabase().get("darkside" + Game.getPapayaUserId());
        trace("### HWW ### - Fetched DarkSide from DB:", str(darkSideMap));
        if(darkSideMap == null) {
			this.isActive = 0;
			this.requirementsChecked = 0;
			this.isChallengeAccepted = 0;
			
            return;
        }
        
        this.isActive = darkSideMap.get("isActive");
        this.requirementsChecked = darkSideMap.get("requirementsChecked");
        this.isChallengeAccepted = darkSideMap.get("isChallengeAccepted");
	}

    public function save()
    {
        var papayaUserId = Game.getPapayaUserId();
        var serializedDarkSide = this.serialize();
        trace("### HWW ### - Saving DarkSide: ",str(serializedDarkSide));
        Game.getDatabase().put("darkside" + Game.getPapayaUserId(), serializedDarkSide);
    }

    public function serialize()
    {
        var darksideArray = [];
        darksideArray.append(["isActive", this.isActive]);
        darksideArray.append(["requirementsChecked", this.requirementsChecked]);
        darksideArray.append(["isChallengeAccepted", this.isChallengeAccepted]);
        
        return dict(darksideArray);
    }
}

class DarkSideTimer extends Timer
{
	public function DarkSideTimer()
	{
		super("DarkSideTimer", 60 * 4, -1);
	}
	
	override public function tick()
	{
		Game.sharedGame().darkSide.activate();
	}
}
