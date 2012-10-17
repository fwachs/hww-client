/*****************************************************************************
filename    server.as
author      Federico Wachs
DP email    federico.wachs@2clams.com
project     housewife wars

Brief Description:
   Handles server communication and synchronization 
*****************************************************************************/

class Server
{
    var url;
    public function Server()
    {	
    	url = "http://hww.2clams.com:8080";
    }

    public function checkPlayersStatus(flist, mainController) {
        var params = dict();
        params.update("papayaUserIds", flist);
        params.update("mainController", mainController);
        var completeUrl = url + "/checkPlayersStatus";
        http_request(completeUrl, this.playerStatusCallback, params, 2000, params);
    }

    public function playerStatusCallback(request_id, ret_code, response_content, params) {
        var flist = params.get("papayaUserIds");
        var response = json_loads(response_content);
        for (var i=0; i< len(flist); i++) {
            flist[i].update("foundOnHWW", response.has_key(str(flist[i].get("id"))+"-wife"));
        }
        var mainController = params.get("mainController");
        mainController.buildFriends(flist);
    }

    public function synchronize(callback) {
    	var params = dict();

        params.update("papayaUserId", Game.papayaUserId);
    	this.makeRequest("/synchronize", callback, params);
    }

    public function synchronizeGame() {
        var params = dict();
        var wife = Game.sharedGame().wife.serialize();
        var husband = Game.sharedGame().hubby.serialize();
        var wallet = Game.sharedGame().wallet.serialize();
        var passport = Game.sharedGame().passport;
        var house = Game.sharedGame().house;
        var realstate = Game.sharedGame().realestate.serialize();
        house.loadCustomTiles();
        house.loadFurniture();
        house.loadStorage();

        husband.update("citiesVisited", passport.citiesVisited);
        params.update("house", house.serialize());
        params.update("wife", wife);
        params.update("husband", husband);
        params.update("wallet", wallet);
        var passportMap = passport.serialize();
        passportMap.update("datesCompleted", new Array());
        params.update("passport", passportMap);
        params.update("realstate", realstate);
        params.update("papayaUserId", Game.papayaUserId);
        this.makeRequest("/synchronizeGame", this.defaultCallBack, params);
    }

	public function register() {
	    var husband = Game.sharedGame().hubby;
		var wife = Game.sharedGame().wife;
	    var couple = dict();
	    couple.update("wife", wife.serialize());
	    var serializedHusband = husband.serialize();
	    var passport = Game.sharedGame().passport;
	    
	    serializedHusband.update("citiesVisited", passport.citiesVisited);
        couple.update("husband", serializedHusband);
		this.makeRequest("/register", defaultCallBack, couple);
	}

	public function syncWife()
	{
		var wife = Game.sharedGame().wife;
		this.makeRequest("/syncWife", defaultCallBack, wife.serialize());
	}

    public function syncHusband()
    {
    	var husband = Game.sharedGame().hubby;
    	var passport = Game.sharedGame().passport;
    	var serializedHusband = husband.serialize();
        serializedHusband.update("citiesVisited", passport.citiesVisited);
        this.makeRequest("/syncHusband", defaultCallBack, serializedHusband);
    }

	public function syncHouse()
    {
    	var house = Game.sharedGame().house;
    	house.loadCustomTiles();
    	house.loadFurniture();
    	house.loadStorage();
        this.makeRequest("/syncHouse", defaultCallBack, house.serialize());
    }

	public function getOtherPlayerHouse(papayaUserId, callback)
	{
		var params = dict();
		params.update("papayaUserId", papayaUserId);
		this.makeRequest("/getPlayerHouse", callback, params);
	}

	public function getOtherPlayerProfile(papayaUserId, callback)
	{
		var params = dict();
		params.update("userId", papayaUserId);
		this.makeRequest("/getOtherPlayerProfile", callback, params);
	}

    public function postGossip(gossipWallMessage, callback)
    {
        this.makeRequest("/postGossip", callback, gossipWallMessage.serialize());
    }

    public function getMessagesAndBestWife(callback)
    {
        var wife = Game.sharedGame().wife;
        this.makeRequest("/getLatestGossipMessages", callback, wife.serialize());
    }

	public function getCurrentDateAndTick(callback)
    {
        this.makeRequest("/getCurrentDateAndTick", callback, dict());
    }

	public function getGifts(callback)
	{
		this.makeRequest("/getGifts", callback, dict([["papayaUserId", Game.getPapayaUserId()]]));
	}

	public function sendGift(params)
	{
		this.makeRequest("/sendGift", this.defaultCallBack, params);
	}

	public function getDailyBonus(callback)
	{
		this.makeRequest("/getDailyBonus", callback, dict([["papayaUserId", Game.getPapayaUserId()]]));
	}

    public function makeRequest(path, callback, params)
    {
    	var completeUrl = url + path;
    	trace("### HWW ### - Sending HTTP Request: ", completeUrl, str(params));
        http_request(completeUrl, callback, params, 2000);
    }

    private function defaultCallBack(request_id, ret_code, response_content)
    {
        trace("### HWW ### - Default Callback: ", response_content, " RetCode: ", str(ret_code));
    }

}
