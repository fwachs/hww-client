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
			this.getElement("husband").getSprite().visible(1);
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
		
		this.textInput = new TextField(Game.translateX(30), Game.translateY(90), Game.translateX(562), Game.translateY(100));
		this.getElement("frame").getSprite().add(this.textInput);
		this.textInput.text(this.text);
		
		if(this.isWife == 0) {
			this.startHusbandAnimation();
		}
		
		this.text.focus();
	}
	
	override public function lostFocus()
	{
		trace("############ name enter screen lost focus");
		
		Game.hideBanner();
		if (len(this.textInput.text())>=11) {
		    this.text = this.textInput.text().substring(0, 10);
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
