package twit
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.events.ResizeEvent;
	
	public class Menu extends Canvas
	{
		private var centerX:uint;
		private var centerY:uint;
		
		private var labels:Array = new Array();
		private var selection:int = -1;
		
		private var menuSelectionListener:Function;
		
		public function Menu()
		{
			this.alpha = 0.5;
			this.addEventListener(MouseEvent.RIGHT_MOUSE_UP, this.mouseUp);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, this.mouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			this.addEventListener(ResizeEvent.RESIZE, this.resize);
			
			this.resize(new ResizeEvent(ResizeEvent.RESIZE, false, true, this.width, this.height));			
		}
		
		public function setMenuSelectionListener(listener:Function) {
			
			this.menuSelectionListener = listener;
			
		}
		
		public function setLabels(strings:Array) {
			this.removeAllChildren();
			this.labels = new Array();
			
			for (var i:int = 0; i < strings.length; i++) {
				var l:Label = new Label();
				l.setStyle("fontWeight", "bold");
				l.setStyle("fontSsize", "16pt");
				l.text = strings[i];
				
				var angle:Number = i * 2 / strings.length;
				angle *= Math.PI; 
				l.x = Math.cos(angle) * this.height / 2;
				l.y = Math.sin(angle) * this.height / 2;
				
				this.labels.push(l);
				this.addChild(l);
			}
		}
		
		private function mouseDown(event:MouseEvent):void {
			this.centerX = event.localX;
			this.centerY = event.localY;
		}
		
		private function mouseUp(event:MouseEvent):void {
			if (this.selection > -1) {
				this.menuSelectionListener(this.selection, this.labels[this.selection].text);
			}
		}
		
		private function mouseMove(event:MouseEvent):void
		{
			if (event.target == event.currentTarget)
			{
				var X:int = event.localX - centerX;
				var Y:int = event.localY - centerY;
				
				var angle = Math.atan2(Y, X);
				angle /= Math.PI;
				
				angle *= (this.labels.length * 2);
				angle += (this.labels.length * 4) + 1;
				angle /= 2;
				angle %= (this.labels.length * 2);
				
				angle = int(angle);
				
				var radius:uint = int(Math.sqrt(X*X + Y*Y));
				
				this.selection = -1;
				for (var i:int = 0; i < this.labels.length; i++)
				{
					if (radius > 20 && radius < 100 && angle % 2 == 0 && angle / 2 == i)
					{
						this.labels[i].setStyle("color", "#ffffff");
						this.selection = i;						
					}
					else
					{
						this.labels[i].setStyle("color", "#000000");
					}
				}
			}
		}
		
		private function resize(event:ResizeEvent) {
			this.centerX = this.width / 2;
			this.centerY = this.height / 2;
			
			moveMenu();
		}
		
		private function moveMenu() {
			for (var i:int = 0; i < this.labels.length; i++) {
				var l:Label = this.labels[i];
				
				var angle:Number = i * 2 / this.labels.length;
				angle *= Math.PI;
				l.x = this.centerX + Math.cos(angle) * 50 - l.width/2;
				l.y = this.centerY + Math.sin(angle) * 50 - l.height/2;
			}
		}
		
		public function setCenter(x:int, y:int) {
			this.centerX = x;
			this.centerY = y;
			
			moveMenu();
		}
	}
}