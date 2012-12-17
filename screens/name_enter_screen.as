/*****************************************************************************
filename    name_enter_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class NameEnterScreen extends Screen
{
	var textInput;
	var text;
	var isWife; // 1 - wife, 0 - hubby
	
	public function NameEnterScreen()
	{
		super();
		
		this.text = "";
	}
	
	public function getText()
	{
		return this.text;
	}
	
	override public function build()
	{
		if(this.isWife == 1) {
			Game.sharedGame().wife.dress(this);
		}
		else if(this.isWife == 0) {
			this.getElement("husband").getSprite().texture(Game.sharedGame().hubby.getHusbandTexture());
			this.startHusbandAnimation();
		}
	}

	public function startHusbandAnimation()
	{
		var husband = Game.sharedGame().hubby;
		var faceSprite = this.getElement("faceAnimation").getSprite();
		var action = Game.animations.getAnimation(husband.getHusbandAnimation());
		faceSprite.stop();
		faceSprite.addaction(repeat(action));		
	}

	public function stopWifeAnimation()
    {
        this.getElement("rightArm").getSprite().stop();
        this.getElement("leftArm").getSprite().stop();
        this.getElement("rightArmSleeve").getSprite().stop();
        this.getElement("leftArmSleeve").getSprite().stop();
        this.getElement("face").getSprite().stop();
    }

	override public function destroy()
	{
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
		/*
		var vf = v_font(Game.translateFontSize(30), "arial", FONT_NORMAL);
		this.textInput = v_create(V_INPUT_VIEW, Game.translateX(353), Game.translateY(110), Game.translateX(562), Game.translateY(100)); 
		this.textInput.attr(ATTR_FONT, vf);
		this.textInput.attr(ATTR_INPUT_MAX, 10);
		v_root().addview(this.textInput);
		this.textInput.text(this.text);
		*/
		if(this.isWife == 0) {
			this.startHusbandAnimation();
		}
	}
	
	override public function lostFocus()
	{
		trace("############ name enter screen lost focus");
		
		return;
		
		Game.hideBanner();
		if (len(this.textInput.text())>=11) {
		    this.text = substring(this.textInput.text(), 0, 10);
		} else {
		    this.text = this.textInput.text();
		}
		this.controller.nameChanged(this.text);
		this.textInput.removefromparent();
		this.stopHusbandAnimation();
		this.stopWifeAnimation();
	}

	public function stopHusbandAnimation()
	{
		this.getElement("faceAnimation").getSprite().stop();
	}
}

interface INameEnterController
{
	public function nameChanged(name) {}
}
