/*****************************************************************************
filename    wife.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class Wife
{
	var name;
	
	// modern, rocker, business, retro, celebrity
	var type;
	var hairStyle;
	// HS01 = Brown, HS02 = Blond, HS03 = Red Head, HS04 = Raven Black, HS05 = Light Brown / Ash, HS06 = Mystery Color
	var hairColor;
	var skinTone;
	var socialStatusPoints = 0;
	var firstPlay = 0;
	var statusPointsFactor = 1;
	var mysteryItemCollection = dict();
	
	public function Wife()
	{
		this.load();
	}
	
	public function loadFromJSON(bestWife)
	{
		this.name = bestWife.get("name");
		this.type = bestWife.get("type");
		this.hairColor = bestWife.get("hairColor");
		this.hairStyle = bestWife.get("hairStyle");
		this.skinTone = bestWife.get("skinTone");
		this.socialStatusPoints = bestWife.get("socialStatusPoints");
	}
	
	public function getType()
	{
		return this.type;
	}
	
	public function dress(screen)
	{
		var body = screen.getElement("body").getSprite().texture("images/customize-wife/wife parts/WifeBodyBase.png");
		var face = screen.getElement("face").getSprite();
		var action = Game.animations.getAnimation("wife_generic_face");
		action.stop();
		face.stop();
		face.addaction(repeat(action));

		var rightArm = screen.getElement("rightArm").getSprite();
		rightArm.stop();
        var rightArmAction = Game.animations.getRightArmAnimation();
        rightArmAction.stop();
        rightArm.color(this.skinTone[0], this.skinTone[1], this.skinTone[2]);
        rightArm.addaction(repeat(rightArmAction));

		var leftArm = screen.getElement("leftArm").getSprite();
		leftArm.stop();
		var leftArmAction = Game.animations.getLeftArmAnimation();
		leftArmAction.stop();
		leftArm.color(this.skinTone[0], this.skinTone[1], this.skinTone[2]);
		leftArm.addaction(repeat(leftArmAction));
		
		var hairBack = screen.getElement("hairback").getSprite();
		var shoes = screen.getElement("shoes").getSprite();
		var pants = screen.getElement("pants").getSprite();
		var belt = screen.getElement("belt").getSprite();
		var dress = screen.getElement("dress").getSprite();
		var shirt = screen.getElement("shirt").getSprite();
		var jacket = screen.getElement("jacket").getSprite();
		var hairFront = screen.getElement("hairfront").getSprite();
		var undies = screen.getElement("undies").getSprite().texture("");

		body.color(this.skinTone[0], this.skinTone[1], this.skinTone[2]);
		var rightArmSleeve = screen.getElement("rightArmSleeve").getSprite();
		rightArmSleeve.stop();
		var leftArmSleeve = screen.getElement("leftArmSleeve").getSprite();
		leftArmSleeve.stop();

		if(this.type == "Modern")
		{
			shoes.texture("images/customize-wife/wife parts/WShoesMod001.png");
			pants.texture("");
			belt.texture("");
			dress.texture("images/customize-wife/wife parts/WDressFMod001.png");
			shirt.texture("");
			jacket.texture("");
		}
		else if(this.type == "Rocker")
		{
			rightArmSleeve.addaction(repeat(Game.animations.getRockerRightArmAnimation()));
			leftArmSleeve.addaction(repeat(Game.animations.getRockerLeftArmAnimation()));
			
			shoes.texture("images/customize-wife/wife parts/WShoesRock001.png");
			pants.texture("images/customize-wife/wife parts/PantsRock001.png");
			belt.texture("images/customize-wife/wife parts/BeltRock001.png");
			dress.texture("");
			shirt.texture("images/customize-wife/wife parts/WShirtRock001.png");
			jacket.texture("images/customize-wife/wife parts/WJacketRock001.png");
		}
		else if(this.type == "Business")
		{
			rightArmSleeve.addaction(repeat(Game.animations.getBusinessRightArmAnimation()));
			leftArmSleeve.addaction(repeat(Game.animations.getBusinessLeftArmAnimation()));

			shoes.texture("images/customize-wife/wife parts/WShoesBus001.png");
			pants.texture("images/customize-wife/wife parts/PantsBus001.png");
			belt.texture("");
			dress.texture("");
			shirt.texture("images/customize-wife/wife parts/WShirtBus001.png");
			jacket.texture("images/customize-wife/wife parts/WJacketBus001.png");
		}
		else if(this.type == "Retro")
		{
			rightArmSleeve.addaction(repeat(Game.animations.getRetroRightArmAnimation()));
			leftArmSleeve.addaction(repeat(Game.animations.getRetroLeftArmAnimation()));
			
			shoes.texture("images/customize-wife/wife parts/WShoesRetr001.png");
			pants.texture("");
			belt.texture("");
			dress.texture("images/customize-wife/wife parts/WDressRetr001.png");
			shirt.texture("");
			jacket.texture("");
		}
		else if(this.type == "Celeb")
		{
			shoes.texture("images/customize-wife/wife parts/WShoesCelb001.png");
			pants.texture("");
			belt.texture("");
			dress.texture("images/customize-wife/wife parts/WDressFCelb001.png");
			shirt.texture("");
			jacket.texture("");
		}
		
		cutAndDyeHair(screen);
	}
	
	public function cutAndDyeHair(screen)
	{
		var hairBack = screen.getElement("hairback").getSprite();
		var hairFront = screen.getElement("hairfront").getSprite();
		
		var hairTypeText = getHairType();
		var hairColorText = getHairColor();
		var hairStyleText = getHairStyle();
		
		var base = "images/customize-wife/6HairStyles/";
		var frontString = base + hairTypeText + hairColorText + "Back" + hairStyleText + ".png";
		var backString = base + hairTypeText + hairColorText + "Front" + hairStyleText + ".png";

		hairBack.texture(frontString);
		hairFront.texture(backString);
	}
	
	public function getHairType()
	{
		if(this.type == "Modern")
		{
			return "modern/Modr";
		}
		else if(this.type == "Rocker")
		{
			return "Rocker/Rock";
		}
		else if(this.type == "Business")
		{
			return "business/Buss";
		}
		else if(this.type == "Retro")
		{
			return "Retro/Retro";
		}
		else if(this.type == "Celeb")
		{
			return "celeb/Celeb";
		}
	}
	
	public function getHairColor()
	{
		if(this.hairColor == 0) // Brown
		{
			return "HS01";
		}
		else if(this.hairColor == 1) // Blond
		{
			return "HS02";
		}
		else if(this.hairColor == 2) // Red Head
		{
			return "HS03";
		}
		else if(this.hairColor == 3) // Raven Black
		{
			return "HS04";
		}
		else if(this.hairColor == 4) // Light Brown / Ash
		{
			return "HS05";
		}
		else if(this.hairColor == 5) // Mystery Color
		{
			return "HS06";
		}
	}
	
	public function getHairStyle()
	{
		if(this.hairStyle == 0)
		{
			return "01";
		}
		else if(this.hairStyle == 1)
		{
			return "02";
		}
		else if(this.hairStyle == 2)
		{
			return "03";
		}
		else if(this.hairStyle == 3)
		{
			return "04";
		}
		else if(this.hairStyle == 4)
		{
			return "05";
		}
		else if(this.hairStyle == 5)
		{
			return "06";
		}
	}
	
	public function incSocialStatusPoints(points)
	{
		Game.sounds.playSFX("gainSSP");
		
		trace("Increment SSPs: ", this.socialStatusPoints, points, this.statusPointsFactor);
		var total = points + points * this.statusPointsFactor / 100;
		this.socialStatusPoints += total;
		this.save();
		trace("Increment SSPs after: ", this.socialStatusPoints);

		ppy_updatescore(total);
		this.checkAchievements();
	}
	
	public function checkAchievements()
	{
		if(this.socialStatusPoints > 1000)
			Game.sharedGame().unlockAchievement("What's Her Name?");
		if(this.socialStatusPoints > 10000)
			Game.sharedGame().unlockAchievement("Social Climber");
		if(this.socialStatusPoints > 100000)
			Game.sharedGame().unlockAchievement("Celebrity");
		if(this.socialStatusPoints > 1000000)
			Game.sharedGame().unlockAchievement("A-Lister");
	}
	
	public function setStatusPointsFactor(newFactor)
	{
		this.statusPointsFactor = newFactor;
		this.save();
	}

	public function load() 
	{
        var papayaUserId = Game.getPapayaUserId();
		var db = Game.getDatabase();
        var wifeMap = db.get("wife" + Game.getPapayaUserId());
        trace("### HWW ### - Fetched Wife from DB: ", str(wifeMap));
        if (wifeMap == null) 
        {
	        name = "MysteryWife";
			type = "Modern";
			hairStyle = 0;
			hairColor = 0;
			
			skinTone = [100, 86, 68];
			
			socialStatusPoints = 0;
			mysteryItemCollection = dict();
			firstPlay = 1;
			
			statusPointsFactor = 0;
			
			return;
        }
        name = wifeMap.get("name");
		type = wifeMap.get("type");
		hairStyle = wifeMap.get("hairStyle");
		hairColor = wifeMap.get("hairColor");
		skinTone = wifeMap.get("skinTone");
		socialStatusPoints = wifeMap.get("socialStatusPoints");
		if (socialStatusPoints == null) {
            socialStatusPoints = 0;
        }
		statusPointsFactor = wifeMap.get("statusPointsFactor");
		
		this.loadMysteryItems();

        trace("### HWW ### - Fetched Wife socialStatusPoints: ", this.socialStatusPoints);
	}
	
	public function loadMysteryItems()
	{
        var papayaUserId = Game.getPapayaUserId();
		var db = Game.getDatabase();
        var mysteryIds = db.get("mysteryItems" + Game.getPapayaUserId());
        
        for(var i = 0; i < len(mysteryIds); i++) {
        	this.mysteryItemCollection.update(mysteryIds[i], Game.sharedGame().furnitureListing.get(mysteryIds[i]));
        }
	}
	
    public function save()
    {
    	firstPlay = 0;
        var papayaUserId = Game.getPapayaUserId();
        var serializedWife = this.serialize();
        trace("### HWW ### - Saving Wife:", str(serializedWife));
        Game.getDatabase().put("wife" + Game.getPapayaUserId(), serializedWife);
        
        this.saveMysteryItems();
    }
    
    public function saveMysteryItems()
    {
        var papayaUserId = Game.getPapayaUserId();
    	
    	var keys = this.mysteryItemCollection.keys();
    	trace("Mystery items keys: ", keys);
    	
        Game.getDatabase().put("mysteryItems" + Game.getPapayaUserId(), this.mysteryItemCollection.keys());
    }

    public function serialize()
    {
        var papayaUserId = Game.getPapayaUserId();
        var wifeArray = [];
        wifeArray.append(["id", papayaUserId]);
        wifeArray.append(["name", name]);
        wifeArray.append(["type", type]);
        wifeArray.append(["hairStyle", hairStyle]);
        wifeArray.append(["hairColor", hairColor]);
        wifeArray.append(["skinTone", skinTone]);
        if (socialStatusPoints == null) {
            socialStatusPoints = 0;
        }
        wifeArray.append(["socialStatusPoints", socialStatusPoints]);
        wifeArray.append(["statusPointsFactor", statusPointsFactor]);
        return dict(wifeArray);
    }

    public function awardMysteryItem(mysteryItem) {
        this.mysteryItemCollection.update(mysteryItem.id, mysteryItem);
        this.incSocialStatusPoints(mysteryItem.points);
        if (mysteryItem.reward != null) {
            var reward = Game.currentGame.wallet.moneyForCurrency(mysteryItem.reward, mysteryItem.currency);
            var ret = Game.currentGame.wallet.collect(reward);
            trace("### HWW ###: Reward Awarded: ", mysteryItem.id, " currency:", mysteryItem.currency, " amount: ", mysteryItem.reward, " ret: ", str(ret));
        }
    }
}
