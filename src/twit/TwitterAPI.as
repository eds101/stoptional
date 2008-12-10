package twit
{	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;

	public class TwitterAPI
	{
		private var request:URLRequest;
		private var listenerLogin:Function;
		private var listenerUpdateStatus:Function;
		private var listenerPublicTimeline:Function;
		private var listenerFriendsTimeline:Function;
		private var listenerUserTimeline:Function;
		private var listenerGetStatus:Function;
		private var listenerDeleteStatus:Function;
		private var listenerLogout:Function;
		private var listenerUpdateLocation:Function;
		private var listenerGetRateLimit:Function;
		private var listenerGetFriends:Function;
		private var listenerGetFollowers:Function;
		private var listenerGetUser:Function;
		private var listenerGetDirectMsg:Function;
		private var listenerGetSentMsg:Function;
		private var listenerSendDirectMsg:Function;
		private var listenerDestroyDirectMsg:Function;
		
		public function TwitterAPI(user:String, password:String)
		{
			this.request = new URLRequest();
			this.request.authenticate = false;
			this.request.requestHeaders = [new URLRequestHeader("Authorization",  "Basic " + Base64.Encode(user + ":" + password))];
		}
		
		private function twitterRequest(url:String, data:URLVariables, method:String):URLRequest {
			this.request.url = url;
			this.request.method = method;
			this.request.data = data;
			
			return this.request;		
		}
		
		private function twitterGet(url:String, vars:URLVariables, listener:Function):void {
			var urlreq:URLRequest = twitterRequest(url, vars, URLRequestMethod.GET);
			
			try
			{
				var loader:URLLoader = new URLLoader(urlreq);
				
				loader.addEventListener(Event.COMPLETE, listener);
				loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_RESPONSE_STATUS, listenerFail);
				loader.load(urlreq);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		private function twitterPost(url:String, vars:URLVariables, listener:Function):void {
			var urlreq:URLRequest = twitterRequest(url, vars, URLRequestMethod.POST);
			
			try
			{
				var loader:URLLoader = new URLLoader(urlreq);
				
				loader.addEventListener(Event.COMPLETE, listener);
				loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_RESPONSE_STATUS, listenerFail);
				loader.load(urlreq);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		private function listenerFail(event:HTTPStatusEvent):void 
		{
			if (event.status != 200 && event.responseURL != "http://twitter.com/account/end_session")
				Alert.show("Error interfacing with Twitter API:\n" + event.responseURL + "\n\n" + "Status:" + event.status);
		}
		
		public function login(listenerLogin:Function):void {
			this.listenerLogin = listenerLogin;
			
			var url:String = "http://twitter.com/account/verify_credentials.xml";
			var vars:URLVariables = new URLVariables();
			var listener:Function = loginComplete;
			
			twitterGet(url, vars, listener);
		}
		public function loginComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, loginComplete);
				
				if (xml.toString() == "true")
				{
					this.listenerLogin(true, true);
				}
				else
				{
					Alert.show("Twitter authentication failed:\n\n" + xml.child("error"));
					this.listenerLogin(true, false);
				}
			}
			catch (e:Error)
			{
				this.listenerLogin(false, null);
			}			
		}
		
		
		public function logout(listenerLogout:Function):void{
           this.listenerLogout = listenerLogout;
			
			var url:String = "http://twitter.com/account/end_session";
			var vars:URLVariables = new URLVariables();

			var listener:Function = logoutComplete;
			
			twitterPost(url, vars, listener);
		}
		
		public function logoutComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, logoutComplete);
				
				if (xml.child("error") == "This method requires a POST.")
				{
					this.listenerLogout(true, true);
				}
				else
				{
					Alert.show("Logout failed:\n\n" + xml);
					this.listenerLogout(true, false);
				}
			}
			catch (e:Error)
			{
				this.listenerLogout(false, null);
			}			
		}
		
		
		public function updateStatus(text:String, listenerUpdateStatus:Function):void {
			this.listenerUpdateStatus = listenerUpdateStatus;
			
			var url:String = "http://twitter.com/statuses/update.xml";
			var vars:URLVariables = new URLVariables();
			vars.status = text;
			
			var listener:Function = updateStatusComplete;
			
			twitterPost(url, vars, listener);
		}
		public function updateStatusComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, updateStatusComplete);
				
				this.listenerUpdateStatus(true, xml);
			}
			catch (e:Error)
			{
				this.listenerUpdateStatus(false, null);
			}
		}		
		
		public function getPublicTimeline(id:String, count:int, since_id:String, listenerPublicTimeline:Function):void {
			this.listenerPublicTimeline = listenerPublicTimeline;
			
			var url:String = "http://twitter.com/statuses/public_timeline.xml";
			var vars:URLVariables = new URLVariables();
			
			var listener:Function = getPublicTimelineComplete;
			
			twitterGet(url, vars, listener);
		}
		public function getPublicTimelineComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getPublicTimelineComplete);
				
				var statuses:Array = new Array();
				var list:XMLList = xml.status;
				
				for (var i:int = 0; i < list.length(); i++) {
					statuses.push(new XML(list[i]));
				}
				
				this.listenerPublicTimeline(true, statuses);
			}
			catch (e:Error) {
								
				this.listenerPublicTimeline(false, null);
			}
		}
		
		public function getFriendsTimeline (id:String, count:int, since_id:String, listenerFriendsTimeline:Function):void {
			this.listenerFriendsTimeline = listenerFriendsTimeline;
			
			var url:String = "http://twitter.com/statuses/friends_timeline.xml";
			var vars:URLVariables = new URLVariables();
			vars.count = count;
			if (since_id != "") vars.since_id = since_id;
			 
			var listener:Function = getFriendsTimelineComplete;
			
			twitterGet(url, vars, listener);
		}
		
		public function getFriendsTimelineComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getFriendsTimelineComplete);
				
				var statuses:Array = new Array();
				var list:XMLList = xml.status;
				
				for (var i:int = 0; i < list.length(); i++) {
					statuses.push(new XML(list[i]));
				}
				
				this.listenerFriendsTimeline(true, statuses);
			}
			catch (e:Error) {
								
				this.listenerFriendsTimeline(false, null);
			}
		}
		
		public function getUserTimeline (id:String, count:int, since_id:String, listenerUserTimeline:Function):void {
			this.listenerUserTimeline = listenerUserTimeline;
			
			var url:String = "http://twitter.com/statuses/user_timeline.xml";
			var vars:URLVariables = new URLVariables();
			vars.id = id;
			vars.count = count;
			if (since_id != "") vars.since_id = since_id;
			
			var listener:Function = getUserTimelineComplete;
			
			twitterGet(url, vars, listener);
		}
		
		public function getUserTimelineComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getUserTimelineComplete);
				
				var statuses:Array = new Array();
				var list:XMLList = xml.status;
				
				for (var i:int = 0; i < list.length(); i++) {
					statuses.push(new XML(list[i]));
				}
				
				this.listenerUserTimeline(true, statuses);
			}
			catch (e:Error) {
				Alert.show(e.message);
				this.listenerUserTimeline(false, null);
			}
		}
		
		public function getStatus(id:String, listenerGetStatus:Function):void{
			this.listenerGetStatus = listenerGetStatus;
			
			var url:String = "http://twitter.com/statuses/show/" + id + ".xml";
			var vars:URLVariables = new URLVariables();
			//vars.id = id;
			
			var listener:Function = getStatusComplete;
			
			twitterGet(url, vars, listener);
		}
		
		public function getStatusComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getStatusComplete);
				
				this.listenerGetStatus(true, xml);
			}
			catch (e:Error) {
								
				this.listenerGetStatus(false, null);
			}
		}
		
		public function deleteStatus(id:String, listenerDeleteStatus:Function):void{
			this.listenerDeleteStatus = listenerDeleteStatus;
			
			var url:String = "http://twitter.com/statuses/destroy/" + id + ".xml";
			var vars:URLVariables = new URLVariables();
			vars.id = id;
			
			var listener:Function = deleteStatusComplete;
			
			twitterPost(url, vars, listener);
		}
		
		public function deleteStatusComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, deleteStatusComplete);
				
				this.listenerDeleteStatus(true, xml);
			}
			catch (e:Error) {
								
				this.listenerDeleteStatus(false, null);
			}
		}

		public function updateLocation(text:String, listenerUpdateLocation:Function):void {
			this.listenerUpdateLocation = listenerUpdateLocation;
			
			var url:String = "http://twitter.com/account/update_location.xml";
			var vars:URLVariables = new URLVariables();
			vars.location = text;
			
			var listener:Function = updateLocationComplete;
			
			twitterPost(url, vars, listener);
		}
		public function updateLocationComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, updateLocationComplete);
				
				this.listenerUpdateLocation(true, xml);
			}
			catch (e:Error)
			{
				this.listenerUpdateLocation(false, null);
			}
		}
		
		
		public function getRateLimit(listenerGetRateLimit:Function):void{
		   this.listenerGetRateLimit = listenerGetRateLimit;
			
		   var url:String = "http://twitter.com/account/rate_limit_status.xml";
		   var vars:URLVariables = new URLVariables();
			
		   var listener:Function = getRateLimitComplete;
			
		   twitterGet(url, vars, listener);
		}	
		public function getRateLimitComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getRateLimitComplete);
				
				var percent:int = int(xml.child("remaining-hits")) / int(xml.child("hourly-limit"));
				
				this.listenerGetRateLimit(true, percent);
			}
			catch (e:Error)
			{
				this.listenerGetRateLimit(false, null);
			}
		}
		
		
		public function getFriends(id:String, listenerGetFriends:Function):void{
		   this.listenerGetFriends = listenerGetFriends;
			
		   var url:String = "http://twitter.com/statuses/friends.xml";
		   var vars:URLVariables = new URLVariables();
           vars.id = id;	
			
		   var listener:Function = getFriendsComplete;
			
		   twitterGet(url, vars, listener);
		}	
		public function getFriendsComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getFriendsComplete);
				
				this.listenerGetFriends(true, xml);
			}
			catch (e:Error)
			{
				this.listenerGetFriends(false, null);
			}
		}
		
		
		public function getFollowers(id:String, listenerGetFollowers:Function):void{
		   this.listenerGetFollowers = listenerGetFollowers;
			
		   var url:String = "http://twitter.com/statuses/followers.xml";
		   var vars:URLVariables = new URLVariables();
           vars.id = id;
			
		   var listener:Function = getFollowersComplete;
			
		   twitterGet(url, vars, listener);
		}	
		public function getFollowersComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getFollowersComplete);
				
				this.listenerGetFollowers(true, xml);
			}
			catch (e:Error)
			{
				this.listenerGetFollowers(false, null);
			}
		}
		
		
		public function getUser(id:String, email:String, listenerGetUser:Function):void{
		   this.listenerGetUser = listenerGetUser;
			
		   
		   var vars:URLVariables = new URLVariables();
           
           if (id.length > 0) {
           	  var url:String = "http://twitter.com/users/show/" + id + ".xml";
	          vars.id = id;
	       } 
	       else {
	       	  var url:String = "http://twitter.com/users/show.xml";
              vars.email = email;
           }		
		   
		   var listener:Function = getUserComplete;
			
		   twitterGet(url, vars, listener);
		}	
		public function getUserComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getUserComplete);
				this.listenerGetUser(true, new UserFull(new XML(xml)));
			}
			catch (e:Error)
			{
				this.listenerGetUser(false, null);
			}
		}
		
		
		public function getDirectMsg(listenerGetDirectMsg:Function):void{
		   this.listenerGetDirectMsg = listenerGetDirectMsg;			
		   
           var url:String = "http://twitter.com/direct_messages.xml";
           var vars:URLVariables = new URLVariables();
		   
		   var listener:Function = getDirectMsgComplete;
			
		   twitterGet(url, vars, listener);
		}	
		public function getDirectMsgComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getDirectMsgComplete);
				
				var statuses:Array = new Array();
				var list:XMLList = XMLList(xml.child("direct_message"));
				
				for (var i:int = 0; i < list.length(); i++) {
					statuses.push(new XML(list[i]));
				}
				
				this.listenerGetDirectMsg(true, statuses);
			}
			catch (e:Error)
			{
				this.listenerGetDirectMsg(false, null);
			}
		}
		
		
		public function getSentMsg(listenerGetSentMsg:Function):void{
			this.listenerGetSentMsg = listenerGetSentMsg;			
   
			var url:String = "http://twitter.com/direct_messages/sent.xml";
			var vars:URLVariables = new URLVariables();
			   
			var listener:Function = getSentMsgComplete;
			twitterGet(url, vars, listener);
		}	
		public function getSentMsgComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getSentMsgComplete);
				
				var msgs:Array = new Array();
				var list:XMLList = xml.direct_message;
				
				for (var i:int = 0; i < list.length(); i++) {
				
					msgs.push(new XML(list[i]));
				}
				
				this.listenerGetSentMsg(true, msgs);
			}
			catch (e:Error)
			{
				this.listenerGetSentMsg(false, null);
			}
		}
		
		
		public function sendDirectMsg(id:String, msg:String, listenerSendDirectMsg:Function):void{
			this.listenerSendDirectMsg = listenerSendDirectMsg;
			  
			var url:String = "http://twitter.com/direct_messages/new.xml";
			var vars:URLVariables = new URLVariables();
			vars.user = id;
			vars.text = msg;
			   
			var listener:Function = sendDirectMsgComplete;
			
			twitterPost(url, vars, listener);
		}
		public function sendDirectMsgComplete(event:Event):void{
			try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, sendDirectMsgComplete);
				this.listenerSendDirectMsg(true, xml);
			}
			catch (e:Error)
			{
				this.listenerSendDirectMsg(false, null);
			}
		}
		
		
		public function destroyDirectMsg(id:String, listenerDestroyDirectMsg:Function):void{
		   this.listenerDestroyDirectMsg = listenerDestroyDirectMsg;			
		   
           var url:String = "http://twitter.com/direct_messages/destroy/" + id + ".xml";
           var vars:URLVariables = new URLVariables();
		   vars.id = id;
		   
		   var listener:Function = destroyDirectMsgComplete;
			
		   twitterPost(url, vars, listener);
		}	
		public function destroyDirectMsgComplete(event:Event):void{
		   try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, destroyDirectMsgComplete);
				this.listenerDestroyDirectMsg(true, xml);
			}
			catch (e:Error)
			{
				this.listenerDestroyDirectMsg(false, null);
			}
		}
		
		
	}
}