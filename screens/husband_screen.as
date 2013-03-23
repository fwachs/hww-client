/*****************************************************************************
filename    husband_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class HusbandScreen extends Screen
{
	var workBuffIcon = null;
	var shoppingBuffIcon = null;

	var careerLevelText;
	var careerStatusProgress;
	var salary;
	var salaryText;
	var loveTank;
	var loveTankLevelText;
	var stressMeter;
	var stressLevelText;
	
	var sendWorkText;
	var sendShoppingText;
	var stressCooldownText;
	var stressOption2CooldownText;
	var loveCooldownText;
	var loveOption2CooldownText;
	var sendToWorkButtonOverlay;
	var sendShoppingButtonOverlay;
	
	var prevIsHome ;
	
	var updateTimer = null;
	
	public function HusbandScreen()
	{
		super();
	}
	
	override public function build()
	{
		var husbandElement = this.getElement("hubby").getSprite();
		var husband = Game.sharedGame().hubby;
		husbandElement.texture(husband.getHusbandTexture());

		//this.showChatText();
		this.startHusbandAnimation();
		
		this.initializeScreen();
	}

	public function initializeScreen()
	{
		sendWorkText = this.getElement("sendToWorkButtonText");
		sendToWorkButtonOverlay = this.getElement("sendToWorkButtonOverlay").getSprite().visible(1);
		sendWorkText.setText("");
				
		sendShoppingText = this.getElement("sendShoppingButtonText");
		sendShoppingText.setText("");
		sendShoppingButtonOverlay = this.getElement("sendShoppingButtonOverlay").getSprite().visible(1);

		stressCooldownText = this.getElement("stressOption1_text");
		stressCooldownText.setText("Boy's night out");
		
		stressOption2CooldownText = this.getElement("stressOption2_text");
		stressOption2CooldownText.setText("Play video games");

		loveCooldownText = this.getElement("loveOption1_text"); 
		loveCooldownText.setText("Cook for him");
		
		loveOption2CooldownText = this.getElement("loveOption2_text"); 
		loveOption2CooldownText.setText("Give him a kiss");

		var occupation = this.getElement("occupation").getSprite();
		
		if(Game.sharedGame().hubby.occupation == 0){
			occupation.addlabel("Executive", Game.font.getFont(), Game.translateFontSize(36));
		}
		else if(Game.sharedGame().hubby.occupation == 1){
			occupation.addlabel("Doctor", Game.font.getFont(), Game.translateFontSize(36));
		}
		else if(Game.sharedGame().hubby.occupation == 2){
			occupation.addlabel("Banker", Game.font.getFont(), Game.translateFontSize(36));
		}
		else if(Game.sharedGame().hubby.occupation == 3){
			occupation.addlabel("Athlete", Game.font.getFont(), Game.translateFontSize(36));
		}
		else if(Game.sharedGame().hubby.occupation == 4){
			occupation.addlabel("Lawyer", Game.font.getFont(), Game.translateFontSize(36));
		}

		this.careerLevelText = this.getElement("careerLevelText");
		careerLevelText.setText(str(Game.sharedGame().hubby.careerLevel));
		
		careerStatusProgress = this.getElement("careerStatusFrameProgress").getSprite();
		
		salary = this.getElement("salary").getSprite();
		salaryText = salary.addlabel(str(Game.sharedGame().hubby.salary) + " GB", Game.font.getFont(), Game.translateFontSize(40));
		
		var name = this.getElement("name").getSprite();
		name.addlabel(str(Game.sharedGame().hubby.name), Game.font.getFont(), Game.translateFontSize(50));
		
		// Love Tank
		loveTank = this.getElement("loveTank").getSprite();
		this.updateLoveTank(loveTank, Game.sharedGame().hubby.loveTankValue);
		loveTankLevelText = loveTank.addlabel(str(Game.sharedGame().hubby.loveTankValue),Game.font.getFont(),Game.translateFontSize(75)).pos(Game.translateX(130), Game.translateY( 21));
		
		// Stress Meter
		stressMeter = this.getElement("stressMeter").getSprite();
		trace("StressMeter:", stressMeter);
		this.updateStressMeter(stressMeter, Game.sharedGame().hubby.stressMeterValue);
		stressLevelText = stressMeter.addlabel(str(Game.sharedGame().hubby.stressMeterValue),Game.font.getFont(),Game.translateFontSize(75)).pos(Game.translateX(130), Game.translateY( 27));
	}
	
    public function showChatText() 
    {
    	if(this.getElement("chatText") == null) return;
    	
        if(this.firstTime != 1 && Game.sharedGame().hubby.isHome()  &&  this.getElement("chatBubble").getSprite().visible() == 0) {
            var chatText = this.getElement("chatText");
            var husbandMessage = Game.sharedGame().getRandomMessage("husband-screen");
            trace("HWW ### - husband message: ", husbandMessage);
            chatText.setText(husbandMessage);
            chatText.textColor(0, 0, 0);
            this.getElement("chatBubble").getSprite().visible(1);
            c_invoke(this.hideChatBubble, 4000, null);
        }
    }

    public function hideChatBubble() {
        this.getElement("chatBubble").getSprite().visible(0);
        c_invoke(this.showChatText, 10000, null);
    }

	override public function gotFocus()
	{
		Game.showBanner(1,1);
		
		if(Game.sharedGame().hubby.isHome() == 0) {
			if (this.getElement("faceAnimation") != null) {
				this.stopHusbandAnimation();
				this.getElement("faceAnimation").getSprite().visible(0);
			}
		}
		else {
			if (this.getElement("faceAnimation") != null) {
				this.getElement("faceAnimation").getSprite().visible(1);
				this.startHusbandAnimation();
			}
		}
		
		Game.startButtonShineAnimation();

        this.showChatText();

        this.updateTimer = c_addtimer(1000, this.updateLabels, null, 0, -1);
        
        this.prevIsHome = -1;
	}
		
	public function startHusbandAnimation()
	{
		var husband = Game.sharedGame().hubby;
		if (this.getElement("faceAnimation") != null) {
		    var faceSprite = this.getElement("faceAnimation").getSprite();
	        var action = Game.animations.getAnimation(husband.getHusbandAnimation());
	        faceSprite.stop();
	        faceSprite.addaction(repeat(action));
		}
	}

	public function stopHusbandAnimation()
	{
	    if (this.getElement("faceAnimation") != null) {
	        this.getElement("faceAnimation").getSprite().stop();
	    }
	}

	override public function lostFocus()
	{
		Game.hideBanner();
		this.stopHusbandAnimation();
		Game.stopButtonShineAnimation();
		
		this.updateTimer.stop();
	}

	public function fillLoveTank()
	{
		if(this.getElement("stressOptionsFrame").getSprite().visible() == 0) {
			this.getElement("loveOptionsFrame").getSprite().visible(1);
			this.getElement("loveOption2_cost_text").setText(str(Game.sharedGame().hubby.kissCost));
			this.getElement("loveOption3_cost_text").setText(str(Game.sharedGame().hubby.goOnADateCost));
		}
	}
	
	public function closeLoveOptions()
	{
		this.getElement("loveOptionsFrame").getSprite().visible(0);
	}
	
	public function closeStressOptions()
	{
		this.getElement("stressOptionsFrame").getSprite().visible(0);
	}
	
	public function releaseStress()
	{
		if(this.getElement("loveOptionsFrame").getSprite().visible() == 0) {
			this.getElement("stressOptionsFrame").getSprite().visible(1);
			this.getElement("stressOption2_cost_text").setText(str(Game.sharedGame().hubby.playVideoGameCost));
			this.getElement("stressOption3_cost_text").setText(str(Game.sharedGame().hubby.watchTheGameCost));
		}
	}
	
	public function displayWorkBuffIcon()
	{
		var iconElement = this.getElement("work-buff-icon");
		trace("work-buff-icon-element: ", iconElement);
		if (iconElement != null) {
		    var sprt = iconElement.getSprite();
		    if(Buffs.workIcon != null) {
		    	sprt.visible(1);
		        sprt.texture(Buffs.workIcon);
		    } else {
		    	sprt.visible(0);
		    }
		}
	}
	
	public function displayShoppingBuffIcon()
	{
		var iconElement = this.getElement("shop-buff-icon");
		trace("shop-buff-icon-element: ", iconElement);
		if (iconElement != null) {
		    var sprt = iconElement.getSprite();
		    trace("buff shopping icon", Buffs.shoppingIcon);
		    if(Buffs.shoppingIcon != null) {
		    	sprt.visible(1);
		        sprt.texture(Buffs.shoppingIcon);
		    } else {
		    	sprt.visible(0);
		    }
		}
	}

	public function updateLabels(timer, tick, param)
	{
		// don't update if were are in a modal screen pop-up
		if(this.getScreenName() == "husband-screen" && sendWorkText != null) {
			if(Game.sharedGame().hubby.outWorking == 1) {
				sendWorkText.setText(Game.sharedGame().hubby.workTimer.getTimeString());
				sendToWorkButtonOverlay.visible(0);
			}
			else {
				sendWorkText.setText("");
				sendToWorkButtonOverlay.visible(1);
			}
			
			if(Game.sharedGame().hubby.outShopping == 1) {
				sendShoppingText.setText(Game.sharedGame().hubby.shoppingTimer.getTimeString());
				sendShoppingButtonOverlay.visible(0);
			}
			else {
				sendShoppingText.setText("");
				sendShoppingButtonOverlay.visible(1);
			}
			
            if(Game.sharedGame().darkSide.checkRequirements() == 1) {
				if(Game.sharedGame().darkSide.isActive == 0 && Game.sharedGame().darkSide.challengeAccepted() == 1) {
					this.getElement("secretButtonText").setText(Game.sharedGame().darkSide.timer.getTimeString());
					this.getElement("secretButtonOverlay").getSprite().visible(0);
				}
				else {
					this.getElement("secretButtonText").setText("");
					this.getElement("secretButtonOverlay").getSprite().visible(1);
					this.getElement("secretButtonOverlay").getSprite().texture("images/dark-side/dark-side-text.png");
				}
            }
            else {
				this.getElement("secretButtonText").setText("");
				this.getElement("secretButtonOverlay").getSprite().visible(1);
            }
			
			if(Game.sharedGame().hubby.stressCooldown == 1) {
				trace("### HWW ### - Husband Stress Reduction Timer: " + Game.sharedGame().hubby.stressReductionTimer.getTimeString());
				stressCooldownText.setText(Game.sharedGame().hubby.stressReductionTimer.getTimeString());
			}
			else {
				stressCooldownText.setText("Boy's night out");
			}
			
			if(Game.sharedGame().hubby.stressOption2Cooldown == 1) {
				trace("### HWW ### - Husband Stress Reduction Timer: " + Game.sharedGame().hubby.stressOption2ReductionTimer.getTimeString());
				stressOption2CooldownText.setText(Game.sharedGame().hubby.stressOption2ReductionTimer.getTimeString());
			}
			else {
				stressOption2CooldownText.setText("Play video games");
			}
			
			if(Game.sharedGame().hubby.loveCooldown == 1) {
				loveCooldownText.getSprite().pos(Game.translateX(300), Game.translateY( 70));
				loveCooldownText.setText(Game.sharedGame().hubby.loveFillingTimer.getTimeString());
			}
			else {
				loveCooldownText.setText("Cook for him");
			}
			
			if(Game.sharedGame().hubby.loveOption2Cooldown == 1) {
				loveOption2CooldownText.setText(Game.sharedGame().hubby.loveOption2FillingTimer.getTimeString());
			}
			else {
				loveOption2CooldownText.setText("Give him a kiss");
			}

			// update stress text
			updateStressMeter(stressMeter, Game.sharedGame().hubby.stressMeterValue);
			stressLevelText.text(str(Game.sharedGame().hubby.stressMeterValue));

			updateLoveTank(loveTank, Game.sharedGame().hubby.loveTankValue);
			loveTankLevelText.text(str(Game.sharedGame().hubby.loveTankValue));
			
			update_career_stats();
			
			var salary = this.getElement("salary").getSprite();
			salaryText.text(str(Game.sharedGame().hubby.salary) + " GB");
			
			if(this.prevIsHome != Game.sharedGame().hubby.isHome()) {
				if(Game.sharedGame().hubby.isHome() == 0) {
					this.displayOut();
				}
				else {
					this.display();
				}
				
				this.prevIsHome = Game.sharedGame().hubby.isHome();
			}
			
			this.displayWorkBuffIcon();
			this.displayShoppingBuffIcon();
		}
	}
	
	public function display()
	{
		this.startHusbandAnimation();
		if (this.getElement("faceAnimation") != null) {
		    this.getElement("faceAnimation").getSprite().visible(1);
		}
		
		var sprite = this.getElement("hubby").getSprite();
		if (sprite != null) {
			sprite.texture(Game.sharedGame().hubby.getHusbandTexture());
		}
	}
	
	public function displayOut()
	{
		var sprite = this.getElement("hubby").getSprite();
		
		if(sprite == null) return;

		this.stopHusbandAnimation();
		if (this.getElement("faceAnimation")!= null) {
		    this.getElement("faceAnimation").getSprite().visible(0);
		}

		var occupation = Game.sharedGame().hubby.occupation;
		
		if(occupation == 0){
			sprite.texture("images/hubby-screen/executive-husband-cutout.png");
		}
		else if(occupation == 1){
			sprite.texture("images/hubby-screen/doctor-husband-cutout.png");
		}
		else if(occupation == 2){
			sprite.texture("images/hubby-screen/banker-husband-cutout.png");
		}
		else if(occupation == 3){
			sprite.texture("images/hubby-screen/sports-husband-cutout.png");
		}
		else if(occupation == 4){
			sprite.texture("images/hubby-screen/lawyer-husband-cutout.png");
		}
	}
	
	public function update_career_stats()
	{
		var distance = 624;
		var t = distance * Game.sharedGame().hubby.localVisits / Game.sharedGame().hubby.requiredVisits;
		if(t > 624) {
			t = 624;
		}
		
		careerStatusProgress.size(Game.translateX(t), Game.translateY(26));
		
		if(Game.sharedGame().hubby.localVisits == 0) {
			careerStatusProgress.size(0);
		}
		
		this.careerLevelText.setText(str(Game.sharedGame().hubby.careerLevel));
	}
	
	public function updateLoveTank(tank, value)
	{
		if(value <= 1) {
			tank.texture("images/hubby-screen/love-tank00.png");
		}
		else if(value <= 3) {
			tank.texture("images/hubby-screen/love-tank02.png");
		}
		else if(value <= 5) {
			tank.texture("images/hubby-screen/love-tank04.png");
		}
		else if(value <= 7) {
			tank.texture("images/hubby-screen/love-tank06.png");
		}
		else if(value <= 9) {
			tank.texture("images/hubby-screen/love-tank08.png");
		}
		else {
			tank.texture("images/hubby-screen/love-tank10.png");
		}
	}
	
	public function updateStressMeter(meter, value)
	{
		if(value <= 5) {
			meter.texture("images/hubby-screen/stress-meter1.png");
		}
		else if(value <= 9) {
			meter.texture("images/hubby-screen/stress-meter2.png");
		}
		else {
			meter.texture("images/hubby-screen/stress-meter3.png");
		}
	}
	
}
