package twit
{
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import mx.controls.Alert;
	
	public class Settings
	{
		private static var textcolor:String;
		private static var backcolor:String;
		private static var linkcolor:String;
		private static var fillcolor:String;
		private static var bordercolor:String;
		private static var archiveDir:File = File.applicationStorageDirectory;
		private static var numItemsPerPage:int;
		public static const ARCHIVE_XML_FILE:File = File.applicationStorageDirectory.resolvePath("archive.xml");
		
		private static const DEFAULT_NUM_ITEMS_PER_PAGE = 50;
		
		public function Settings()
		{
		}
		
		public static function getSettingsFromFile():void {
			//this function runs once when the program starts in order to create our settings and archive files if they don't exist and to grab the user's
				// settings from persistent storage if they are indeed persisted.
				if (!ARCHIVE_XML_FILE.exists) {
					var fs:FileStream = new FileStream();
					fs.open(ARCHIVE_XML_FILE, FileMode.WRITE);
					fs.writeUTFBytes(new String("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"));
					fs.close();
					
			}
			
			/*var file:File = new File(File.applicationStorageDirectory.nativePath + "\\settings.xml");
			Alert.show(File.applicationStorageDirectory.nativePath + "\\settings.xml");
			var myXML:XML = new XML();
			var data:Object = new Object();
			data["numItemsPerPage"] = 50;
			myXML.appendChild(data);
			Alert.show(myXML.toString());
			if (!file.exists) {
					numItemsPerPage = DEFAULT_NUM_ITEMS_PER_PAGE;
					var fs:FileStream = new FileStream();
					fs.open(file, FileMode.WRITE);
					fs.writeUTFBytes((new String("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")).concat((new XML(numItemsPerPage)).toXMLString()));
					
			}*/
			
			/*personXML.firstName = fName_txti.text;
			personXML.lastName = lName_txti.text;
			var newXMLStr:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + personXML.toXMLString();
			
			fs.writeUTFBytes(newXMLStr);
			fs.close(); */
		}
		
		public static function setTextcolor(color:String):void 
		{
			textcolor = color;
		}
		public static function getTextcolor():String 
		{
			return textcolor;
		}
		
		
		public static function setBackcolor(color:String):void 
		{
			backcolor = color;
		}
		public static function getBackcolor():String 
		{
			return backcolor;
		}
		
		public static function setLinkcolor(color:String):void 
		{
			linkcolor = color;
		}
		public static function getLinkcolor():String 
		{
			return linkcolor;
		}

		
		public static function setFillcolor(color:String):void 
		{
			fillcolor = color;
		}
		public static function getFillcolor():String 
		{
			return fillcolor;
		}
		
		
		
		public static function setBordercolor(color:String):void 
		{
			bordercolor = color;
		}
		public static function getBordercolor():String 
		{
			return bordercolor;
		}
		
		public static function setNumItemsPerPage(numItems:int):void {
			numItemsPerPage = numItems;
			persistSettings();
		}
		
		private static function persistSettings():void {
				
		}
		
		
		 private static function writeArchiveImageFile(evt:Event, fileName:String, stream:URLStream):void {
			var fileData:ByteArray = new ByteArray();
			stream.readBytes(fileData,0,stream.bytesAvailable);
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(fileData,0,fileData.length);
			fileStream.close();
		}
		
		public static function archive(statuses:Array):void {
			var fs:FileStream = new FileStream();
			
			fs.open(ARCHIVE_XML_FILE, FileMode.APPEND);
			for each (var item:XML in statuses) {
				fs.writeUTFBytes(item.toXMLString());
				if(item.child("text").toString().substr(0,7) == "[photo]") {
					for each (var url:String in item.child("text").toString().substr(7).split(' ')) {
						var req:URLRequest = new URLRequest(url.replace("twitpic.com/", "twitpic.com/show/full/"));
						var stream:URLStream= new URLStream();
						stream.addEventListener(Event.COMPLETE, function (e:Event) : void {
                  				writeArchiveImageFile(e,url.substr(19).concat(".jpg"), stream);
           			 		});
						stream.load(req);	
						
						req = new URLRequest(url.replace("twitpic.com/", "twitpic.com/show/thumb/"))
						var stream2:URLStream= new URLStream();
						stream2.addEventListener(Event.COMPLETE, function (e:Event) : void {
                  				writeArchiveImageFile(e,url.substr(19).concat("_thumb.jpg"), stream2);
           			 		});
						stream2.load(req);	
					}
				}
			}
			fs.close();
		}
	
	}
}