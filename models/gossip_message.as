/*****************************************************************************
filename    gossip_message.as
author      Federico Wachs
DP email    federico.wachs@2clams.com
project     House Wife Wars

Brief Description:
   gossip wall message
*****************************************************************************/

class GossipMessage
{
	var message;
	var wifeName;
	var houseLevel;
	var minutesAgo;
	
    public function GossipMessage(msg, name, level, minutesAgo)
    {
    	this.message = msg;
    	this.wifeName = name;
    	this.houseLevel = level;
    	this.minutesAgo = minutesAgo;
    }
    
    public function serialize()
    {
        var papayaUserId = Game.getPapayaUserId();
        var gossipMessageArray = [];
        gossipMessageArray.append(["papayaUserId", papayaUserId]);
        gossipMessageArray.append(["message", this.message]);
        gossipMessageArray.append(["houseWifeName", this.wifeName]);
        return dict(gossipMessageArray);
    }
}
