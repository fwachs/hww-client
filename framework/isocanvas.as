/*****************************************************************************
filename    isocanvas.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

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
		trace("IsometricCanvas removed. Controls count: ", Control.controlsCount, ", nodes count: ", sysinfo(24));

		this.destroyItems();
		this.destroyTiles();
	}
	
	public function createTiles()
	{
		this.tiles = new Array();
				
		for(var y = 0; y < this.rows; y++ ) {
			var r = new Array();
			this.tiles.append(r);
			
			for(var x = 0; x < this.cols; x++) {
				var i = y * this.cols + x;
			
				var tile = new IsometricTile(x, y, this.tileWidth, this.tileHeight);
				tile.occupied = 0;
				tile.addToCanvas(this);
				
				r.append(tile);
			}
		}	

//		this.posLabel = this._sprite.addlabel("0 0", "Arial", 16);
		
		var bottomTile = this.tiles[this.rows - 1][this.cols - 1];
		var rightTile = this.tiles[this.rows - 1][0];
		this.setContentSize(Game.untranslate(rightTile.left + this.tileWidth), Game.untranslate(bottomTile.top + this.tileHeight));
		this.setZoomLimits(60, 100);
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
		this.getSprite().add(itemSprite, 999999);
		
		item.setCanvas(this);
				
		this.items.append(item);
	}
	
	public function newItem(item, x, y)
	{
		this.addingItem = item;
		this.addItem(item, x, y);
		item.toggleEditingUI();			
		this.reorganize();
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
	
	public function startBubbleSort()
	{
		var swapped = 1;
		var j = 0;
		var tmp;
		while(swapped == 1) {
		    swapped = 0;
		    j++;
		    for(var i = 0; i < len(this.items) - j; i++) {                                       
				if(this.isInFrontOf(this.items[i], this.items[i + 1]) == 1) {
	                tmp = this.items[i];
	                this.items[i] = this.items[i + 1];
	                this.items[i + 1] = tmp;
	                swapped = 1;
				}
		    }                
		}

		var z = 500000;
		
		for(i = 0; i < len(this.items); i++) {
			var item = this.items[i];
			var itemSprite = item.getSprite();
			var parent = itemSprite.parent();
			itemSprite.removefromparent();
			parent.add(itemSprite, z);
			itemSprite.remove(item.text);
//			item.text = itemSprite.addlabel(str(z), "Arial", 30);
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
				tile.occupied = 1;
				tile.item = item;
				item.tiles.append(tile);				
			}
		}		
	}
	
	public function tileFromPos(xpos, ypos)
	{
		trace("Tile from pos: ", xpos, ypos);
		
		var x = new FixedPoint(xpos);
		var y = new FixedPoint(ypos);
		
		var tileWidth = new FixedPoint(this.tileWidth);
		var tileHeight = new FixedPoint(this.tileHeight);
		var tileAspect = tileWidth.div(tileHeight);
		
		var mapTop = new FixedPoint(20);
		var mapLeft = new FixedPoint(this.cols - 1).mul(tileWidth.div(new FixedPoint(2)));
		
		var ymouse = tileAspect.mul(y.sub(mapTop)).sub(x).add(mapLeft).div(tileAspect);
		
		var _ymouse = tileAspect.mul(y.sub(mapTop)).sub(x).add(mapLeft).div(new FixedPoint(2));
		
		var xmouse = x.add(_ymouse).sub(mapLeft).sub(tileWidth.div(tileAspect));
				
		var xtile = ymouse.div(tileHeight);
		
		var ytile = xmouse.div(tileWidth.div(new FixedPoint(2)));

		trace("x, y: ", x.integer(), y.integer(), " - ymouse, _ymouse, xmouse: ", ymouse.integer(), _ymouse.integer(), xmouse.integer(), " - xtile, ytile: ", xtile.round(), ytile.round());
		
		trace("Tile is:", xtile.round(), ytile.round());
		
		return new Array(xtile.round(), ytile.round());
	}
	
	public function testPlacement(item, tileX, tileY)
	{
		for(var y = 0; y < item.width; y++) {
			for(var x = 0; x < item.depth; x++) {
				var tile = this.tiles[tileY - y][tileX - x];
				if(tile.occupied == 1 && tile.item != item) {
					this.setHighlightTiles(item, tileX, tileY);
					
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
		
		for(i = 0; i < len(item.tiles); i++) {
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

		this.setHighlightTiles(item, tilePos[0], tilePos[1]);
	}
	
	public function setHighlightTiles(item, xTile, yTile)
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
		this._sprite.addaction(moveto(250, -tile.left + size[0] / 2, -tile.top + size[1] / 2));		
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
		
		var newEvent = event.copy();
		newEvent.x = (pos[0] + abs(scrollPos[0])) * 100 / this.currentScale;
		newEvent.y = (pos[1] + abs(scrollPos[1])) * 100 / this.currentScale;
		
		return newEvent;
	}
}

class IsometricItem extends Control
{		
	var itemId;
	var width;
	var depth;
	var start;
	var canvas = null;
	var tiles;
	var left;
	var top;
	var z;
	var ghost;
	var isFlipped;
	var imageSprite;
	var acceptButton = null;
	var cancelButton = null;
	var flippButton = null;
	var editUIIsVisible;
	var isEditable;
	var text;
	var xpos;
	var ypos;
	var ref;
	var hiddenAcceptButton = 0;

	public function IsometricItem(imageResource, width, depth)
	{
//		super("transparent");
		super(null);
		
		this.imageSprite = sprite(imageResource, ARGB_8888, ALPHA_TOUCH);		
		this.imageSprite.prepare();
		var size = this.imageSprite.size();
		
		this._sprite.size(size[0], size[1]);
		this.imageSprite.pos(0, 0);
		this._sprite.add(this.imageSprite);
		
		this.width = width;
		this.depth = depth;
		this.editUIIsVisible = 0;
		this.isFlipped = 0;
		this.isEditable = 1;
						
		this.text = label("", "Arial", 20);
	}
	
	public function destroy()
	{
		this.tiles = null;
		this.canvas = null;
		
		Event.removeEventsForHandler(this._sprite);
		this.removeEditingUI();

		this._sprite.removefromparent();
	}
	
	public function changeImage(newImage)
	{
		this.imageSprite.texture(newImage);
	}
	
	public function setCanvas(canvas)
	{
		this.canvas = canvas;
		this.createEditingUI();
		this.testPlacement();
		this.getSprite().put(this);
		this.parent = canvas.getSprite();
		this.configureEvents();	
	}

	override public function configureEvents()
	{
		this.attachEvent(this._sprite, "ontouch", null, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", null, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", null, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", null, EVENT_MOVE);
	}
	
	public function testPlacement()
	{
		if(this.isEditable == 0) return 1;
		
		var pos = this.calculatePosition();
		var result = this.canvas.placeOnTile(this, pos[0], pos[1]);
		this.moveEditingUI();

/*		
		if(result != 1) {
			this.acceptButton.getSprite().visible(0);
		}
		else {
			this.acceptButton.getSprite().visible(1);
		}
*/
		
		return result;
	}
	
	private function createEditingUI()
	{
		this.getSprite().prepare();
		
		this.acceptButton = new Button("images/house-decorator/check-mark.png", this, "accept");
		this.acceptButton.getSprite().prepare();
//		trace("createEditingUI ", size, this.acceptButton, this.acceptButton.getSprite(), this.acceptButton.getSprite().size());
		this.acceptButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.acceptButton.getSprite(), 999999999);
		this.acceptButton.configureEvents();

		this.cancelButton = new Button("images/house-decorator/cancel-button.png", this, "cancel");
		this.cancelButton.getSprite().prepare();
		this.cancelButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.cancelButton.getSprite(), 999999999);
		this.cancelButton.configureEvents();

		this.flippButton = new Button("images/house-decorator/rotate.png", this, "flip");
		this.flippButton.getSprite().prepare();
		this.flippButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.flippButton.getSprite(), 999999999);
		this.flippButton.configureEvents();
		
		if(this.hiddenAcceptButton == 1) {
			this.canvas.getSprite().remove(this.acceptButton.getSprite());
			this.cancelButton.getSprite().texture("images/house-decorator/storage-box-icon.png");
			this.cancelButton.name = "storage";			
		}
		
		this.moveEditingUI();
	}
	
	private function removeEditingUI()
	{
		if(this.acceptButton) {
			this.acceptButton.destroy();
		}		
		
		if(this.cancelButton) {
			this.cancelButton.destroy();
		}		

		if(this.flippButton) {
			this.flippButton.destroy();
		}		
	}
	
	private function moveEditingUI()
	{
		if(this.canvas == null) return;
		
		var size = this.getSprite().size();
		var pos = this.getSprite().pos();
		
		trace("moveEditingUI: ", size, pos);
		
		var middleX = pos[0] + size[0] / 2;
		var topY = pos[1] - Game.translateY(85);
		
		this.acceptButton.getSprite().pos(middleX + Game.translateX(68), topY);
		this.cancelButton.getSprite().pos(middleX - Game.translateX(148), topY);
		this.flippButton.getSprite().pos(middleX - this.flippButton.getSprite().size()[0] / 2, topY);
	}
		
	public function unselect()
	{	
		if(this.editUIIsVisible == 1) {
			this.toggleEditingUI();
		}
	}
	
	public function hideAcceptButton()
	{
		this.hiddenAcceptButton = 1;

		if(this.canvas != null) {
			this.canvas.getSprite().remove(this.acceptButton.getSprite());
			this.cancelButton.getSprite().texture("images/house-decorator/storage-box-icon.png");
			this.cancelButton.name = "storage";			
		}
}
	
	public function toggleEditingUI()
	{	
		if(this.isEditable == 0) return;
		
		if(this.editUIIsVisible == 1) {
			this.editUIIsVisible = 0;

			this.removeGhost();
		}
		else {
			this.editUIIsVisible = 1;

			this.addGhost();
		}
		
		this.acceptButton.getSprite().visible(this.editUIIsVisible);
		this.cancelButton.getSprite().visible(this.editUIIsVisible);
		this.flippButton.getSprite().visible(this.editUIIsVisible);

		var size = this.getSprite().size();
		var pos = this.getSprite().pos();
		
		trace("toggleEditingUI: ", size, pos);
		
		this.moveEditingUI();
	}
	
	public function swapWidthAndDepth()
	{
		var depth = this.depth;
		this.depth = this.width;
		this.width = depth;
	}
	
	public function flipItem()
	{
		var size = this.imageSprite.size();
		this.imageSprite.size(-size[0], size[1]);
				
		if(this.isFlipped == 0) {
			this.isFlipped = 1;
			this.imageSprite.pos(size[0], 0);
		}
		else {
			this.isFlipped = 0;
			this.imageSprite.pos(0, 0);
		}
				
		this.swapWidthAndDepth();
		
		this.canvas.liftItem(this);

		var firstTile = this.tiles[0];
		trace("Flipping item at tile: ", firstTile.x, firstTile.y);
		this.canvas.placeItem(this, firstTile.x, firstTile.y);
		
		this.removeGhost();
		this.addGhost();
	}
	
	public function flip()
	{
//		trace("Flipping: ", this.isFlipped);

		this.flipItem();
		
		if(this.isEditable == 1) {
			this.canvas.reorganize();

			if(this.canvas.controller) {
				this.canvas.controller.itemFlipped(this);
			}
		}


		if(this.hiddenAcceptButton == 1) {
			this.toggleEditingUI();
		}
	}
	
	public function calculatePosition()
	{
		var pos = this._sprite.pos();
		var size = this._sprite.size();

		var itemWidth = size[0];
		var itemHeight = this._sprite.size()[1];
	
		var x1000 = pos[0] * 1000;
		var y1000 = pos[1] * 1000;
		var itemWidth1000 = this.width * 1000;
		
		var x = pos[0] + size[0] - ((5 * this.depth - 5) * this.canvas.tileWidth) / 10;
		var y = pos[1] + size[1] - this.canvas.tileHeight / 2;

		trace("*** IsometricItem position ", pos, size, x, y);		

//		if(this.isFlipped == 1) {
			x -= this.canvas.tileWidth / 2;
//			y -= this.canvas.tileHeight / 2;
//		}
		
		return new Array(x, y);
	}

	public function addGhost()
	{
		return;
        this.ghost = this.imageSprite.copy();
        var parent = this.canvas.getSprite();
		this.canvas.getSprite().add(this.ghost, 999999998);
		this.updateGhostPos();
	}
	
	public function removeGhost()
	{
		return;
		this.ghost.removefromparent();
		this.ghost = null;
	}
	
	public function updateGhostPos()
	{
		return;
		var posnow = this._sprite.pos();
		this.ghost.pos(posnow[0], posnow[1]);
	}
	
	override public function eventFired(event)
	{
		var pos;
		var ret = 0;
		
		if(this.editUIIsVisible == 0) {
			ret = this.tapEventHandler(event);
		}
		else {		
			if(event.name == "ontouch") {
		        this.start = event;
		        
		        var parent = this._sprite.parent();
		        this._sprite.removefromparent();
		        parent.add(this._sprite, 999999999);
			}
			else if(event.name == "onuntouch") {
				var result = this.testPlacement();
				if(result == 0) {
					this._sprite.pos(this.left, this.top);
				}
				this.canvas.reorganize();
				this.canvas.clearHighlight();
				if(this.hiddenAcceptButton == 1) {
					this.toggleEditingUI();
				}
			}
			else if(event.name == "onmove") {
				var deltaX = event.x - this.start.x;
				var deltaY = event.y - this.start.y;
				var posnow = this._sprite.pos();
	
				this._sprite.pos(posnow[0] + deltaX, posnow[1] + deltaY);
				this.updateGhostPos();
				this.moveEditingUI();
	
				pos = this.calculatePosition();
				this.canvas.highlightTiles(this, pos[0], pos[1]);
			}
		}
		
		return ret;
	}
	
	override public function controlTapped()
	{
		this.canvas.selectItem(this);
	}	
	
	public function buttonTapped(button)
	{
		if(button.name == "accept") {
			this.toggleEditingUI();
			this.canvas.acceptItem(this);
		}
		else if(button.name == "cancel") {
			this.toggleEditingUI();
			this.canvas.cancelAdding();
		}
		else if(button.name == "flip") {
			this.flip();
		}
		else if(button.name == "storage") {
			if(this.canvas.controller) {
				this.canvas.controller.moveItemToStorage(this);
			}
		}
	}	
}

