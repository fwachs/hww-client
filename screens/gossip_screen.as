/*****************************************************************************
filename    gossip_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class GossipScreen extends Screen
{
	var screenUpdateTimer;
	var textInput;
	var text;
	
	var ypos;
	var lastMessageNumber;
	var messages;
	
	public function GossipScreen()
	{
		super();
		this.screenUpdateTimer = new gossipScreenUpdateTimer();
	}
	
	override public function build()
	{
		this.text = "";
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
		
		var vf = v_font(Game.translateFontSize(30), "arial", FONT_NORMAL);
		this.textInput = v_create(V_INPUT_VIEW, Game.translateX(400), Game.translateY(686), Game.translateX(550), Game.translateY(100));
		this.textInput.attr(ATTR_FONT, vf);
		v_root().addview(this.textInput);
		this.textInput.text(this.text);
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
		
		this.textInput.removefromparent();
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

	public function drawBestHouseWife(topHouseWife)
	{
		this.getElement("topWifeName").setText(topHouseWife.name);
		topHouseWife.dress(this);
		
		this.getElement("sspText").setText(str(topHouseWife.socialStatusPoints));
	}
	
	public function addMessageToWall(idx, message, ypos)
	{
		var crownTexture = "gossip-wall/player-house-lvl-icon-3.png";

        if(message.houseLevel <= 4) {
        	crownTexture = "gossip-wall/player-house-lvl-icon-3.png";
        }
        else if(message.houseLevel <= 7) {
        	crownTexture = "gossip-wall/player-house-lvl-icon-2.png";
        }
        else if(message.houseLevel <= 10) {
        	crownTexture = "gossip-wall/player-house-lvl-icon-1.png";
        }

        var params = dict([["message_idx", str(idx)],["top", str(ypos)], ["crown_texture", crownTexture], ["wife_name", message.wifeName], ["minutes_ago", message.minutesAgo], ["message_text", message.message]]);
        return this.controlFromXMLTemplate("GossipPost", params, "gossip-post.xml");
	}
	
	public function updateMessages(msgs)
	{
		this.messages = msgs;
		this.drawWall(this.messages)
	}
	
	public function drawWall(messages)
	{
		var scroll = this.getElement("scroll");
		scroll.removeAllChildren();
		
		ypos = 0;
		
		for (var i = 0; i < len(messages); i++) {
			trace("### HWW ### - Message: ", messages[i]);
			var message = new GossipMessage(messages[i].get("message"), messages[i].get("houseWifeName"), messages[i].get("houseLevel"), messages[i].get("timeAgo"));
			var control = addMessageToWall(i, message, ypos);
			trace("new control: ", control);
			scroll.addChild(control);
			
			var textEle = this.getElement("messageText_" + str(i));
			var size = textEle.getSprite().size();
			var vertSize = Game.untranslate(size[1]);
			
			var bgEle = this.getElement("postBoxMid_" + str(i));
			bgEle.getSprite().size(Game.translateX(823), Game.translateY( vertSize + 23));
			
			var bottEle = this.getElement("postBoxBottom_" + str(i));
			bottEle.getSprite().pos(Game.translateX(400), Game.translateY( vertSize + 60));
			
			ypos += 70 + vertSize;
		}
		
		scroll.setContentSize(200, ypos + 50);
		lastMessageNumber = len(messages);
	}
	
	public function post()
	{
		this.text = this.textInput.text();
		this.textInput.text("");
		
		// TODO: get house level
		if (this.text != "") {
		    this.messages.append(dict([["message", this.text], ["houseWifeName", Game.currentGame.wife.name], ["houseLeve", ""], ["timeAgo", ""]]));
		    var msg = GossipMessage(this.text, Game.currentGame.wife.name, 1, 0);     
	        
	        Game.sharedGame().getServer().postGossip(msg, this.buildMessageListAndBestWife);    
		}
	}

	public function buildMessageListAndBestWife(request_id, ret_code, response_content)
    {
		if(ret_code == 0) return;
		
        trace("### HWW ### - Received Gossip Messages: ", str(response_content));
        var response = json_loads(response_content);
        var messages = response.get("messages");
        var bestWife = response.get("bestHouseWife");
        
        var topHouseWife = new Wife();
        topHouseWife.loadFromJSON(bestWife);
        
        this.updateMessages(messages);
        this.drawBestHouseWife(topHouseWife);   
    }
}

class gossipScreenUpdateTimer extends Timer
{
	public function gossipScreenUpdateTimer()
	{
		super("gossipScreenUpdateTimer", 1, -1);
	}
	
	override public function tick()
	{
		
	}
}
