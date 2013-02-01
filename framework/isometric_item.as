/*****************************************************************************
filename    isometric_item.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

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
		if(this.canvas) return;
		
		this.canvas = canvas;
		this.createEditingUI();
//		this.testPlacement();
		this.getSprite().put(this);
		this.parent = canvas.getSprite();

		canvas.getSprite().add(this.getSprite(), this.z);
	}
	
	public function resetZ(z)
	{
		if(!this.canvas) return;
		
		this.getSprite().removefromparent();
		this.canvas.getSprite().add(this.getSprite(), z);
	}

	override public function configureEvents()
	{
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", 0, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", 0, EVENT_MOVE);
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
		if(this.acceptButton) return;
		
		this.getSprite().prepare();
		
		this.acceptButton = new Button("images/house-decorator/check-mark.png", this, "accept");
		this.acceptButton.getSprite().prepare();
//		trace("createEditingUI ", size, this.acceptButton, this.acceptButton.getSprite(), this.acceptButton.getSprite().size());
		this.acceptButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.acceptButton.getSprite(), 999999999, 0);
		this.acceptButton.configureEvents();

		this.cancelButton = new Button("images/house-decorator/cancel-button.png", this, "cancel");
		this.cancelButton.getSprite().prepare();
		this.cancelButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.cancelButton.getSprite(), 999999999, 0);
		this.cancelButton.configureEvents();

		this.flippButton = new Button("images/house-decorator/rotate.png", this, "flip");
		this.flippButton.getSprite().prepare();
		this.flippButton.getSprite().visible(0);
		this.canvas.getSprite().add(this.flippButton.getSprite(), 999999999, 0);
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
	
	public function reorderEditingUI()
	{
		this.acceptButton.getSprite().removefromparent();
		this.cancelButton.getSprite().removefromparent();
		this.flippButton.getSprite().removefromparent();

		this.canvas.getSprite().add(this.acceptButton.getSprite(), 999999999, 0);
		this.canvas.getSprite().add(this.cancelButton.getSprite(), 999999999, 0);
		this.canvas.getSprite().add(this.flippButton.getSprite(), 999999999, 0);
	}
	
	public function toggleEditingUI()
	{	
		if(this.isEditable == 0) return;
		
		this.createEditingUI();
		
		this.configureEvents();
		
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
		if(!this.canvas) return;
		
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
        this.ghost = this.imageSprite.makeCopy();
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
		        
		        this._sprite.zPosition(999999999);
			}
			else if(event.name == "onuntouch") {
				var result = this.testPlacement();
				if(result == 0) {
					this._sprite.pos(this.left, this.top);
				}
		        this._sprite.zPosition(0);
				this.canvas.clearHighlight();
				if(this.hiddenAcceptButton == 1) {
					this.toggleEditingUI();
				}
				this.reorderEditingUI();
				this.canvas.reorganize();
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
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", 0, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", 0, EVENT_MOVE);
	}
	
	override public function controlTapped()
	{
		this.controller.buttonTapped(this);
	}
}