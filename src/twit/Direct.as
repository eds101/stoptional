package twit
{
	public class Direct
	{
		public var xml:XML;
		public var created_at:String;
		public var id:String;
		public var sender_id:String;
		public var text:String;
		public var recipient_id:String;
		public var sender_screen_name:String;
		public var recipient_screen_name:String;
		public var sender:User;
		public var recipient:User;
		
		public function Direct(xml:XML)
		{
			this.xml = xml;
			this.created_at = xml.child("created_at");
			this.id = xml.child("id");
			this.sender_id = xml.child("sender_id");
			this.text = xml.child("text");
			this.recipient_id = xml.child("recipient_id");
			this.sender_screen_name = xml.child("sender_screen_name");
			this.recipient_screen_name = xml.child("recipient_screen_name");
			this.sender = new User(xml.child("sender"));
			this.recipient = new User(xml.child("recipient"));					
		}
		
		public function toString():String {
			return this.text;
		}
	}
}