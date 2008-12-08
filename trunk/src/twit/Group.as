package twit
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Text;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;
	
	public class Group extends Canvas
	{
		private var txtLabel:Text;
		private var images:Array = new Array();
		private var keywords:Array = new Array();
		
		private var menu:Menu = new Menu();
		private var box:Box = new Box();
		
		private var imageContainer:HBox = new HBox();
		private var keywordContainer:HBox = new HBox();
		private var textContainer:Box = new Box();
		
		public function Group(text:String):void
		{
			this.setStyle("backgroundColor", Settings.getBackcolor());
			//this.alpha = 0.5;
			this.txtLabel = new Text();
			this.txtLabel.text = text;
			
			var t:Text = new Text();
			t.text = text;
			
			this.box.addChild(t);
			this.box.addChild(this.imageContainer);
			this.box.addChild(this.keywordContainer);
			this.box.addChild(this.textContainer);
			
			this.addChild(this.menu);
			this.addChild(this.box);
			
			this.autoLayout = true;
			this.setStyle("backgroundAlpha", "0.5");
			this.setStyle("backgroundColor", "#3f3f3f");
			this.createBorder();
			this.borderMetrics.top = 2;
			this.borderMetrics.left = 2;
			this.borderMetrics.right = 2;
			this.borderMetrics.bottom = 2;
			
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			this.keywordContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.keywordContainer.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			
			this.imageContainer.verticalScrollPolicy = ScrollPolicy.OFF;
			this.imageContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			//this.imageContainer.resizeToContent = true;
			this.imageContainer.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			
			this.box.addEventListener(ResizeEvent.RESIZE, this.resizeHeight);
			this.addEventListener(ResizeEvent.RESIZE, this.resizeWidth);
			
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, this.markBegin);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_UP, this.markEnd);			
		}
		
		private function markBegin(event:MouseEvent):void {
			this.setChildIndex(this.box, 0);
		}
		private function markEnd(event:MouseEvent):void {
			this.setChildIndex(this.menu, 0);
		}
		
		public function resizeHeight(event:ResizeEvent) {
			if (event.oldHeight != (event.currentTarget.height)) {
				this.height = this.box.height;
				this.menu.height = this.box.height;
			}
		}
		
		public function resizeWidth(event:ResizeEvent) {
			if (event.oldWidth != (event.currentTarget.width)) {
				this.menu.width = this.width;
				this.box.width = this.width;
				
				this.imageContainer.width = this.width;
				this.keywordContainer.width = this.width;
			}
		}
		
		private function mouseMove(event:MouseEvent) {
			var container = (event.currentTarget);
			if (!event.buttonDown && container.getChildren().length > 0) {
				var x:int = event.stageX;
				var c:DisplayObject = container.getChildAt(container.getChildren().length - 1);
				var	w:int = c.x + c.width;
				
				x -= container.x;
				
				container.horizontalScrollPosition = (w - container.width) * (x / container.width);
				//event.stopPropagation();
			} 
		}
		
		public function addTwit(item:Twit):void {
			if (item.imageUrl != "") {
				this.images.push(item.imageUrl);
				this.imageContainer.addChild(item);
				
			} else if (item.text.substr(0, 5) == "[key]") {
				for each (var key:String in item.text.substr(5).split(" ")) {
					this.keywords.push(key);
					this.keywordContainer.addChild(newText(key));
				}
					
			} else {
				this.textContainer.addChild(item);
				
			}	
			
		}
		
		private function newText(text:String):Text {
			var t:Text = new Text();
			t.text = text;
			t.setStyle("color", Settings.getTextcolor());
			return t;
		}		 
	}
}