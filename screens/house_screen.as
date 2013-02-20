/*****************************************************************************
filename    house_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.screen
import framework.profiler
import framework.isocanvas
import framework.runnable

class HouseScreen extends Screen
{
	var house;
	var style;
	var iso = null;
	
	public function HouseScreen(pHouse)
	{
		super();
		this.house = pHouse;
	}
	
	public function redrawIso()
	{		
		if(this.house.shouldDraw() == 0 && this.iso != null) return;
		
		if(this.iso != null) {
			this.rootNode.removeChild(this.iso);
		}
		
		this.iso = new IsometricCanvas(0, 0, this.house.cols, this.house.rows, 143, 82, 1280, 800);
		this.iso.attrs = dict([["z-index", "10"]]);
		
		this.rootNode.addChild(this.iso);
		this.addElement("map", this.iso);	
		
		this.buildCategories();

		this.setWalls();
		
		this.house.wasDrawn();
	}
		
	override public function gotFocus()
	{
		Game.showBanner(1, 0);
		
		this.style = this.house.selectedStyle;

		this.getElement("toolbarContainer").getSprite().visible(this.house.isEditable());
		this.redrawIso();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
	
	override public function build()
	{
	}

	public function setWalls()
	{		
		
		this.house.loadCustomTiles();		
		
		this.iso.createTiles();

		this.setBlueprint();	
		
		this.iso.controller = this.controller;
		this.iso.screen = this;

		this.setRooms();
		
		this.loadFurniture();
		
		this.iso.reorganize();
		
		this.iso.centerOnTile(13, 26);
	}
	
	public function setRooms()
	{
		for(var i = 0; i < len(this.house.rooms); i++) {
			var room = this.house.rooms[i];
			
			for(var j = 0; j < len(room.tiles); j++) {
				this.setTiles(room.tiles[j]);
			}
		}		
	}
	
	public function setBlueprint()
	{
		var tiles = new TilesGroup();
		tiles.width = 56;
		tiles.height = 34;
		tiles.row = 0;
		tiles.col = 0;
		
		var map = this.getElement("map");
		
		for(var r = 0; r < tiles.height; r++) {
			for(var c = 0; c < tiles.width; c++) {
				var row = r + tiles.row - 1;
				var col = c + tiles.col - 1;
				var t = iso.getTile(row, col);

				if(t != null) {
					var asset = this.house.blueprint.get(str(row) + "_" + str(col));
					if(asset != null) {
						t.setFlatResource("images/" + asset, 1, 1);
					}
					else {
						t.setFlatResource("images/furniture/blueprint/blue-print-mid-empty.png", 1, 1);
					}
				}
			}
		}
	}
	
	public function lockTiles(tiles)
	{
		var map = this.getElement("map");
		
		for(var r = 0; r < tiles.height; r++) {
			for(var c = 0; c < tiles.width; c++) {
				var row = r + tiles.row - 1;
				var col = c + tiles.col - 1;
				var t = iso.getTile(col, row);

				if(t != null) {
					t.occupied = 1;
				}
			}
		}
	}

	public function clearTiles(tiles)
	{
		var map = this.getElement("map");
		
		for(var r = 0; r < tiles.height; r++) {
			for(var c = 0; c < tiles.width; c++) {
				var row = r + tiles.row - 1;
				var col = c + tiles.col - 1;
				var t = iso.getTile(col, row);

				if(t != null) {
					t.clear();
				}
			}
		}
	}

	public function setTiles(tiles)
	{
		var styleItem = this.style.items.get(tiles.type);
		
		trace("setTiles: ", tiles.type);
		
		if(styleItem == null) return;

		var map = this.getElement("map");
				
		if(tiles.room.level > this.house.getLevel()) {
			this.lockTiles(tiles);
			return;			
		}

		this.clearTiles(tiles);
		
		var customTiles = this.house.customTiles.get(str(tiles.row) + str(tiles.col));		
		
		for(var r = 0; r < tiles.height; r += styleItem.width) {
			for(var c = 0; c < tiles.width; c += styleItem.depth) {
				var col;
				var row;
				var t;
				
				if(styleItem.floor == 1) {
					col = tiles.col + c - 1 + styleItem.width / 2;
					row = tiles.row + r - 1 + styleItem.depth / 2;
					t = iso.getTile(col, row);
				
					if(t != null) {
						if(customTiles) {
							t.setFlatResource("images/" + customTiles.furniture.image, styleItem.depth, styleItem.width);
						}
						else {
							t.setFlatResource("images/furniture/" + styleItem.resource, styleItem.depth, styleItem.width);
						}
					}
				}
				else {
					col = tiles.col + c - 1 + styleItem.depth / 2;
					row = tiles.row + r - 1 + styleItem.width / 2;
					t = iso.getTile(col, row);
					
					trace("setTiles pos:", col, row);
				
					if(t != null) {
						var res = "images/furniture/" + styleItem.resource;
						if(customTiles) {
							res = "images/" + customTiles.furniture.image;
						}
						
						t.area = tiles;
						var frnture = new IsometricItem(res, styleItem.width, styleItem.depth);
						frnture.isEditable = 0;
						map.addItem(frnture, col, row);
						if(styleItem.flip == 1) {
							frnture.flip();
						}
					}
				}
			}
		}
		
		for(var ro = 0; ro < tiles.height; ro++) {
			for(var co = 0; co < tiles.width; co++) {
				trace("Setting tile: ", tiles.col + co, tiles.row + ro);

				var to = iso.getTile(tiles.col + co, tiles.row + ro);
				if(to) {
					to.area = tiles;
				}
			}
		}

	}
	
	public function loadFurniture()
	{
		var map = this.getElement("map");
		var items = house.loadFurniture();
		for(var i = 0; i < len(items); i++) {
			var it = items[i];
			
			var f = it.furnitureType;
			var frnture = new IsometricItem("images/" + f.image, f.width, f.depth);
			frnture.ref = it;			
			frnture.isEditable = this.house.isEditable();
			
			trace("loadItem: ", f.image, f.width, f.depth, it.left, it.top);

			map.addItem(frnture, it.left, it.top);
			if(it.isFlipped == 1) {
				frnture.flipItem();
				frnture.isFlipped = 1;
			}
			
			frnture.hideAcceptButton();
		}
	}
	
	public function setFloor(tiles, furniture)
	{
		trace("Setting floor!!!", tiles, furniture);
		
		var map = this.getElement("map");
		
		for(var r = 0; r < tiles.height; r += furniture.width) {
			for(var c = 0; c < tiles.width; c += furniture.depth) {
				var col;
				var row;
				var t;
				
				col = tiles.col + c - 1 + furniture.width / 2;
				row = tiles.row + r - 1 + furniture.depth / 2;
				t = iso.getTile(col, row);
			
				if(t != null) {
					t.setFlatResource("images/" + furniture.image, furniture.depth, furniture.width);
				}
			}
		}
	}
	
	public function setPaint(tiles, furniture)
	{
		trace("Setting paint!!!", tiles.col, tiles.row, tiles.width, tiles.height, furniture);
		
		var map = this.getElement("map");
		
		for(var r = 0; r < tiles.height; r += furniture.width) {
			for(var c = 0; c < tiles.width; c += furniture.depth) {
				var col;
				var row;
				var t;
				
				col = tiles.col + c - 1 + furniture.width / 2 - 1;
				row = tiles.row + r - 1 + furniture.depth / 2 + 1;
				t = iso.getTile(col, row);
			
				if(t != null) {
					trace("changing image: ", t.item, col, row);
					
					t.item.changeImage("images/" + furniture.image);
				}
			}
		}
	}
	
	public function buildCategories()
	{
		var categories = Game.currentGame.furnitureCategories;
		
		var categoriesBar = this.getElement("categoryBar").getSprite();
		var left = 20;
		for(var i = 0; i < len(categories); i++) {
			var bg = sprite("images/house-decorator/primary-cat-item-box.png").pos(Game.translateX(left), Game.translateY( 100));
			categoriesBar.add(bg);
			
			var cat = categories[i];
			var item = sprite().pos(Game.translateX(left + 14), Game.translateY( 65));
			var catItem = sprite(cat.image).size(Game.translateX(70), Game.translateY( 70)).pos(Game.translateX(16), Game.translateY( 5));
			item.add(catItem);
			this.addEvent(item, "categoryTapped", cat, EVENT_UNTOUCH);
			this.addEvent(bg, "categoryTapped", cat, EVENT_UNTOUCH);
			categoriesBar.add(item);			
			
			left += 170;
		}
	}
	
	public function buildSubcategories(subcategories)
	{
		var subcategoriesBar = this.getElement("subCategoryFrame").getSprite();
		var subnodes = subcategoriesBar.subnodes();
		var n = len(subnodes);
		for(var t = 0; t < n; t++) {
			subcategoriesBar.remove(t);			
		}
		
		var left = 20;
		for(var i = 0; i < len(subcategories); i++) {
			var cat = subcategories[i];
			var item = sprite("images/house-decorator/sub-cat-box.png").pos(Game.translateX(left), Game.translateY( 25));
			item.addsprite(cat.image).size(Game.translateX(70), Game.translateY( 70)).pos(Game.translateX(25), Game.translateY( 5));
			this.addEvent(item, "subcategoryTapped", cat, EVENT_UNTOUCH);
			subcategoriesBar.add(item, 0, i);
			
			left += 170;
		}
	}
	
	public function buildFurnitureList(items)
	{
		var furnitureBar = this.getElement("itemsFrame");		
		furnitureBar.removeAllChildren();		
				
		var left = 20;
		for(var i = 0; i < len(items); i++) {
			var furniture = items[i];		

			var itemParams = dict();
			itemParams.update("left", str(left));
			itemParams.update("name", furniture.name);
			itemParams.update("resource", furniture.image);
			itemParams.update("gamebucks", furniture.gameBucks);
			itemParams.update("diamonds", furniture.diamonds);
			itemParams.update("level", furniture.level);

			if(furniture.stars < 1) {
				itemParams.update("star_1_full", "no");
			}
			if(furniture.stars < 2) {
				itemParams.update("star_2_full", "no");
			}
			if(furniture.stars < 3) {
				itemParams.update("star_3_full", "no");
			}
				
			var template = "FurnitureItem";
			if(furniture.level > Game.sharedGame().hubby.careerLevel) {
				template = "LockedFurnitureItem";
			}
			
//			c_invoke(this.asyncItemLoad, i * 300, [template, itemParams, furniture]);
			
			var item = this.controlFromXMLTemplate(template, itemParams, "furniture-item.xml");
			item.tapEvent.argument = furniture;

			furnitureBar.addChild(item);
			
			left += 200;
		}
		
		this.getElement("itemsFrame").setContentSize(left, furnitureBar.getSprite().size()[1]);
	}
	
	public function asyncItemLoad(firingTimer, tick, args)
	{
		var furnitureBar = this.getElement("itemsFrame");
		
		var item = this.controlFromXMLTemplate(args[0], args[1], "furniture-item.xml");
		item.tapEvent.argument = args[2];

		furnitureBar.addChild(item);
	}
	
	public function buildStorageList(items)
	{
		var furnitureBar = this.getElement("storageScroll");
		furnitureBar.removeAllChildren();
				
		var left = 20;
		for(var i = 0; i < len(items); i++) {
			var it = items[i];
			var furniture = it.furnitureType;
			
			var itemXML = 
				"<screen:element name=\"furnitureItem\" resource=\"house-decorator/item-box-store.png\" left=\"" + str(left) + "\" top=\"15\" width=\"183\" height=\"176\" ontap=\"storageTapped\">" +
		    	"	<screen:element name=\"itemI\" resource=\"" + furniture.image + "\" left=\"15\" top=\"15\" width=\"150\" height=\"150\"/>" +
				"</screen:element>";
			var item = this.controlFromXMLString(itemXML);
			item.tapEvent.argument = it;
			furnitureBar.addChild(item);

			itemXML = "<screen:element name=\"sellI\" resource=\"house-decorator/sell-item-solo.png\" left=\"" + str(left + 110) + "\" top=\"122\" ontap=\"sellItem:" + str(it.getId()) + "\"/>";
			item = this.controlFromXMLString(itemXML);
			furnitureBar.addChild(item);			
			
			left += 200;
		}
		
		this.getElement("storageScroll").setContentSize(left, furnitureBar.getSprite().size()[1]);
	}	

	public function showDecorator()
	{
		var container = this.getElement("categoryFrame").getSprite();		
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 619)));
		
		this.getElement("cancelButton").getSprite().visible(1);
	}
	
	public function hideDecorator()
	{
		var container = this.getElement("categoryFrame").getSprite();		
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 800)));

		this.getElement("cancelButton").getSprite().visible(0);
	}
	
	public function showSubcategories()
	{
		var container = this.getElement("categoryFrame").getSprite();
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 484)));		
	}
	
	public function showItems()
	{
		var container = this.getElement("categoryFrame").getSprite();
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 232)));		
	}

	public function showStorage()
	{
	
		var container = this.getElement("storageFrame").getSprite();		
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 591)));
		
		this.getElement("cancelStorage").getSprite().visible(1);
	}
	
	public function hideStorage()
	{
		var container = this.getElement("storageFrame").getSprite();		
		container.addaction(moveto(250, Game.translateX( 0), Game.translateY( 800)));

		this.getElement("cancelStorage").getSprite().visible(0);
	}
}