class IsometricTile extends Control
{
	var highlightSprite = null;
	var width;
	var height;
	var x;
	var y;
	var top;
	var left;
	var z;
	var occupied;
	var item;
	var isHighlighted;
	var canvas;
	var area;
	
	public function IsometricTile(x, y, width, height)
	{
		super(null);
		
		this.x = x;
		this.y = y;
		
		this.width = width;
		this.height = height;
		this.isHighlighted = 0;
		
		this._sprite = sprite("images/furniture/highlight02.png", ARGB_8888);
		
		this.item = null;
	}
	
	override public function configureEvents()
	{
		this.attachEvent(this._sprite, "ontouch", null, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", null, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", null, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", null, EVENT_MOVE);
	}
	
	override public function controlTapped()
	{
		canvas.tileTapped(this);
	}
	
	public function addToCanvas(canvas)
	{
		this.top = (this.y + this.x) * this.height / 2;
		this.left = (this.y - this.x) * this.width / 2 + (canvas.cols - 1) * this.width / 2;
		
		this._sprite.pos(this.left, this.top);
		this._sprite.size(this.width, this.height);
		
		/*
		 this._sprite.addlabel(str(this.x) + "," + str(this.y), "Arial", 14);
		 */
		
		canvas.getSprite().add(this._sprite, x + y);
		
		this.canvas = canvas;
		
		this.parent = canvas.getSprite();
		this.configureEvents();
	}
	
	public function destroy()
	{
		this.parent.remove(this._sprite);
		
		Event.removeEventsForHandler(this._sprite);
		
		this.canvas = null;
		this.parent = null;
	}
	
	public function lightUp(item)
	{
		if(this.isHighlighted == 1) return;
		
		if(this.occupied == 0 || this.item == item) {
			this.highlightSprite = sprite("images/furniture/highlight.png");
		}
		else {
			this.highlightSprite = sprite("images/furniture/highlight02.png");
		}
		
		this.highlightSprite.pos(this.left, this.top);
		
		this.canvas.getSprite().add(this.highlightSprite, 99999999);
		
		this.isHighlighted = 1;
	}
	
	public function lightDown()
	{
		if(this.highlightSprite) {
			this.highlightSprite.removefromparent();
		}
		this.highlightSprite = null;
		this.isHighlighted = 0;
	}
	
	public function setFlatResource(resource, item_width, item_depth)
	{
		var newSprite = sprite(resource);
		newSprite.prepare();
		var size = newSprite.size();
		
		var top = this.top - size[1] + this.height;
		var left = this.left - this.width / item_width;
		
		Event.removeEventsForHandler(this._sprite);
		
		var parent = this._sprite.parent();
		this._sprite.removefromparent();
		
		this._sprite = newSprite;
		this._sprite.pos(left, top);
		
		this.configureEvents();

		var x1000 = this.x * 1000;
		var y1000 = this.y * 1000;
		var itemWidth1000 = 1 * 1000;
		
		this.z = (x1000 + 1000 - itemWidth1000 / 2) + 1000;
		
		parent.add(this._sprite, this.z);
	}

	public function setResource(resource, item_width, item_depth)
	{
		var newSprite = sprite(resource);
		newSprite.prepare();
		var size = newSprite.size();
		
		var itemWidth = size[0];
		var itemHeight = size[1];
		var x1000 = this.x * 1000;
		var y1000 = this.y * 1000;
		var itemWidth1000 = item_width * 1000;
		
		this.z = (x1000 + 1000 - itemWidth1000 / 2) + 1000;
				
		var left = this.left + this.width - itemWidth + ((5 * item_depth - 5) * this.width) / 10;
		var top = this.top + this.height - itemHeight;

		Event.removeEventsForHandler(this._sprite);

		var parent = this._sprite.parent();
		this._sprite.removefromparent();
		
		this._sprite = newSprite;
		this._sprite.pos(left, top);
		
		this.configureEvents();
		
		this.occupied = 1;
		
		parent.add(this._sprite, this.z);
	}
	
	public function removeItem()
	{
		this.item = null;
		this.occupied = 0;
		this.lightDown();
	}	
}

class Button extends Control
{
	var controller;
	var name;
	
