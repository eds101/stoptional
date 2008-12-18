package twit
{
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;
			
	public class Twit extends mx.containers.Canvas
	{
		public var text = "";
		public var imageUrl:String = "";
		public var thumbUrl:String = "";
		public var fullUrl:String = "";
		
		private var txt:Text;
		private var img:Image;
		
		public function Twit()
		{
			this.autoLayout = true;
			this.setStyle("width", "100%");
			this.setStyle("backgroundAlpha", "0.5");
			this.setStyle("backgroundColor", Settings.getBordercolor());
			
			this.createBorder();
			this.borderMetrics.top = 2;
			this.borderMetrics.left = 2;
			this.borderMetrics.right = 2;
			this.borderMetrics.bottom = 2;
			//this.opaqueBackground = false;
			
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			
						
			this.addEventListener(ResizeEvent.RESIZE, this.resize);
		}
		
		public function setImage(url:String):void {
			var regex:RegExp = new RegExp;
			regex = /%20/g;
			url = url.replace(regex, " ");
			
			this.imageUrl = url;
			this.thumbUrl = url.replace("twitpic.com/", "twitpic.com/show/thumb/");
			this.thumbUrl = thumbUrl.replace(".jpg", "_thumb.jpg");
			this.fullUrl = url.replace("twitpic.com/", "twitpic.com/show/full/");
								
			img = new Image();
			img.source = this.thumbUrl;
			img.width = 150;
			img.height = 150;
			this.addChild(img);
			
			txt = new Text();
			txt.text = this.imageUrl;
			txt.setStyle("color", Settings.getLinkcolor());
			this.addChild(txt);
		}
		
		public function setText(text:String) {
			this.text = text;
				
			txt = new Text();
			txt.setStyle("color", Settings.getTextcolor());
			txt.setStyle("fontWeight", "bold");
			txt.setStyle("fontSize", "14");
			txt.text = this.text;
			
			//txt.height = 20;
			this.addChild(txt);
		}
		
		private function resize(event:ResizeEvent) {
			this.height = 20;
			
			for each (var item:DisplayObject in this.getChildren()) {
				item.width = this.width;
				if (item.height > this.height) this.height = item.height;
			}
		}
	}
}
