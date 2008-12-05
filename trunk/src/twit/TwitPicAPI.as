package twit
{
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileFilter;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
//    import mx.rpc.http.HTTPService;

	public class TwitPicAPI
	{
//		private var http:HTTPService;
		private var user:String;
		private var password:String;
		private var listener:Function;
		private var file:File;
		
		public function TwitPicAPI(user:String, password:String)
		{
			this.user = user;
			this.password = password;
		}
		
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
			File(event.target).removeEventListener(Event.SELECT, fileSelected);
			
			uploadFile(this.file, this.listener);
		}
		
		private function uploadComplete(event:DataEvent):void
		{			
			File(event.target).removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);
			
			//filter the url from the event and pass it to the listener function
			var url:String = (new XML(event.text)).child("mediaurl")[0];
			this.listener(
				url.replace("twitpic.com/", "twitpic.com/show/thumb/"),
				url.replace("twitpic.com/", "twitpic.com/show/full/")
			);			
		}
	}
}