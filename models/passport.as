/*****************************************************************************
filename    passport.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   Users passport showing places the've traveled and souvenirs they have bought
*****************************************************************************/

class Passport
{
	var citiesVisited;
	
	var londonFirstVisit;
	var SanFranciscoFirstVisit;
	var ParisFirstVisit;
	var BuenosAiresFirstVisit;
	var TokyoFirstVisit;
	var SydneyFirstVisit;
	
	var LondonSouvenirs;
	var SanFranciscoSouvenirs;
	var ParisSouvenirs;
	var BuenosAiresSouvenirs;
	var TokyoSouvenirs;
	var SydneySouvenirs;
	
	var datesCompleted;
	
	public function Passport()
	{
		this.load();
	}
	
	public function checkAchievements()
	{
	    if(londonFirstVisit == 0 || SanFranciscoFirstVisit == 0 || 
	        ParisFirstVisit == 0 || BuenosAiresFirstVisit == 0 || 
	        TokyoFirstVisit == 0) {
	        Game.sharedGame().unlockAchievement("Tourist");
	    }
	    
	    if(londonFirstVisit == 0 && SanFranciscoFirstVisit == 0 && 
	        ParisFirstVisit == 0 && BuenosAiresFirstVisit == 0 && 
	        TokyoFirstVisit == 0) {
	        Game.sharedGame().unlockAchievement("Jet Setter");
	    }
	    
	    if(SydneyFirstVisit == 0) {
	        Game.sharedGame().unlockAchievement("Sheila");
	    }
	}

	
	public function load() 
	{
        var papayaUserId = Game.getPapayaUserId();
        var passportMap = Game.getDatabase().get("passport" + Game.getPapayaUserId());
        trace("### HWW ### - Fetched Passport from DB: ", str(passportMap));
        
        if (passportMap == null) 
        {
        	citiesVisited = 0;
        	
        	londonFirstVisit = 1;
    		SanFranciscoFirstVisit = 1;
    		ParisFirstVisit = 1;
    		BuenosAiresFirstVisit = 1;
    		TokyoFirstVisit = 1;
    		SydneyFirstVisit = 1;
			
    		LondonSouvenirs = [0,0,0,0,0,0];
    		SanFranciscoSouvenirs = [0,0,0,0,0,0];
    		ParisSouvenirs = [0,0,0,0,0,0];
    		BuenosAiresSouvenirs = [0,0,0,0,0,0];
    		TokyoSouvenirs = [0,0,0,0,0,0];
    		SydneySouvenirs = [0,0,0,0,0,0];
    		
    		datesCompleted = ["", "", "", "", "", ""];
    		
    		trace("### HWW ### - Passport datesCompleted:" + datesCompleted[0]);
            trace("### HWW ### - Passport datesCompleted:" + datesCompleted[1]);
            trace("### HWW ### - Passport datesCompleted:" + datesCompleted[2]);
            trace("### HWW ### - Passport datesCompleted:" + datesCompleted[3]);
            trace("### HWW ### - Passport datesCompleted:" + datesCompleted[4]);
            trace("### HWW ### - Passport datesCompleted:" + datesCompleted[5]);
			
			return;
        }
        
        citiesVisited = passportMap.get("citiesVisited");
        
        londonFirstVisit = passportMap.get("londonFirstVisit");
        SanFranciscoFirstVisit = passportMap.get("SanFranciscoFirstVisit");
        ParisFirstVisit = passportMap.get("ParisFirstVisit");
        BuenosAiresFirstVisit = passportMap.get("BuenosAiresFirstVisit");
        TokyoFirstVisit = passportMap.get("TokyoFirstVisit");
        SydneyFirstVisit = passportMap.get("SydneyFirstVisit");
        
        LondonSouvenirs = passportMap.get("LondonSouvenirs");
        SanFranciscoSouvenirs = passportMap.get("SanFranciscoSouvenirs");
        ParisSouvenirs = passportMap.get("ParisSouvenirs");
        BuenosAiresSouvenirs = passportMap.get("BuenosAiresSouvenirs");
        TokyoSouvenirs = passportMap.get("TokyoSouvenirs");
        SydneySouvenirs = passportMap.get("SydneySouvenirs");
        datesCompleted = passportMap.get("datesCompleted");
        
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[0]);
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[1]);
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[2]);
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[3]);
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[4]);
        trace("### HWW ### - Passport datesCompleted:" + datesCompleted[5]);
        
        trace("### HWW ### - Passport londonFirstVisit: " + str(londonFirstVisit));
        trace("### HWW ### - Passport SanFranciscoFirstVisit: " + str(SanFranciscoFirstVisit));
        trace("### HWW ### - Passport ParisFirstVisit: " + str(ParisFirstVisit));
        trace("### HWW ### - Passport BuenosAiresFirstVisit:" + str(BuenosAiresFirstVisit));
        trace("### HWW ### - Passport TokyoFirstVisit:" + str(TokyoFirstVisit));
        trace("### HWW ### - Passport SydneyFirstVisit:" + str(SydneyFirstVisit));
	}

    public function save()
    {
    	trace("### HWW ### - Saving Passport...");
        var papayaUserId = Game.getPapayaUserId();
        var serializedPassport = this.serialize();
        trace("### HWW ### - Saving Passport:", str(serializedPassport));
        Game.getDatabase().put("passport" + Game.getPapayaUserId(), serializedPassport);
    }

    public function serialize()
    {
        var papayaUserId = Game.getPapayaUserId();
        var passportArray = [];
        passportArray.append(["id", papayaUserId]);
        passportArray.append(["citiesVisited", citiesVisited]);
        passportArray.append(["londonFirstVisit", londonFirstVisit]);
        passportArray.append(["SanFranciscoFirstVisit", SanFranciscoFirstVisit]);
        passportArray.append(["ParisFirstVisit", ParisFirstVisit]);
        passportArray.append(["BuenosAiresFirstVisit", BuenosAiresFirstVisit]);
        passportArray.append(["TokyoFirstVisit", TokyoFirstVisit]);
        passportArray.append(["SydneyFirstVisit", SydneyFirstVisit]);
        passportArray.append(["LondonSouvenirs", LondonSouvenirs]);
        passportArray.append(["SanFranciscoSouvenirs", SanFranciscoSouvenirs]);
        passportArray.append(["ParisSouvenirs", ParisSouvenirs]);
        passportArray.append(["BuenosAiresSouvenirs", BuenosAiresSouvenirs]);
        passportArray.append(["TokyoSouvenirs", TokyoSouvenirs]);
        passportArray.append(["SydneySouvenirs", SydneySouvenirs]);
        passportArray.append(["datesCompleted", datesCompleted]);
        var escapedDates = new Array();
        for (var i=0 ;i <len(datesCompleted); i++) {
            trace("Dates Completed: ", datesCompleted[i]);
            escapedDates.append(str("'" + datesCompleted[i] + "'"));
        }
        passportArray.append(["escapedDatesCompleted", escapedDates]);
        
        return dict(passportArray);
    }

    public function saveFromJSON(passportMap) {
        citiesVisited = passportMap.get("citiesVisited");
        
        londonFirstVisit = passportMap.get("londonFirstVisit");
        SanFranciscoFirstVisit = passportMap.get("sanFranciscoFirstVisit");
        ParisFirstVisit = passportMap.get("parisFirstVisit");
        BuenosAiresFirstVisit = passportMap.get("buenosAiresFirstVisit");
        TokyoFirstVisit = passportMap.get("tokyoFirstVisit");
        SydneyFirstVisit = passportMap.get("sydneyFirstVisit");
        
        LondonSouvenirs = passportMap.get("londonSouvenirs");
        SanFranciscoSouvenirs = passportMap.get("sanFranciscoSouvenirs");
        ParisSouvenirs = passportMap.get("parisSouvenirs");
        BuenosAiresSouvenirs = passportMap.get("buenosAiresSouvenirs");
        TokyoSouvenirs = passportMap.get("tokyoSouvenirs");
        SydneySouvenirs = passportMap.get("sydneySouvenirs");
        datesCompleted = passportMap.get("datesCompleted");
        this.save();
    }
}
