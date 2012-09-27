/*****************************************************************************
filename    husband.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/


class Husband //implements DBModel
{
	var name;
	var type;
	// 0 - executive
	// 1 - doctor
	// 2 - banker
	// 3 - athlete
	// 4 - lawyer
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
	var stressReductionTimer;
	var stressCooldown;
	var loveCooldown;
	
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
		this.stressReductionTimer = new husbandStressReductionTimer();
	}

	public function getHusbandAnimation()
	{
		if(this.occupation == 0) {
			return "husband_exec";
		}
		else if(this.occupation == 1) {
			return "husband_doctor";
		}
		else if(this.occupation == 2) {
			return "husband_banker";
		}
		else if(this.occupation == 3) {
			return "husband_sports";
		}
		else if(this.occupation == 4) {
			return "husband_lawyer";
		}
	}

	public function getHusbandTexture()
	{
		if(this.occupation == 0) {
			return "images/Animation/exec_anim/exec_animBase.png";
		}
		else if(this.occupation == 1) {
			return "images/Animation/doctor_anim/doctor_animBase.png";
		}
		else if(this.occupation == 2) {
			return "images/Animation/banker_anim/banker_animBase.png";
		}
		else if(this.occupation == 3) {
			return "images/Animation/sports_anim/sports_animBase.png";
		}
		else if(this.occupation == 4) {
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
		
		Buffs.resetBuffs();
	}
	
	public function returnFromShopping()
	{
		this.outShopping = 0;
		this.shoppingCounts++;
		
		Game.sounds.playSFX("hubbyReturnHome");
        control.returnFromShoppingPrompt();
		this.save();
		
		ppy_query("send_notification", dict([["message", "Your hubby " + Game.sharedGame().hubby.name + " has returned from shopping."], ["uid", Game.getPapayaUserId()]]) , null, null);

		Buffs.resetBuffs();
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
	
	public function levelUp()
	{		
		careerLevel += 1;
		salary += 100;
		playVideoGameCost += 40;
		kissCost += 20;
		workSSPReturn += 5;
		
		if(careerLevel % 10 == 0) {
			watchTheGameCost += 1;
			goOnADateCost += 1;
		}
		
		this.checkAchievements();		
		Game.sounds.playSFX("hubbyLevelUp");
		
		updateVisits();
		
		if(careerLevel == 1) {
			workStressorValue = 1;
			shoppingDreadValue = 2;
		}
		else if(careerLevel == 20) {
			// banker
			if(occupation == 2) {
				workStressorValue = 2;
			}
			// athlete
			else if(occupation == 3) {
				shoppingDreadValue = 4;
			}
		}
		else if(careerLevel == 40) {
			// excutive
			if(occupation == 0) {
				workStressorValue = 2;
			}
			// doctor
			else if(occupation == 1) {
				shoppingDreadValue = 4;
			}
		}
		else if(careerLevel == 50) {
			// lawyer
			if(occupation == 4) {
				workStressorValue = 2;
				shoppingDreadValue = 4;
			}
		}
		else if(careerLevel == 59) {
			// excutive
			if(occupation == 0) {
				shoppingDreadValue = 4;
			}
			// doctor
			else if(occupation == 1) {
				workStressorValue = 2;
			}
		}
		else if(careerLevel == 64) {
			// banker
			if(occupation == 2) {
				shoppingDreadValue = 4;
			}
			// athlete
			else if(occupation == 3) {
				workStressorValue = 2;
			}
		}
		else if(careerLevel == 70) {
			// banker
			if(occupation == 2) {
				workStressorValue = 3;
			}
			// athlete
			else if(occupation == 3) {
				shoppingDreadValue = 6;
			}
		}
		else if(careerLevel == 86) {
			// excutive
			if(occupation == 0) {
				workStressorValue = 3;
			}
			// doctor
			else if(occupation == 1) {
				shoppingDreadValue = 6;
			}
		}
		else if(careerLevel == 91) {
			// excutive
			if(occupation == 0) {
				shoppingDreadValue = 6;
			}
			// doctor
			else if(occupation == 1) {
				workStressorValue = 3;
			}
		}
		else if(careerLevel == 99) {
			// banker
			if(occupation == 2) {
				shoppingDreadValue = 6;
			}
			// athlete
			else if(occupation == 3) {
				workStressorValue = 3;
			}
		}
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
		
		updateWorkHours();
		control.updateWorkStats();
		this.save();
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
        this.loveTankValue -= this.shoppingDreadValue;
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
        	name = "Mark";
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
			loveCooldown = 0;
			rareItemThreshold = 80;
			salaryFactor = 1;
			playVideoGameCost = 40;
			kissCost = 20;
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
		loveCooldown = husbandMap.get("loveCooldown");
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
		husbandArray.append(["workBuffTime", workBuffTime]);
        husbandArray.append(["stressCooldown", stressCooldown]);
        husbandArray.append(["loveCooldown", loveCooldown]);

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
