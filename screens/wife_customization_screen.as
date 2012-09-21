/*****************************************************************************
filename    wife_customization_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen

class WifeCustomizationScreen extends Screen
{
    var background;
    var sliderStartPosition;
    var sliderEndPosition;
    var body;
    var rightArm;
    var leftArm;

    public function WifeCustomizationScreen()
    {
        super();
    }

   override public function gotFocus()
    {
        Game.hideBanner();
        this.stopWifeAnimation();
        Game.sharedGame().wife.dress(this);
    }

    override public function lostFocus()
    {
        Game.hideBanner();
        this.stopWifeAnimation();
    }

    public function stopWifeAnimation()
    {
        this.getElement("rightArm").getSprite().stop();
        this.getElement("leftArm").getSprite().stop();
        this.getElement("rightArmSleeve").getSprite().stop();
        this.getElement("leftArmSleeve").getSprite().stop();
        this.getElement("face").getSprite().stop();
    }

    override public function build()
    {
    }

    // 0 - HairStyle, 1 - HairColor, 2 - SkinTone
    public function displayCustomizationFrame(frame)
    {
        var hairStyleContainer = this.getElement("hairStyleContainer").getSprite();
        var hairColorContainer = this.getElement("hairColorContainer").getSprite();
        var skinToneContainer = this.getElement("skinToneContainer").getSprite();

        if(frame == 0) // Hair Style
        {
            hairStyleContainer.visible(1);
            hairColorContainer.visible(0);
            skinToneContainer.visible(0);

            updateHairStyleSelection();
        }
        else if(frame == 1) // Hair Color
        {
            hairStyleContainer.visible(0);
            hairColorContainer.visible(1);
            skinToneContainer.visible(0);
        }
        else if(frame == 2) // Skin Tone
        {
            hairStyleContainer.visible(0);
            hairColorContainer.visible(0);
            skinToneContainer.visible(1);
        }

    }

    public function updateHairStyleSelection()
    {
        var hairstyle01b = this.getElement("hairstyle01b").getSprite();
        var hairstyle01f = this.getElement("hairstyle01f").getSprite();
        var hairstyle02b = this.getElement("hairstyle02b").getSprite();
        var hairstyle02f = this.getElement("hairstyle02f").getSprite();
        var hairstyle03b = this.getElement("hairstyle03b").getSprite();
        var hairstyle03f = this.getElement("hairstyle03f").getSprite();
        var hairstyle04b = this.getElement("hairstyle04b").getSprite();
        var hairstyle04f = this.getElement("hairstyle04f").getSprite();
        var hairstyle05b = this.getElement("hairstyle05b").getSprite();
        var hairstyle05f = this.getElement("hairstyle05f").getSprite();
        var hairstyle06b = this.getElement("hairstyle06b").getSprite();
        var hairstyle06f = this.getElement("hairstyle06f").getSprite();

        var hairType = Game.sharedGame().wife.getHairType();
        var hairColor = Game.sharedGame().wife.getHairColor();

        var base = "images/customize-wife/6HairStyles/";
        hairstyle01b.texture(base + hairType + hairColor + "Back" + "01.png");
        hairstyle01f.texture(base + hairType + hairColor + "Front" + "01.png");
        hairstyle02b.texture(base + hairType + hairColor + "Back" + "02.png");
        hairstyle02f.texture(base + hairType + hairColor + "Front" + "02.png");
        hairstyle03b.texture(base + hairType + hairColor + "Back" + "03.png");
        hairstyle03f.texture(base + hairType + hairColor + "Front" + "03.png");
        hairstyle04b.texture(base + hairType + hairColor + "Back" + "04.png");
        hairstyle04f.texture(base + hairType + hairColor + "Front" + "04.png");
        hairstyle05b.texture(base + hairType + hairColor + "Back" + "05.png");
        hairstyle05f.texture(base + hairType + hairColor + "Front" + "05.png");
        hairstyle06b.texture(base + hairType + hairColor + "Back" + "06.png");
        hairstyle06f.texture(base + hairType + hairColor + "Front" + "06.png");
    }

    public function setSliderStartingPosition(newPosition)
    {
        this.sliderStartPosition = newPosition;
    }

    public function slideSkinToneSlider(newPosition)
    {
        trace("slide skin tone slider");
        this.sliderEndPosition = newPosition;
        trace(str(this.sliderStartPosition));

        var slider = this.getElement("slider").getSprite();
        var dist = this.sliderEndPosition - this.sliderStartPosition;

        // adjust position based on distance moved
        var posX = slider.pos()[0];
        var posY = slider.pos()[1];
        slider.pos(posX + dist, posY);

        // clamp
        if(slider.pos()[0] < 0) {
            slider.pos(0, posY);
        }

        if(slider.pos()[0] > Game.translateX(545)) {
            slider.pos(Game.translateX(545), posY);
        }

        if(slider.pos()[0] >= 0 && slider.pos()[0] < Game.translateX(50)) {
            this.body.color(40, 25, 12);
            this.rightArm.color(40, 25, 12);
            this.leftArm.color(40, 25, 12);
        }
        else if(slider.pos()[0] >= Game.translateX(50) && slider.pos()[0] < Game.translateX(150)) {
            this.body.color(55, 40, 29);
            this.rightArm.color(55, 40, 29);
            this.leftArm.color(55, 40, 29);
        }
        else if(slider.pos()[0] >= Game.translateX(150) && slider.pos()[0] < Game.translateX(250)) {
            this.body.color(70, 54, 40);
            this.rightArm.color(70, 54, 40);
            this.leftArm.color(70, 54, 40);
        }
        else if(slider.pos()[0] >= Game.translateX(250) && slider.pos()[0] < Game.translateX(350)) {
            this.body.color(100, 86, 68);
            this.rightArm.color(100, 86, 68);
            this.leftArm.color(100, 86, 68);
        }
        else if(slider.pos()[0] >= Game.translateX(350) && slider.pos()[0] < Game.translateX(500)) {
            this.body.color(100, 91, 74);
            this.rightArm.color(100, 91, 74);
            this.leftArm.color(100, 91, 74);
        }
        else if(slider.pos()[0] >= Game.translateX(500) && slider.pos()[0] <= Game.translateX(595)) {
            this.body.color(100, 94, 85);
            this.rightArm.color(100, 94, 85);
            this.leftArm.color(100, 94, 85);
        }

        Game.sharedGame().wife.skinTone[0] = this.body.color()[0];
        Game.sharedGame().wife.skinTone[1] = this.body.color()[1];
        Game.sharedGame().wife.skinTone[2] = this.body.color()[2];

        this.showTutorialStep(3);
    }

    public function getSkinTone()
    {
        this.body = this.getElement("body").getSprite();
        this.leftArm = this.getElement("leftArm").getSprite();
        this.rightArm = this.getElement("rightArm").getSprite();

        Game.sharedGame().wife.skinTone[0] = 100;
        Game.sharedGame().wife.skinTone[1] = 86;
        Game.sharedGame().wife.skinTone[2] = 68;
    }

    public function setCheckMark(checkMarkName, idx)
    {
        for(var i = 1; i <= 6; i++) {
            if(idx == i) {
                this.getElement(checkMarkName + str(i)).getSprite().visible(1)
            }
            else {
                this.getElement(checkMarkName + str(i)).getSprite().visible(0)
            }
        }
    }

    public function setHairStyleCheckmark(idx)
    {
        this.setCheckMark("checkHairStyle", idx);
    }

    public function setHairColorCheckmark(idx)
    {
        this.setCheckMark("checkHairColor", idx);
    }
}
