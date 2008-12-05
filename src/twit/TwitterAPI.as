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
		private var http:HTTPService;
		private var authorization:URLRequestHeader;
		private var listenerPostPublic:Function;
		private var listenerPublicTimeline:Function;
		
		public function TwitterAPI(user:String, password:String)
		{
			this.http = new HTTPService();
			this.authorization = new URLRequestHeader("Authorization",  "Basic " + Base64.Encode(user + ":" + password)); 
		}
		
		public function postPublic(text:String, listenerPostPublic:Function):void {
			this.listenerPostPublic = listenerPostPublic;
			
			this.http.url = "https://twitter.com/statuses/update.xml";
			this.http.method = "post";
			this.http.resultFormat = "text";
			
			var urlvars:URLVariables = new URLVariables(); 
			urlvars.status = text;
			
			var urlreq:URLRequest = new URLRequest();
			urlreq.url = "https://twitter.com/statuses/update.xml";
			urlreq.data = urlvars;
			
			http.request = urlreq;
			
			this.http.addEventListener(ResultEvent.RESULT, postPublicResult);
			this.http.addEventListener(FaultEvent.FAULT, postPublicFault);
			
			//this.http.send();
		
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
			
				Alert.show(event.toString());	
			}
			catch (e:Error) {
				Alert.show(e.toString());
			}
		}
		
		public function postPublicResult(event:ResultEvent):void {
			HTTPService(event.target).removeEventListener(ResultEvent.RESULT, postPublicResult);
			var xml:XML = new XML(event.result);
			
			this.listenerPostPublic(true, xml);
		}
		
		public function postPublicFault(event:FaultEvent):void {			
			HTTPService(event.target).removeEventListener(FaultEvent.FAULT, postPublicFault);			
			var xml:XML = new XML(event.fault);
			
			this.listenerPostPublic(false, xml);
		}
		
		
		
		public function getPublicTimeline(listenerPublicTimeline:Function):void {
			this.listenerPublicTimeline = listenerPublicTimeline;
			
			this.http.url = "http://twitter.com/statuses/public_timeline.xml";
			this.http.method = "GET";
			this.http.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			
			var urlvars:URLVariables = new URLVariables();
			
			//urlvars.url = "http://twitter.com/statuses/public_timeline.xml";
			
			var urlreq:URLRequest = new URLRequest();
			urlreq.url = "http://twitter.com/statuses/public_timeline.xml"; 
			urlreq.data = urlvars;
			
			http.request = urlreq;
			
			this.http.addEventListener(ResultEvent.RESULT, getPublicTimelineResult);
			this.http.addEventListener(FaultEvent.FAULT, getPublicTimelineFault);
			
			//this.http.send();
			try
			{
				var loader:URLLoader = new URLLoader(urlreq);
				
				loader.load(urlreq);
				loader.addEventListener(Event.COMPLETE, this.getPublicTimelineComplete);
				
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
				Alert.show(event.toString());	
			}
			catch (e:Error) {
				Alert.show(e.toString());
			}
		}
		
		public function getPublicTimelineResult(event:ResultEvent):void {
			HTTPService(event.target).removeEventListener(ResultEvent.RESULT, postPublicResult);
			var xml:XML = new XML(event.result);
			
			this.listenerPublicTimeline(true, xml);
		}
		
		public function getPublicTimelineFault(event:FaultEvent):void {			
			HTTPService(event.target).removeEventListener(FaultEvent.FAULT, postPublicFault);			
			var xml:XML = new XML(event.fault);
			
			this.listenerPublicTimeline(false, xml);
		}
		
		/*
		public function upload(listener:Function):void
		{
			this.listener = listener;
			
			this.file = new File();			
			this.file.addEventListener(Event.SELECT, fileSelected);
			
			this.file.browse( new Array( new FileFilter( "Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png" ) ) );
		}
		
		public function uploadFile(file:File, listener:Function):void
		{
			this.listener = listener;
			
			var urlRequest:URLRequest = new URLRequest("http://twitpic.com/api/upload");
            urlRequest.method = URLRequestMethod.POST;
            
            var urlVars:URLVariables = new URLVariables();
            urlVars.username = this.user;
            urlVars.password = this.password;
            urlRequest.data = urlVars;
            
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);
            file.upload(urlRequest, 'media');
		}
		
		private function fileSelected(event:Event):void
		{
			//var file:File = FileEvent(event).file;
			//uploadFile(file, this.listener);
			uploadFile(this.file, this.listener);
		}
		
		private function uploadComplete(event:DataEvent):void
		{
			//filter the url from the event and pass it to the listener function
			var url:String = (new XML(event.text)).child("mediaurl")[0];
			this.listener(
				url.replace("www.twitpic.com/", "twitpic.com/show/thumb/"),
				url.replace("www.twitpic.com/", "twitpic.com/show/full/")
			);
		}
		*/
	}
}