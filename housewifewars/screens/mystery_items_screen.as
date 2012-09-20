/*****************************************************************************
filename    mystery_items_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.screen

class MysteryItemsScreen extends Screen
{	
	public function MysteryItemsScreen()
	{
		super();
	}
	
	override public function build()
	{
		this.getElement("background").getSprite().size(Game.translateX(1280), Game.translateY(800));
		this.displayMysteryItems();
	}
	
	public function displayMysteryItems()
	{
		var mysteryItemCatalog = this.getElement("mysteryItemCatalog");
		var leftStart = 70;
		var left = leftStart;
		var top = 65;
		var mysteryItemsCount = len(Game.sharedGame().mysteryItems);
		
		var shelfStart = this.controlFromXMLString("<screen:element name=\"\" resource=\"mystery-items/mystery-bg-shelf.png\" left=\"-30\" top=\"103\" z-index=\"25\"/>");
		mysteryItemCatalog.addChild(shelfStart);
		
		for(var i = 0; i < mysteryItemsCount; ) {
				
			for(var row = 0; row < 3; row++) {
			
				for(var col = 0; col < 7; col++) {
					if(i < mysteryItemsCount) {
						var item = Game.sharedGame().mysteryItems[i];
						i++;
						var itemImage = ""; //"friend-belt/friendbelt-question.png";
						var itemName = ""; //"?????";
						var imageLeft = 16;
						var imageTop = 16;
						
						if(Game.sharedGame().wife.mysteryItemCollection.has_key(item.id) == 1) {
							itemImage = item.image;
							itemName = item.desc;
							imageLeft = 6;
							imageTop = 6;
						}
						
						var params = dict();
						params.update("itemImage", itemImage);
						params.update("left", str(left));
						params.update("top", str(top));
						params.update("imageLeft", str(imageLeft));
						params.update("imageTop", str(imageTop));
						params.update("itemName", itemName);
						var property = this.controlFromXMLTemplate("MysteryItem", params, "mystery-item.xml");
						
						mysteryItemCatalog.addChild(property);
						left += 155;
					}
				}
				
				left = leftStart;
				top += 220;
			}
			
			// new page
			leftStart += 1170;
			left = leftStart;
			top = 65;
			
			var newShelf = this.controlFromXMLString("<screen:element name=\"\" resource=\"mystery-items/mystery-bg-shelf.png\" left=\"0\" top=\"0\" z-index=\"25\"/>");
			newShelf._sprite.pos(Game.translateX(left - 110), Game.translateY(103));
			mysteryItemCatalog.addChild(newShelf);
		}
		
		this.getElement("mysteryItemCatalog").setContentSize(3840, 700);
	}
}
