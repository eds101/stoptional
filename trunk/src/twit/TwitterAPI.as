package twit
{	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.List;

	public class TwitterAPI
	{
		private var request:URLRequest;
		private var listenerLogin:Function;
		private var listenerUpdateStatus:Function;
		private var listenerPublicTimeline:Function;
		private var listenerFriendsTimeline:Function;
		private var listenerUsersTimeline:Function;
		private var listenerGetStatus:Function;
		private var listenerDeleteStatus:Function;
		
		public function TwitterAPI(user:String, password:String)
		{
			this.request = new URLRequest();
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
				loader.load(urlreq);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
		}
		
		private function listenerFail(event:HTTPStatusEvent) 
		{
			if (event.status != 200)
				Alert.show("Error interfacing with Twitter API:\n" + event.responseURL + "\n\n" + "Status:" + event.status);
		}
		
		public function login(listenerLogin:Function):void {
			this.listenerLogin = listenerLogin;
			
			var url:String = "http://twitter.com/account/verify_credentials.xml";
			var vars:URLVariables = new URLVariables();
			//vars.var1 = "var1";
			//vars.var2 = "var2";
			//vars.var3 = "var3";
			var listener:Function = loginComplete;
			
			twitterGet(url, vars, listener);
		}
		public function loginComplete(event:Event) {
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
		
		
		
		
		public function updateStatus(text:String, listenerUpdateStatus:Function):void {
			this.listenerUpdateStatus = listenerUpdateStatus;
			
			var url:String = "http://twitter.com/statuses/update.xml";
			var vars:URLVariables = new URLVariables();
			vars.status = text;
			
			var listener = updateStatusComplete;
			
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
		
		
		
		public function getPublicTimeline(listenerPublicTimeline:Function):void {
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
					statuses.push(list[i]);
				}
				
				this.listenerPublicTimeline(true, statuses);
			}
			catch (e:Error) {
								
				this.listenerPublicTimeline(false, null);
			}
		}
		
		public function getFriendsTimeline (count:int, listenerFriendsTimeline:Function):void {
			this.listenerFriendsTimeline = listenerFriendsTimeline;
			
			var url:String = "http://twitter.com/statuses/friends_timeline.xml";
			var vars:URLVariables = new URLVariables();
			vars.count = count;
			 
			var listener:Function = getFriendsTimelineComplete;
			
			twitterGet(url, vars, listener);
		}
		
		public function getFriendsTimelineComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getFriendsTimelineComplete);
				
				this.listenerFriendsTimeline(true, xml);
			}
			catch (e:Error) {
								
				this.listenerFriendsTimeline(false, null);
			}
		}
		
		public function getUsersTimeline (id:String, count:int, listenerUsersTimeline:Function):void {
			this.listenerUsersTimeline = listenerUsersTimeline;
			
			var url:String = "http://twitter.com/statuses/user_timeline.xml";
			var vars:URLVariables = new URLVariables();
			vars.id = id;
			vars.count = count;
			
			var listener:Function = getUsersTimelineComplete;
			
			twitterGet(url, vars, listener);
		}
		
		public function getUsersTimelineComplete(event:Event):void {
           try {
				var loader:URLLoader = URLLoader(event.target);
				var xml:XML = new XML(loader.data);
				
				loader.removeEventListener(Event.COMPLETE, getUsersTimelineComplete);
				
				this.listenerUsersTimeline(true, xml);
			}
			catch (e:Error) {
								
				this.listenerUsersTimeline(false, null);
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
		
		public function logout(id:String, listenerDeleteStatus:Function):void{

		}
		
		public function logoutComplete(event:Event):void {

		}
		
		
	}
}