/*****************************************************************************
filename    papaya_friend.as
author      Federico Wachs
DP email    federico.wachs@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/


class PapayaFriend
{
	var papayaUserId;
	var name;
	var avatarUrl;
	var isGamePlayer;

	public function PapayaFriend(papayaUserId, name, avatarUrl, isGamePlayer) {
		this.papayaUserId = papayaUserId;
		this.name = name;
		this.avatarUrl = avatarUrl;
		this.isGamePlayer = isGamePlayer;
	}
}