package twit
{
	public class Status
	{
		private var xml:XML;
		public var created_at:String;
		public var id:String;
		public var text:String;
		public var source:String;
		public var truncated:Boolean;
		public var in_reply_to_status_id:String;
		public var in_reply_to_user_id:String;
		public var favorited:Boolean;
		public var user:User;
		
		public function Status(xml:XML)
		{
			this.xml = xml;
			this.created_at = xml.child("created_at");
			this.id = xml.child("id");
			this.text = xml.child("text");
			this.source = xml.child("source");
			this.truncated = (xml.child("truncated") == "true");
			this.in_reply_to_status_id = xml.child("in_reply_to_status_id");
			this.in_reply_to_user_id = xml.child("in_reply_to_user_id");
			this.favorited = (xml.child("favorited") == "true")
			this.user = new User(new XML(xml.child("user")));			
		}
		
		public function toString():String {
			return this.text;
		}
	}
}