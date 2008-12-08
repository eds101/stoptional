package twit
{
	public class UserFull extends User
	{
	/*	
		public var id:String;
		public var name:String; 
		public var screen_name:String;
		public var description:String;
		public var location:String;
		public var profile_image_url:String;
		public var isProtected:Boolean;
		public var followers_count:int;
	*/
		public var friends_count:int;
		public var statuses_count:int;
		public var following:Boolean;
		
		public var profile_background_color:String;
		public var profile_text_color:String;
		public var profile_link_color:String;
		public var profile_sidebar_fill_color:String;
		public var profile_sidebar_border_color:String;
		
		public function UserFull(xml:XML)
		{
			super(xml);

			this.friends_count = parseInt(xml.child("friends_count"));
			this.statuses_count = parseInt(xml.child("statuses_count"));
			this.following = (xml.child("following") == "true")
			
			this.profile_background_color = (xml.child("profile_background_color"));
			this.profile_text_color = (xml.child("profile_text_color"));
			this.profile_link_color = (xml.child("profile_link_color"));
			this.profile_sidebar_fill_color = (xml.child("profile_sidebar_fill_color"));
			this.profile_sidebar_border_color = (xml.child("profile_sidebar_border_color"));
		}
	}
}