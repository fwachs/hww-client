/*****************************************************************************
filename    wife_selection_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen
import screens.carousel

class WifeSelectionScreen extends Screen
{
	var background;
	var carousel;
	
	public function WifeSelectionScreen()
	{
		super();
	}
	
	override public function build()
	{
		this.carousel = new Carousel("wife");
		this.carousel.addElement(this.getElement("modernWife").getSprite(),     0);
		this.carousel.addElement(this.getElement("retroWife").getSprite(),     72);
		this.carousel.addElement(this.getElement("celebWife").getSprite(),    144);
		this.carousel.addElement(this.getElement("businessWife").getSprite(), 216);
		this.carousel.addElement(this.getElement("rockerWife").getSprite(),   288);
	}
	
	public function updateSelection(wifeType)
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
		
		if(wifeType == 0) {
			wifeTypeBox1.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(wifeType);
			Game.currentGame.wife.type = "Modern";
		}
		else if(wifeType == 1) {
			wifeTypeBox4.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(wifeType);
			Game.currentGame.wife.type = "Retro";
		}
		else if(wifeType == 2) {
			wifeTypeBox5.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(wifeType);
			Game.currentGame.wife.type = "Celeb";
		}
		else if(wifeType == 3) {
			wifeTypeBox3.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(wifeType);
			Game.currentGame.wife.type = "Business";
		}
		else if(wifeType == 4) {
			wifeTypeBox2.texture("images/wife-selection-screen/wife-type-highlight.png");
			this.carousel.rotateToIndex(wifeType);
			Game.currentGame.wife.type = "Rocker";
		}
	}	
}
