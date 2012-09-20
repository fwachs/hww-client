/*****************************************************************************
filename    husband_selection_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen
import screens.carousel

class HusbandSelectionScreen extends Screen
{
	var carousel;
	
	public function HusbandSelectionScreen()
	{
		super();
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
	
	override public function build()
	{
		this.carousel = new Carousel("hubby");
		this.carousel.addElement(this.getElement("executiveHubby").getSprite(),   0);
		this.carousel.addElement(this.getElement("doctorHubby").getSprite(),     72);
		this.carousel.addElement(this.getElement("bankerHubby").getSprite(),    144);
		this.carousel.addElement(this.getElement("athleteHubby").getSprite(), 	216);
		this.carousel.addElement(this.getElement("lawyerHubby").getSprite(),   	288);
	}
	
	public function updateSelection(husbandType)
	{
		var wifeTypeBox1 = this.getElement("wifeTypeBox1").getSprite();
		var wifeTypeBox2 = this.getElement("wifeTypeBox2").getSprite();
		var wifeTypeBox3 = this.getElement("wifeTypeBox3").getSprite();
		var wifeTypeBox4 = this.getElement("wifeTypeBox4").getSprite();
		var wifeTypeBox5 = this.getElement("wifeTypeBox5").getSprite();
		
		// reset boxes
		wifeTypeBox1.texture("images/wife-selection-screen/wife-type-box.png");
		wifeTypeBox2.texture("images/wife-selection-screen/wife-type-box.png");
		wifeTypeBox3.texture("images/wife-selection-screen/wife-type-box.png");
		wifeTypeBox4.texture("images/wife-selection-screen/wife-type-box.png");
		wifeTypeBox5.texture("images/wife-selection-screen/wife-type-box.png");
		
		if(husbandType == 0) {
			wifeTypeBox1.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(husbandType);
			Game.currentGame.hubby.type = "Executive";
			return husbandType;
		}
		else if(husbandType == 1) {
			wifeTypeBox2.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(husbandType);
			Game.currentGame.hubby.type = "Doctor";
			return husbandType;
		}
		else if(husbandType == 2) {
			wifeTypeBox3.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(husbandType);
			Game.currentGame.hubby.type = "Banker";
			return husbandType;
		}
		else if(husbandType == 3) {
			wifeTypeBox4.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(husbandType);
			Game.currentGame.hubby.type = "Athlete";
			return husbandType;
		}
		else if(husbandType == 4) {
			wifeTypeBox5.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(husbandType);
			Game.currentGame.hubby.type = "Lawyer";
			return husbandType;
		}
	}
}
