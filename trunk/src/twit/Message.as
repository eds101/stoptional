package twit
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;
	
	public class Message extends Canvas
	{
		private var xmls:Array = new Array();
		private var images:Array = new Array();
		private var keywords:Array = new Array();
		
		private var grid:Grid = new Grid();
		private var menu:Menu = new Menu();
		private var box:Box = new Box();
		
		private var infoContainer:HBox = new HBox();
		private var textContainer:Box = new Box();
		private var imageContainer:HBox = new HBox();
		private var keywordContainer:HBox = new HBox();
		
		public const STATUS_MESSAGE:int = 0;
		public const PRIVATE_MESSAGE:int = 1;
		
		private var msgType:int;
		
		public var author:String = "";
		
		public function Message():void {
			this.setStyle("backgroundColor", Settings.getBackcolor());
			
			//this.menu.setLabels(["Delete", "More Info", "Archive", "Enlarge"]);
			this.menu.setMenuSelectionListener(menuSelectionListener);
			this.menu.visible = false;
			
			this.box.addChild(this.infoContainer);
			this.box.addChild(this.keywordContainer);
			this.box.addChild(this.imageContainer);
			this.box.addChild(this.textContainer);
			
			this.addChild(this.menu);
			this.addChild(this.box);
			
			this.autoLayout = true;
			this.setStyle("backgroundAlpha", "0.5");
			this.setStyle("borderWidth", "2");
			this.setStyle("borderColor", Settings.getBordercolor());
			this.setStyle("backgroundColor", Settings.getFillcolor());
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
		
		public function setStatus(s:Status) {
			var user:User = s.user;
			this.author = user.screen_name;
			
			var img:Image = new Image();
			img.source = user.profile_image_url;
			this.infoContainer.addChild(img);
			
			var lbl:Label = new Label();
			lbl.text = this.author;
			this.infoContainer.addChild(lbl);
			this.infoContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.infoContainer.verticalScrollPolicy = ScrollPolicy.OFF;
			
			lbl = new Label();
			lbl.text = user.name;
			this.infoContainer.addChild(lbl);
			
			lbl = new Label();
			lbl.text = user.location;
			this.infoContainer.addChild(lbl);
			
			lbl = new Label();
			lbl.text = s.created_at;
			this.infoContainer.addChild(lbl);
		}
		
		public function setDirect(d:Direct) {
			var user:User = d.sender;
			this.author = user.screen_name;
			
			var img:Image = new Image();
			img.source = user.profile_image_url;
			this.infoContainer.addChild(img);
			
			var lbl:Label = new Label();
			lbl.text = this.author;
			this.infoContainer.addChild(lbl);
			this.infoContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.infoContainer.verticalScrollPolicy = ScrollPolicy.OFF;
			
			lbl = new Label();
			lbl.text = user.name;
			this.infoContainer.addChild(lbl);
			
			lbl = new Label();
			lbl.text = user.location;
			this.infoContainer.addChild(lbl);
			
			lbl = new Label();
			lbl.text = d.created_at;
			this.infoContainer.addChild(lbl);
		}
		
		public function hasKeyword(key:String):Boolean {
			return (this.keywords.indexOf(key.toLowerCase()) >= 0)
		}
		public function getPhotos():Array {
			return this.images;
		}
		
		public function setMsgType(type:int):void {
			this.msgType = type;
			switch(type) {
			
				case this.STATUS_MESSAGE:
					this.menu.setLabels(["Delete", "More Info", "Archive", "Enlarge"]);
					
				break;
			
				case this.PRIVATE_MESSAGE:
					this.menu.setLabels(["Delete", "More Info", "Archive", "Enlarge"]);
					
				break;
			
			}
		}
		
		public function addXML(xml:XML) {
			this.xmls.push(xml);
		}
		
		public function getXMLs():Array {
			return this.xmls;
		}
		
		public function addStatus(s:Status) {
			var txt:String = s.text;
			var t:Twit;
			if (txt.substr(0, 7) == "[photo]") {
				for each (var src:String in txt.substr(7).split(" ")) {
					if (src.length > 0) {
						t = new Twit();
						t.setImage(src);
						this.addTwit(t);
					}
				}
			}
			else
			{
				t = new Twit();
				t.setText(txt);
				this.addTwit(t);
			}
		}
		
		public function addDirect(d:Direct) {
			var txt:String = d.text;
			var t:Twit;
			if (txt.substr(0, 7) == "[photo]") {
				for each (var src:String in txt.substr(7).split(" ")) {
					if (src.length > 0) {
						t = new Twit();
						t.setImage(src);
						this.addTwit(t);
					}
				}
			}
			else
			{
				t = new Twit();
				t.setText(txt);
				this.addTwit(t);
			}
		}
		
		public function archive() {
			Settings.archive(this.xmls);
		}
		
		private function markBegin(event:MouseEvent):void {
			this.setChildIndex(this.box, 0);
			this.menu.visible = true;
		}
		private function markEnd(event:MouseEvent):void {
			this.setChildIndex(this.menu, 0);
			this.menu.visible = false;
		}
		
		private function menuSelectionListener(selection:int, label:String):void {
			switch(label) {
				case "Archive":
					this.archive();
				break;
				
				case "Delete":
					this.parent.removeChild(this);
				break;
				
				
			}
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
				
				this.infoContainer.width = this.width;
				this.textContainer.width = this.width;
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
					this.keywords.push(key.toLowerCase());
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