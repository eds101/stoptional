package twit
{
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	public class Twit extends mx.containers.Box
	{
		public var text = "";
		public var imageUrl:String = "";
		public var thumbUrl:String = "";
		public var fullUrl:String = "";
		
		public function Twit(status:Status)
		{
			this.autoLayout = true;
			//this.setStyle("width", "100%");
			this.setStyle("backgroundAlpha", "0.5");
			this.setStyle("backgroundColor", "#3f3f3f");
			
			this.createBorder();
			this.borderMetrics.top = 2;
			this.borderMetrics.left = 2;
			this.borderMetrics.right = 2;
			this.borderMetrics.bottom = 2;
			//this.opaqueBackground = false;
			
			if (status.text.substr(0, 7) == "[photo]")
			{
				this.imageUrl = status.text.substr(7);
				this.thumbUrl = imageUrl.replace("twitpic.com/", "twitpic.com/show/thumb/");
				this.fullUrl = imageUrl.replace("twitpic.com/", "twitpic.com/show/full/");
				
				var img:Image = new Image();
				img.source = this.thumbUrl;
				this.addChild(img);
				
				var txt:Text = new Text();
				txt.text = this.imageUrl;
				txt.setStyle("color", Settings.getLinkcolor());
				this.addChild(txt);
			}
			else
			{
				this.text = status.text;
				
				var txta:TextArea = new TextArea();
//				txta.editable = false;
				txta.horizontalScrollPolicy = ScrollPolicy.OFF;
				txta.verticalScrollPolicy = ScrollPolicy.OFF;
				txta.wordWrap = true;
//				txta.height = txta.textHeight;
				txta.setStyle("color", Settings.getTextcolor());
				txta.setStyle("width", "100%");							
				this.addChild(txta);
				txta.addEventListener(FlexEvent.VALUE_COMMIT, function(event:FlexEvent) {
					txta.validateNow();
					txta.height = txta.textHeight + 10;
				});		
				txta.addEventListener(MouseEvent.CLICK, function(event:MouseEvent) {
					txta.validateNow();
					txta.height = txta.textHeight + 10;
				});
				txta.htmlText = this.text;
				txta.validateNow();
				txta.text = this.text;
				
			}
		}
	}
}