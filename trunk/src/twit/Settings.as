package twit
{
	public class Settings
	{
		private static var textcolor:String;
		private static var backcolor:String;
		private static var linkcolor:String;
		private static var fillcolor:String;
		private static var bordercolor:String;
		
		public function Settings()
		{
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
	}
}