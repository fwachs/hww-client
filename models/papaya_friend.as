/*****************************************************************************
filename    papaya_friend.as
author      Federico Wachs
DP email    federico.wachs@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/


class PapayaFriend
{
	static var invitations = null;
	
	var papayaUserId;
	var name;
	var avatarUrl;
	var isGamePlayer;
	var foundOnHWW;
	
	public static function getInvitations()
	{
		if(PapayaFriend.invitations == null) {
	        var papayaUserId = Game.getPapayaUserId();
			var db = Game.getDatabase();
			PapayaFriend.invitations = db.get("invitations" + Game.getPapayaUserId());
			if(!PapayaFriend.invitations) {
				PapayaFriend.invitations = new Array();
			}
		}
		
		return PapayaFriend.invitations;
	}
	
	public static function saveInvitations()
	{
        var papayaUserId = Game.getPapayaUserId();
        trace("### HWW ### - Saving invitations:", PapayaFriend.invitations);
        Game.getDatabase().put("invitations" + Game.getPapayaUserId(), PapayaFriend.invitations);
	}
	
	public static function addInvitation(papayaUserId)
	{
		var invites = PapayaFriend.getInvitations();
		
		invites.append(papayaUserId);
		PapayaFriend.saveInvitations();
	}
	
	public static function removeInvitation(papayaUserId)
	{
		var invites = PapayaFriend.getInvitations();
		
		invites.remove(papayaUserId);
		PapayaFriend.saveInvitations();
	}
	
	public static function isInvited(papayaUserId)
	{
		var invites = PapayaFriend.getInvitations();
		for(var i = 0; i < len(invites); i++) {
			if(invites[i] == papayaUserId) {
				return 1;
			}
		}
		
		return 0;
	}

	public function PapayaFriend(papayaUserId, name, avatarUrl, isGamePlayer, foundOn) 
	{
		this.papayaUserId = papayaUserId;
		this.name = name;
		this.avatarUrl = avatarUrl;
		this.isGamePlayer = isGamePlayer;
		this.foundOnHWW = foundOn;
	}
}