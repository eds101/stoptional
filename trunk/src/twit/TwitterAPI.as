package twit
{	
	import flash.events.Event;
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
		
		public function TwitterAPI(user:String, password:String)
		{
			this.request = new URLRequest();
			this.request.requestHeaders.push(new URLRequestHeader("Authorization",  "Basic " + Base64.Encode(user + ":" + password)));
		}
		
		public function twitterRequest(url:String, data:URLVariables, method:String):URLRequest {
			this.request.url = url;
			this.request.method = method;
			this.request.data = data;
			
			return this.request;		
		}
		
		public function twitterGet(url:String, vars:URLVariables, listener:Function):void {
			var urlreq:URLRequest = twitterRequest(url, vars, URLRequestMethod.GET);
			
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
		
		public function twitterPost(url:String, vars:URLVariables, listener:Function):void {
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
		
		public function login(user:String, password:String, listenerLogin:Function):void {
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
				
				this.listenerLogin(true, xml);
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
				
				this.listenerPublicTimeline(true, xml);
			}
			catch (e:Error) {
								
				this.listenerPublicTimeline(false, null);
			}
		}
	}
}