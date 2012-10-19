/*****************************************************************************
filename    husband.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/


class Husband //implements DBModel
{
	static var HubbyType_Executive = 0;
	static var HubbyType_Doctor = 1;
	static var HubbyType_Banker = 2;
	static var HubbyType_Athlete = 3;
	static var HubbyType_Lawyer = 4;
	var name;
	var type;
	var occupation;	
	var careerLevel;
	var loveTankValue;
	var stressMeterValue;
	var shoppingDreadValue;
	var workStressorValue;
	var salary;
	var localVisits;
	var totalVisits;
	var requiredVisits;
	var outShopping;
	var outWorking;
	var shoppingCounts;
	
	var workTimer;
	var shoppingTimer;
	
	var loveFillingTimer;
	var loveOption2FillingTimer;
	var stressReductionTimer;
	var stressOption2ReductionTimer;
	var stressCooldown;
	var stressOption2Cooldown;
	var loveCooldown;
	var loveOption2Cooldown;
	
	var playVideoGameCost;
	var kissCost;
	var watchTheGameCost;
	var goOnADateCost;
	
	var rareItemThreshold;
	var salaryFactor;
	
	var husbandScreen;
	var workHours;
	var workSSPReturn;
	var workBuffTime = 0;
	var shoppingBuffTime = 0;
	
	var control = null;

	public function Husband()
	{
	    this.husbandScreen = new HusbandScreen();
	    this.husbandScreen.configFile = "screen-cfgs/husband-screen-cfg.xml";
	    var controller = new HusbandController(this.husbandScreen);
	    this.control = controller;

	    this.load();
		this.workTimer = new outToWorkTimer();
		this.shoppingTimer = new outShoppingTimer();
		this.loveFillingTimer = new husbandLoveFillingTimer();
		this.loveOption2FillingTimer = new husbandLoveOption2FillingTimer();
		this.stressReductionTimer = new husbandStressReductionTimer();
		this.stressOption2ReductionTimer = new husbandStressOption2ReductionTimer();
	}

	public function getHusbandAnimation()
	{
		if(this.occupation == Husband.HubbyType_Executive) {
			return "husband_exec";
		}
		else if(this.occupation == Husband.HubbyType_Doctor) {
			return "husband_doctor";
		}
		else if(this.occupation == Husband.HubbyType_Banker) {
			return "husband_banker";
		}
		else if(this.occupation == Husband.HubbyType_Athlete) {
			return "husband_sports";
		}
		else if(this.occupation == Husband.HubbyType_Lawyer) {
			return "husband_lawyer";
		}
	}

	public function getHusbandTexture()
	{
		if(this.occupation == Husband.HubbyType_Executive) {
			return "images/Animation/exec_anim/exec_animBase.png";
		}
		else if(this.occupation == Husband.HubbyType_Doctor) {
			return "images/Animation/doctor_anim/doctor_animBase.png";
		}
		else if(this.occupation == Husband.HubbyType_Banker) {
			return "images/Animation/banker_anim/banker_animBase.png";
		}
		else if(this.occupation == Husband.HubbyType_Athlete) {
			return "images/Animation/sports_anim/sports_animBase.png";
		}
		else if(this.occupation == Husband.HubbyType_Lawyer) {
			return "images/Animation/lawyer_anim/lawyer_animBase.png";
		}
	}
	
	public function isHome()
	{
		if(this.outWorking == 0 && this.outShopping == 0) {
			return 1;
		}
		
		return 0;
	}
	
	public function setSalaryFactor(factor)
	{
		this.salaryFactor = factor;
		this.save();
	}
	
	public function setRareItemThreshold(factor)
	{
		this.rareItemThreshold = factor;
		this.save();
	}
	
	public function coolDown()
	{
		this.stressCooldown = 1;
		this.stressReductionTimer.restart();
		this.save();
	}
	
	public function returnFromWork()
	{
		this.outWorking = 0;
		
		localVisits += 1;
		totalVisits += 1;
		
		Game.sounds.playSFX("hubbyReturnHome");
		
		var payment = Game.currentGame.wallet.moneyForCurrency(this.salary * this.salaryFactor, "GameBucks");
		var ret = Game.currentGame.wallet.collect(payment);
		

		Game.sharedGame().wife.incSocialStatusPoints(this.workSSPReturn);
		
	    control.returnFromWorkPrompt();

		this.save();
		
		ppy_query("send_notification", dict([["message", "Your hubby " + Game.sharedGame().hubby.name + " has returned from work."], ["uid", Game.getPapayaUserId()]]) , null, null);
		
		Buffs.workTripEnded();
	}
	
	public function returnFromShopping()
	{
		this.outShopping = 0;
		this.shoppingCounts++;
		
		Game.sounds.playSFX("hubbyReturnHome");
        control.returnFromShoppingPrompt();
		this.save();
		
		ppy_query("send_notification", dict([["message", "Your hubby " + Game.sharedGame().hubby.name + " has returned from shopping."], ["uid", Game.getPapayaUserId()]]) , null, null);

		Buffs.shoppingTripEnded();
	}
	
	public function checkAchievements()
	{
		if(this.careerLevel == 10)
			Game.sharedGame().unlockAchievement("Up and Coming");
		if(this.careerLevel == 30)
			Game.sharedGame().unlockAchievement("Moving on Up");
		if(this.careerLevel == 50)
			Game.sharedGame().unlockAchievement("Career Driven");
		if(this.careerLevel == 80)
			Game.sharedGame().unlockAchievement("Junior Executive");
		if(this.careerLevel == 100)
			Game.sharedGame().unlockAchievement("The Boss");
		
		if(this.stressMeterValue == 10)
			Game.sharedGame().unlockAchievement("Slave Driver");
		if(this.loveTankValue == 0)
			Game.sharedGame().unlockAchievement("Running on Empty");
	}
	
	public function getWorkStressPenalty()
	{
		if(this.occupation == Husband.HubbyType_Executive) {
			if(this.careerLevel >= 86) {
				return 3;
			}
			else if(this.careerLevel >= 20) {
				return 2;
			}
			else {
				return 1;
			}
		}
		else if(this.occupation == Husband.HubbyType_Doctor) {
			if(this.careerLevel >= 95) {
				return 3;
			}
			else if(this.careerLevel >= 31) {
				return 2;
			}
			else {
				return 1;
			}
		}
		else if(this.occupation == Husband.HubbyType_Banker) {
			if(this.careerLevel >= 70) {
				return 3;
			}
			else if(this.careerLevel >= 10) {
				return 2;
			}
			else {
				return 1;
			}
		}
		else if(this.occupation == Husband.HubbyType_Athlete) {
			if(this.careerLevel >= 99) {
				return 3;
			}
			else if(this.careerLevel >= 35) {
				return 2;
			}
			else {
				return 1;
			}
		}
		else if(this.occupation == Husband.HubbyType_Lawyer) {
			if(this.careerLevel >= 91) {
				return 3;
			}
			else if(this.careerLevel >= 25) {
				return 2;
			}
			else {
				return 1;
			}
		}
	}
	
	public function getShoppingLovePenalty()
	{
		if(this.occupation == Husband.HubbyType_Executive) {
			if(this.careerLevel >= 95) {
				return 6;
			}
			else if(this.careerLevel >= 59) {
				return 4;
			}
			else {
				return 2;
			}
		}
		else if(this.occupation == Husband.HubbyType_Doctor) {
			if(this.careerLevel >= 86) {
				return 6;
			}
			else if(this.careerLevel >= 20) {
				return 4;
			}
			else {
				return 2;
			}
		}
		else if(this.occupation == Husband.HubbyType_Banker) {
			if(this.careerLevel >= 99) {
				return 6;
			}
			else if(this.careerLevel >= 64) {
				return 4;
			}
			else {
				return 2;
			}
		}
		else if(this.occupation == Husband.HubbyType_Athlete) {
			if(this.careerLevel >= 70) {
				return 6;
			}
			else if(this.careerLevel >= 10) {
				return 4;
			}
			else {
				return 2;
			}
		}
		else if(this.occupation == Husband.HubbyType_Lawyer) {
			if(this.careerLevel >= 91) {
				return 6;
			}
			else if(this.careerLevel >= 50) {
				return 4;
			}
			else {
				return 2;
			}
		}
	}
	
	public function levelUp()
	{		
		careerLevel += 1;
		salary = 100 * careerLevel;
		playVideoGameCost = 80 * careerLevel;
		kissCost = 40 * careerLevel;
		workSSPReturn = 5 * careerLevel + 5;
		
		if(careerLevel % 10 == 0) {
			watchTheGameCost += 1;
			goOnADateCost += 1;
		}
		
		this.checkAchievements();		
		Game.sounds.playSFX("hubbyLevelUp");
		
		workStressorValue = getWorkStressPenalty();
		shoppingDreadValue = getShoppingLovePenalty();
		
		updateVisits();
		updateWorkHours();
		control.updateWorkStats();
		this.save();		
	}
	
	public function updateVisits()
	{
		// reset the local visits
		localVisits = 0;
		
		if(careerLevel == 1) {
			requiredVisits = 1;
			increaseWorkHours(120);
		}
		else if(careerLevel == 2) {
			requiredVisits = 2;
		}
		else if(careerLevel == 7) {
			requiredVisits = 3;
		}
		else if(careerLevel == 17) {
			requiredVisits = 4;
		}
		else if(careerLevel == 27) {
			requiredVisits = 5;
		}
		else if(careerLevel == 37) {
			requiredVisits = 6;
		}
		else if(careerLevel == 47) {
			requiredVisits = 7;
		}
		else if(careerLevel == 57) {
			requiredVisits = 8;
		}
		else if(careerLevel == 68) {
			requiredVisits = 9;
		}
		else if(careerLevel == 78) {
			requiredVisits = 10;
		}
	}
	
	public function updateWorkHours()
	{
		if(this.careerLevel >= 100) {
			increaseWorkHours(900);
		}
		else if(this.careerLevel >= 37) {
			increaseWorkHours(600);
		}
		else if(this.careerLevel >= 17) {
			increaseWorkHours(480);
		}
		else if(this.careerLevel >= 7) {
			increaseWorkHours(240);
		}
		else if(this.careerLevel >= 2) {
			increaseWorkHours(180);
		}
		else {
			increaseWorkHours(1);
		}
	}
	
	public function setWorkBuffTime(buffTime)
	{
		this.workBuffTime = buffTime;
		this.workTimer.changeRunningTime(buffTime);
		
		this.save();
	}

	public function clearWorkBuffTime()
	{
		this.workBuffTime = 0;
		this.save();
	}

	public function increaseWorkHours(newHours)
	{
		trace("increaseWorkHours: ", newHours, " with buff: ", this.workBuffTime);
		
		Game.sharedGame().hubby.workHours = newHours;
		this.workTimer.seconds = Game.sharedGame().hubby.workHours + this.workBuffTime; 
	}
	
	public function setShoppingBuffTime(buffTime)
	{
		this.shoppingBuffTime = buffTime;
		this.shoppingTimer.changeRunningTime(buffTime);
		this.save();
	}

	public function clearShoppingBuffTime()
	{
		this.shoppingBuffTime = 0;
		this.save();
	}
	
	public function getShoppingTime()
	{
        if(this.shoppingCounts == 0) {
            return 1;
        }

		return 180 + this.shoppingBuffTime; 
	}
	
	public function sendShopping()
	{
        this.shoppingTimer.seconds = this.getShoppingTime();
        this.shoppingTimer.restart();
        this.shoppingTimer.ticks = 1;
        this.outShopping = 1;
        this.loveTankValue -= getShoppingLovePenalty();
        this.checkAchievements();
        this.save();
	}
	
	public function load() 
	{
        var papayaUserId = Game.getPapayaUserId();
        var husbandMap = Game.getDatabase().get("husband" + Game.getPapayaUserId());
        trace("### HWW ### - Fetched Husband from DB:", str(husbandMap));
        if (husbandMap == null) 
        {
        	name = "MysteryHusband";
			type = "Executive";
			occupation = 0;
			careerLevel = 1;
			loveTankValue = 10;
			stressMeterValue = 0;
			shoppingDreadValue = 2;
			workStressorValue = 1;
			salary = 100;
			localVisits = 0;
			totalVisits = 0;
			requiredVisits = 1;
			outShopping = 0;
			outWorking = 0;
			stressCooldown = 0;
			stressOption2Cooldown = 0;
			loveCooldown = 0;
			loveOption2Cooldown = 0;
			rareItemThreshold = 80;
			salaryFactor = 1;
			playVideoGameCost = 80;
			kissCost = 40;
			watchTheGameCost = 1;
			goOnADateCost = 1;
			workHours = 60;
			shoppingCounts = 0;
			workSSPReturn = 5;
			workBuffTime = 0;
			
            return;
        }
        name = husbandMap.get("name");
        occupation = husbandMap.get("occupation");
        careerLevel = husbandMap.get("careerLevel");
        loveTankValue = husbandMap.get("loveTankValue");
        stressMeterValue = husbandMap.get("stressMeterValue");
        shoppingDreadValue = husbandMap.get("shoppingDreadValue");
        workStressorValue = husbandMap.get("workStressorValue");
        salary = husbandMap.get("salary");
        localVisits = husbandMap.get("localVisits");
        totalVisits = husbandMap.get("totalVisits");
        requiredVisits = husbandMap.get("requiredVisits");
        rareItemThreshold = husbandMap.get("rareItemThreshold");
        salaryFactor = husbandMap.get("salaryFactor");        
		outShopping = husbandMap.get("outShopping");
		outWorking = husbandMap.get("outWorking");
		stressCooldown = husbandMap.get("stressCooldown");
		stressOption2Cooldown = husbandMap.get("stressOption2Cooldown");
		loveCooldown = husbandMap.get("loveCooldown");
		loveOption2Cooldown = husbandMap.get("loveOption2Cooldown");
		playVideoGameCost = husbandMap.get("playVideoGameCost");
		kissCost = husbandMap.get("kissCost");
		watchTheGameCost = husbandMap.get("watchTheGameCost");
		goOnADateCost = husbandMap.get("goOnADateCost");
		workHours = husbandMap.get("workHours");
		shoppingCounts = husbandMap.get("shoppingCounts");
		workSSPReturn = husbandMap.get("workSSPReturn");
		workBuffTime = husbandMap.get("workBuffTime");
	}

    public function save()
    {
        var papayaUserId = Game.getPapayaUserId();
        var serializedHusband = this.serialize();
        trace("### HWW ### - Saving Husband: ",str(serializedHusband));
        Game.getDatabase().put("husband" + Game.getPapayaUserId(), serializedHusband);
    }

    public function loadFromJSON(husbandMap) {
        trace("husband map from server: ", str(husbandMap));
        name = husbandMap.get("name");
        occupation = husbandMap.get("occupation");
        careerLevel = husbandMap.get("careerLevel");
        loveTankValue = husbandMap.get("loveTankValue");
        stressMeterValue = husbandMap.get("stressMeterValue");
        shoppingDreadValue = husbandMap.get("shoppingDreadValue");
        workStressorValue = husbandMap.get("workStressorValue");
        salary = husbandMap.get("salary");
        localVisits = husbandMap.get("localVisits");
        totalVisits = husbandMap.get("totalVisits");
        requiredVisits = husbandMap.get("requiredVisits");
        rareItemThreshold = 0;
        salaryFactor = 1;        
        outShopping = 0;
        outWorking = 0;
        stressCooldown = 0;
        stressOption2Cooldown = 0;
        loveCooldown = 0;
        loveOption2Cooldown = 0;
        playVideoGameCost = husbandMap.get("playVideoGameCost");
        kissCost = husbandMap.get("kissCost");
        watchTheGameCost = husbandMap.get("watchTheGameCost");
        goOnADateCost = husbandMap.get("goOnADateCost");
        workHours = husbandMap.get("workHours");
        shoppingCounts = husbandMap.get("shoppingCounts");
        workSSPReturn = husbandMap.get("workSSPReturn");
        workBuffTime = husbandMap.get("workBuffTime");
    }

    public function serialize()
    {
        var papayaUserId = Game.getPapayaUserId();
        var husbandArray = [];
        husbandArray.append(["papayaUserId", papayaUserId]);
        husbandArray.append(["name", name]);
        husbandArray.append(["occupation", occupation]);
        husbandArray.append(["careerLevel", careerLevel]);
        husbandArray.append(["loveTankValue", loveTankValue]);
        husbandArray.append(["stressMeterValue", stressMeterValue]);
        husbandArray.append(["shoppingDreadValue", shoppingDreadValue]);
        husbandArray.append(["workStressorValue", workStressorValue]);
        husbandArray.append(["salary", salary]);
        husbandArray.append(["localVisits", localVisits]);
        husbandArray.append(["totalVisits", totalVisits]);
        husbandArray.append(["requiredVisits", requiredVisits]);
        husbandArray.append(["outWorking", outWorking]);
        husbandArray.append(["rareItemThreshold", rareItemThreshold]);        
        husbandArray.append(["salaryFactor", salaryFactor]);
        husbandArray.append(["playVideoGameCost", playVideoGameCost]);
        husbandArray.append(["kissCost", kissCost]);
        husbandArray.append(["watchTheGameCost", watchTheGameCost]);
        husbandArray.append(["goOnADateCost", goOnADateCost]);
        husbandArray.append(["workHours", workHours]);
        husbandArray.append(["shoppingCounts", shoppingCounts]);
        husbandArray.append(["workSSPReturn", workSSPReturn]);
		husbandArray.append(["workBuffTime", workBuffTime]);
        husbandArray.append(["outShopping", outShopping]);
        husbandArray.append(["stressCooldown", stressCooldown]);
        husbandArray.append(["stressOption2Cooldown", stressOption2Cooldown]);
        husbandArray.append(["loveCooldown", loveCooldown]);
        husbandArray.append(["loveOption2Cooldown", loveOption2Cooldown]);

        return dict(husbandArray);
    }

}

/*****************************************************************************
    Message Box Functions
*****************************************************************************/

function hlevel(x)
{
	trace("### HWW ### - Level up!");
}

function hyes(x)
{
	trace("### HWW ### - action selected");
}

function hno(x)
{
	trace("### HWW ### - action declined");
}

/*****************************************************************************
    Timers
*****************************************************************************/

class outToWorkTimer extends Timer
{
	public function outToWorkTimer()
	{
		trace("### HWW ### - Hubby work hours for timer: " + str(Game.sharedGame().hubby.workHours));
		super("outToWorkTimer", 1, 1);
	}
	
	override public function tick()
	{
		if(this.ticks > 0 && Game.sharedGame().hubby.outWorking == 1) {
			Game.sharedGame().hubby.returnFromWork();
		}
	}
}

class outShoppingTimer extends Timer
{
	public function outShoppingTimer()
	{
		super("outShoppingTimer", 180, 1);
	}
	
	override public function tick()
	{
		if(this.ticks > 0 && Game.sharedGame().hubby.outShopping == 1) {
			Game.sharedGame().hubby.returnFromShopping();
		}
	}
}