	public function Button(resourceImage, controller, name)
	{
		super(resourceImage);
		
		this.controller = controller;
		this.name = name;
	}
	
	public function destroy()
	{
		Event.removeEventsForHandler(this.getSprite());
		this.getSprite().removefromparent();
	}

	override public function configureEvents()
	{
		this.attachEvent(this._sprite, "ontouch", null, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", null, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", null, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", null, EVENT_MOVE);
	}
	
	override public function controlTapped()
	{
		this.controller.buttonTapped(this);
	}
}

class FixedPoint
{
	static var scale = 100;
	var value;
	
	public function FixedPoint(val)
	{
		this.value = val * FixedPoint.scale;
	}
	
	public function div(fpNumber)
	{		
		var divNum = new FixedPoint(this.value);
		divNum.value = (this.value * FixedPoint.scale) / fpNumber.value;
		
		return divNum;
	}
	
	public function mul(fpNumber)
	{
		var mulNum = new FixedPoint(this.value);
		mulNum.value = (this.value * fpNumber.value) / FixedPoint.scale;
		
		return mulNum;
	}

	public function add(fpNumber)
	{
		var addNum = new FixedPoint(this.value);
		addNum.value = this.value + fpNumber.value;
		
		return addNum;
	}

	public function sub(fpNumber)
	{
		var subNum = new FixedPoint(this.value);
		subNum.value = this.value - fpNumber.value;
		
		return subNum;
	}
	
	public function integer()
	{
		return this.value / FixedPoint.scale;
	}
	
	public function round()
	{
		var ival = this.integer();
		
		var mantisse = this.value - ival * FixedPoint.scale;
		if(this.value > FixedPoint.scale / 2 - 1) {
			ival++;
		}
		
		return ival;
	}
}
