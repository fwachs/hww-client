/*****************************************************************************
filename    isocanvas.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.isometric_item
import framework.isometric_tile

class IsometricCanvas extends Scroll
{
	var cols;
	var rows;
	var tileWidth;
	var tileHeight;
	var tileAspect;
	var tiles;
	var posLabel;
	var prevLighted;
	var addingItem;
	var items;
	var selectedItem = null;
	var screen;
	var prevLeft = 0;
	var prevTop = 0;
	
	static public function newCanvasFromAttributes(attrs)
	{
		var canvas = new IsometricCanvas(int(attrs.get("left")), int(attrs.get("top")), 
										int(attrs.get("cols")), int(attrs.get("rows")), 
										int(attrs.get("tileWidth")), int(attrs.get("tileHeight")), 
										int(attrs.get("width")), int(attrs.get("height")));
		canvas.attrs = attrs;	
		canvas.container.texture("images/" + attrs.get("resource"));
		
		return canvas;
	}
	
	public function IsometricCanvas(left, top, cols, rows, tileWidth, tileHeight, width, height)
	{
		super(left, top, width, height);
		
		this.cols = rows;
		this.rows = cols;
		this.tileWidth = Game.translateX(tileWidth);
		this.tileHeight = Game.translateY(tileHeight);
		
		this.addingItem = null;
		
		this.items = new Array();
	}

	override public function removeFromParent()
	{
		var sprt = this.container;
		var parentSprite = sprt.parent();
		
		Event.removeEventsForHandler(sprt);
		parentSprite.remove(sprt);

		Control.controlsCount--;
		trace("IsometricCanvas removed. Controls count: ", Control.controlsCount);

		this.destroyItems();
		this.destroyTiles();
	}
	
	public function createTiles()
	{
		this.tiles = new Array();
		
		var centerY = 26;
		var centerX = 13;
		var areaWidth = 16;
		var areaHeight = 16;
		var fromY = centerY - areaHeight / 2;
		var toY = fromY + areaHeight;
		var fromX = centerX - areaWidth / 2;
		var toX = fromX + areaWidth;
		var cols = this.cols;
				
		for(var y = 0; y < this.rows; y++ ) {
			var r = new Array();
			this.tiles.append(r);
			
			for(var x = 0; x < cols; x++) {
				var tile = new IsometricTile(x, y, this.tileWidth, this.tileHeight);
				tile.occupied = 0;
				tile.calcPosition(cols);
				
//				if(x >= fromX && x <= toX && y >= fromY && y <= toY) {
//					tile.addToCanvas(this);
//				}

				r.append(tile);
			}
		}	

//		this.posLabel = this._sprite.addlabel("0 0", "Arial", 16);
		
		var bottomTile = this.tiles[this.rows - 1][this.cols - 1];
		var rightTile = this.tiles[this.rows - 1][0];
		this.setContentSize(Game.untranslate(rightTile.left + this.tileWidth), Game.untranslate(bottomTile.top + this.tileHeight));
		this.setZoomLimits(60, 100);
	}
	
	function viewPortChanged(left, top, width, height)
	{		
		if(abs(left - this.prevLeft) > 20 || abs(top - this.prevTop) > 20) {
			this.prevLeft = left;
			this.prevTop = top;
		
			IsoCanvasNative.viewPortChanged(this, left, top, width, height);
		}
	}
	
	public function destroyTiles()
	{
		for(var y = 0; y < this.rows; y++ ) {
			for(var x = 0; x < this.cols; x++) {
				this.tiles[y][x].destroy();
				this.tiles[y][x] = null;
			}

			this.tiles[y] = null;
		}	
	}
	
	public function destroyItems()
	{
		for(var n = 0; n < len(this.items); n++) {
			var item = this.items[n];
			
			var itemSprite = item.getSprite();
			itemSprite.removefromparent();
			
			var tiles = item.tiles;
			for(var i = 0; i < len(tiles); i++) {
				tiles[i].removeItem();
			}
			
			item.destroy();
		}

		this.items.clear();
		this.items = null;
	}
	
	public function getTile(x, y)
	{
		if(x >= this.cols || y >= this.rows) return null;
		
		return this.tiles[y][x];
	}
	
	public function unselectSelectedItem()
	{
		if(this.selectedItem != null) {
			this.selectedItem.unselect();
			this.selectedItem = null;
		}
	}
	
	public function selectItem(item)
	{
		if(this.addingItem != null) return 0;
		
		this.cancelAdding();
		this.unselectSelectedItem();
				
		this.selectedItem = item;
		this.selectedItem.toggleEditingUI();

		if(this.controller) {
			this.controller.itemTapped(item);
		}
		
		return 1;
	}
	
	public function acceptItem(item)
	{
		this.addingItem = null;

		if(this.controller) {
			this.controller.itemAccepted(item);
		}
	}
	
	public function cancelAdding()
	{
		trace("cancelAdding before");
		if(this.addingItem != null) {
			trace("Cancel adding: ", this.addingItem);
			this.removeItem(this.addingItem);
			this.addingItem = null;
		}
	}
	
	public function removeItem(item)
	{
		trace("removing item", item);

		this.liftItem(item);

		this.items.remove(item);
		
		if(this.controller) {
			this.controller.itemRemoved(item);
		}

		item.destroy();
	}
	
	public function liftItem(item)
	{
		var tiles = item.tiles;
		for(var i = 0; i < len(tiles); i++) {
			tiles[i].removeItem();
		}
	}
	
	public function addItem(item, x, y)
	{		
		trace("Adding item: ", item, x, y, item.getSprite());
		this.unselectSelectedItem();
		
		var itemSprite = item.getSprite();
		
		var z = this.placeItem(item, x, y)	
				
		this.items.append(item);
	}
	
	public function newItem(item, x, y)
	{
		this.addingItem = item;
		this.addItem(item, x, y);
		item.setCanvas(this);
		item.toggleEditingUI();			
		//this.reorganize();
	}
	
	public function placeItem(item, x, y)
	{	
		trace("Place item: ", x, y);
			
		var tile = this.tiles[y][x];
		
		var itemSprite = item.getSprite();
		var itemWidth = itemSprite.size()[0];
		var itemHeight = itemSprite.size()[1];
	
		var x1000 = x * 1000;
		var y1000 = y * 1000;
		var itemWidth1000 = item.width * 1000;
		var itemDepth1000 = item.depth * 1000;		
		var z = (x1000 * 4 - itemWidth1000 / 2 + y1000 * 4 - itemDepth1000 / 2) + 100000;
				
		var left = tile.left + tile.width - itemWidth + ((5 * item.depth - 5) * tile.width) / 10;
		var top = tile.top + tile.height - itemHeight;
		
		item.left = left;
		item.top = top;
		item.z = z;
		item.xpos = x;
		item.ypos = y;
		
		this.setTilesForItem(item, x, y);
		
//		var parent = itemSprite.parent();
//		itemSprite.removefromparent();
//		parent.add(itemSprite, z);
		
		itemSprite.pos(left, top);

//		trace("addItemToMap: ", left, top, z, tile.left, tile.top);
		
		return z;
	}
	
	public function isInFrontOf(aItem, bItem)
	{
//		trace("Checking: ", aItem.ypos, (bItem.ypos - bItem.width + 1), bItem.ypos, (aItem.ypos - aItem.width + 1));
		if
			( 
				(aItem.ypos >= (bItem.ypos - bItem.width + 1) && bItem.ypos >= (aItem.ypos - aItem.width + 1))
				||
				(bItem.ypos >= (aItem.ypos - aItem.width + 1) && aItem.ypos >= (bItem.ypos - bItem.width + 1))
			) 
		{
			if(bItem.xpos > aItem.xpos) {
				return 1;
			}
			else {
				return 0;
			}
		}
		else if
			(
				(aItem.xpos >= (bItem.xpos - bItem.depth + 1) && bItem.xpos >= (aItem.xpos - aItem.depth + 1))
				||
				(bItem.xpos >= (aItem.xpos - aItem.depth + 1) && aItem.xpos >= (bItem.xpos - bItem.depth + 1))
			) 
		{
			if(bItem.ypos > aItem.ypos) {
				return 1;
			}
			else {
				return 0;
			}
		}
		else {
			if((aItem.xpos - aItem.depth + 1 + aItem.ypos - aItem.width + 1) < (bItem.xpos + bItem.ypos)) {
				return 1;
			}
			else {
				return 0;
			}
		}	
	}
	
	public function stopSort()
	{
		this.getSprite().cancelSort(1);
	}
	
	public function startFastSort()
	{
		if(len(this.items) == 0) return;
		
		this.items.sortArray(this.isInFrontOf);

		var z = 50000;		
		var parent = this.getSprite();
		
		for(var i = len(this.items) - 1; i >= 0 ; i--) {
			var item = this.items[i];
			var itemSprite = item.getSprite();
			//var parent = itemSprite.parent();
			itemSprite.removefromparent();
			parent.add(itemSprite, z, 0);
//			itemSprite.remove(item.text);
//			item.text = itemSprite.addlabel(str(z), "Arial", 30);
			item.z = z;

			z++;
		}
    }
	
	public function startBubbleSort()
	{
		IsoCanvasNative.isometricSort(this.items);

		var z = 500000;
		
		var parent = this.getSprite();
		for(var i = 0; i < len(this.items); i++) {
			var item = this.items[i];
			var itemSprite = item.getSprite();
			itemSprite.removefromparent();
			parent.add(itemSprite, z);
			item.z = z;

			z--;
		}
    }
	
	public function reorganize()
	{
		this.startBubbleSort();
	}
		
	public function setTilesForItem(item, tilex, tiley)
	{
		item.tiles = new Array();
		
		trace("Setting tiles for item ", tilex, tiley);
		
		for(var y = 0; y < item.width; y++) {
			for(var x = 0; x < item.depth; x++) {
				var tile = this.tiles[tiley - y][tilex - x];
				if(tile) {
					tile.occupied = 1;
					tile.item = item;
					item.tiles.append(tile);
				}
			}
		}		
	}
	
	public function tileFromPos(xpos, ypos)
	{
		trace("Tile from pos: ", xpos, ypos);
		
		var x = float(xpos);
		var y = float(ypos);
		
		var tileWidth = float(this.tileWidth);
		var tileHeight = float(this.tileHeight);
		var tileAspect = tileWidth / tileHeight;
		
		var mapTop = 20.0;
		var mapLeft = float(this.cols - 1) * (tileWidth / 2.0);
		
		//var ymouse = tileAspect.mul(y.sub(mapTop)).sub(x).add(mapLeft).div(tileAspect);
		var ymouse = (tileAspect * (y - mapTop) - x + mapLeft) / tileAspect;
		
		//var _ymouse = tileAspect.mul(y.sub(mapTop)).sub(x).add(mapLeft).div(new FPoint(2));
		var _ymouse = (tileAspect * (y - mapTop) - x + mapLeft) / 2.0;
		
		//var xmouse = x.add(_ymouse).sub(mapLeft).sub(tileWidth.div(tileAspect));
		var xmouse = x + _ymouse - mapLeft - tileWidth / tileAspect;
				
		//var xtile = ymouse.div(tileHeight);
		var xtile = ymouse / tileHeight;
		
		//var ytile = xmouse.div(tileWidth.div(new FPoint(2)));
		var ytile = xmouse / (tileWidth / 2.0);

		/*
		trace("x, y: ", x.integer(), y.integer(), " - ymouse, _ymouse, xmouse: ", ymouse.integer(), _ymouse.integer(), xmouse.integer(), " - xtile, ytile: ", xtile.round(), ytile.round());
		
		trace("Tile is:", xtile.round(), ytile.round());
		*/
		
		return new Array(round(xtile) + 1, round(ytile) + 1);
	}
	
	public function testPlacement(item, tileX, tileY)
	{
		for(var y = 0; y < item.width; y++) {
			for(var x = 0; x < item.depth; x++) {
				var tile = this.tiles[tileY - y][tileX - x];
				if(tile.occupied == 1 && tile.item != item) {
					this.makeTilesHighlight(item, tileX, tileY);
					
					c_invoke(this.clearHighlight, 2000, 0);
					
					return 0;
				}
			}
		}
		
		return 1;
	}
	
	public function placeOnTile(item, xpos, ypos)
	{		
		var i;
		var tilePos = this.tileFromPos(xpos, ypos);
	
		if(this.testPlacement(item, tilePos[0], tilePos[1]) == 0) return 0;
		
		/*
		for(var i = 0; i < len(this.prevLighted); i++) {
			var tile = this.prevLighted[i];
			if(tile.occupied == 1 && tile.item != item) {
				return 0;
			}
		}
		*/
		
		for(var i = 0; i < len(item.tiles); i++) {
			item.tiles[i].occupied = 0;
		}		
		
		item.tiles = this.prevLighted;
		
		this.placeItem(item, tilePos[0], tilePos[1]);
		
		if(this.controller) {
			if(item.isFlipped == 1) {
				this.controller.itemMoved(item, tilePos[0], tilePos[1]);
			}
			else {
				this.controller.itemMoved(item, tilePos[0], tilePos[1]);
			}
		}
		
		return 1;
	}
	
	public function highlightTiles(item, xpos, ypos)
	{	
		var tilePos = this.tileFromPos(xpos, ypos);

		this.makeTilesHighlight(item, tilePos[0], tilePos[1]);
	}
	
	public function makeTilesHighlight(item, xTile, yTile)
	{
		this.clearHighlight();
		
		this.prevLighted = new Array();
		
		for(var y = 0; y < item.width; y++) {
			for(var x = 0; x < item.depth; x++) {
				var tile = this.tiles[yTile - y][xTile - x];
				tile.lightUp(item);
				
				this.prevLighted.append(tile);
			}
		}		
	}
	
	public function clearHighlight()
	{
		if(this.prevLighted) {
			for(var i = 0; i < len(this.prevLighted); i++) {
				this.prevLighted[i].lightDown();
			}
		}
	}
	
	public function visibleTile()
	{
		var pos = this._sprite.pos();
		var size = this.container.size();
		
		return this.tileFromPos(-pos[0] + size[0] / 2, -pos[1] + size[1] / 2);
	}
	
	public function centerOnTile(x, y)
	{
		var tile = this.tiles[y][x];
		var size = this.container.size();
//		this._sprite.addaction(moveto(250, -tile.left + size[0] / 2, -tile.top + size[1] / 2));
		var newX = -tile.left + size[0] / 2;
		var newY = -tile.top + size[1] / 2;
		this._sprite.pos(newX, newY);
		this.viewPortChanged(-newX, -newY, size[0], size[1]);
	}
	
	public function tileTapped(tile)
	{
		if(this.controller) {
			this.controller.areaTapped(tile.area);
		}
	}	

	override public function translateEvent(event)
	{
		var pos = event.node.node2world(event.x, event.y);
		var newPos = this.getSprite().world2node(pos[0], pos[1]);
		
		var scrollPos = this.getSprite().pos();
		
		var newEvent = event.makeCopy();
//		newEvent.x = (pos[0] + abs(scrollPos[0])) * 100 / this.currentScale;
//		newEvent.y = (pos[1] + abs(scrollPos[1])) * 100 / this.currentScale;
		newEvent.x = newPos[0];
		newEvent.y = newPos[1];
		
		return newEvent;
	}
}

