package twit
{
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.events.ResizeEvent;
	
	public class Twit extends mx.containers.Canvas
	{
		public var text = "";
		public var imageUrl:String = "";
		public var thumbUrl:String = "";
		public var fullUrl:String = "";
		
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
			
			this.addEventListener(ResizeEvent.RESIZE, this.resize);
		}
		
		public function setImage(url:String):void {
			this.imageUrl = url;
			this.thumbUrl = url.replace("twitpic.com/", "twitpic.com/show/thumb/");
			this.thumbUrl = imageUrl.replace(".jpg", "_thumb.jpg");
			this.fullUrl = url.replace("twitpic.com/", "twitpic.com/show/full/");
			
			var img:Image = new Image();
			img.source = this.thumbUrl;
			img.width = 150;
			img.height = 150;
			this.addChild(img);
			
			var txt:Text = new Text();
			txt.text = this.imageUrl;
			txt.setStyle("color", Settings.getLinkcolor());
			this.addChild(txt);
		}
		
		public function setText(text:String) {
			this.text = text;
				
			var txta:Text = new Text();
			txta.setStyle("color", Settings.getTextcolor());
			txta.text = this.text;
			txta.height = 16;						
			this.addChild(txta);
		}
		
		private function resize(event:ResizeEvent) {
			this.height = 0;
			for each (var item:DisplayObject in this.getChildren()) {
				item.width = this.width;
				if (item.height > this.height) this.height = item.height;
			}
		}
	}
}
