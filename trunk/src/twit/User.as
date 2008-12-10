package twit
{
	public class User
	{
		private var xml:XML;
		public var id:String;
		public var name:String; 
		public var screen_name:String;
		public var description:String;
		public var location:String;
		public var profile_image_url:String;
		public var isProtected:Boolean;
		public var followers_count:int;
				
		public function User(xml:XML)
		{
			this.xml = xml;
			this.id = xml.child("id");
			this.name = xml.child("name");
			this.screen_name = xml.child("screen_name");
			this.description = xml.child("description");
			this.location = xml.child("location");
			this.profile_image_url = xml.child("profile_image_url");
			this.isProtected = (xml.child("protected") == "true");
			this.followers_count = parseInt(xml.child("followers_count"));
		}
	}
}