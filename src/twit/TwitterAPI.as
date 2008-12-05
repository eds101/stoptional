package twit
{	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class TwitterAPI
	{
		private var request:URLRequest;
//		private var authorization:URLRequestHeader;
		private var listenerUpdateStatus:Function;
		private var listenerPublicTimeline:Function;
		
		public function TwitterAPI(user:String, password:String)
		{
			this.request = new URLRequest();
//			this.authorization = new URLRequestHeader("Authorization",  "Basic " + Base64.Encode(user + ":" + password));
			this.request.requestHeaders.push(new URLRequestHeader("Authorization",  "Basic " + Base64.Encode(user + ":" + password)));
		}
		
		public function twitterRequest(url:String, data:URLVariables, method:String):URLRequest {
			this.request.url = url;
			this.request.method = method;
			this.request.data = data;
			
			return this.request;		
		}
		
		public function updateStatus(text:String, listenerUpdateStatus:Function):void {
			this.listenerUpdateStatus = listenerUpdateStatus;
			
			var urlvars:URLVariables = new URLVariables(); 
			urlvars.status = text;
			
/*			var urlreq:URLRequest = this.request;
			urlreq.url = "http://twitter.com/statuses/update.xml";
			urlreq.data = urlvars;
			urlreq.method = URLRequestMethod.POST;
	*/		
			var urlreq = twitterRequest("http://twitter.com/statuses/update.xml", urlvars, URLRequestMethod.POST);
	
			try
			{
				var loader:URLLoader = new URLLoader(urlreq);
				
				loader.addEventListener(Event.COMPLETE, this.postComplete);
				loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_RESPONSE_STATUS , this.postComplete);

				loader.load(urlreq);
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}			
		}
		
		public function postComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				Alert.show(loader.data);
			}
			catch (e:Error) {
				Alert.show(e.toString());
			}
		}
		
		public function updateStatusResult(event:ResultEvent):void {
			HTTPService(event.target).removeEventListener(ResultEvent.RESULT, updateStatusResult);
			var xml:XML = new XML(event.result);
			
			this.listenerUpdateStatus(true, xml);
		}
		
		public function updateStatusFault(event:FaultEvent):void {			
			HTTPService(event.target).removeEventListener(FaultEvent.FAULT, updateStatusFault);			
			var xml:XML = new XML(event.fault);
			
			this.listenerUpdateStatus(false, xml);
		}
		
		
		
		public function getPublicTimeline(listenerPublicTimeline:Function):void {
			this.listenerPublicTimeline = listenerPublicTimeline;
			
			var urlvars:URLVariables = new URLVariables();
			
			var urlreq:URLRequest = twitterRequest("http://twitter.com/statuses/public_timeline.xml", urlvars, URLRequestMethod.GET);
			
			try
			{
				var loader:URLLoader = new URLLoader(urlreq);
				
				loader.addEventListener(Event.COMPLETE, this.getPublicTimelineComplete);
				
				loader.load(urlreq);				
			}
			catch(e:Error)
			{
				Alert.show(e.message);
			}
			
		}
		
		public function getPublicTimelineComplete(event:Event):void {
			try {
				var loader:URLLoader = URLLoader(event.target);
				Alert.show(loader.data);	
			}
			catch (e:Error) {
				Alert.show(e.toString());
			}
		}
	}
}