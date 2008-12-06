package twit
{
	import mx.containers.Box;
	import mx.controls.Image;
	import mx.controls.Text;
	
	public class Twit extends mx.containers.Box
	{
		public function Twit(status:Status)
		{
			this.autoLayout = true;
			this.createBorder();
			//this.opaqueBackground = false;
			
			if (status.text.substr(0, 7) == "[photo]") 
			{
				var img:Image = new Image();
				img.source = status.text.substr(7).replace("twitpic.com/", "twitpic.com/show/thumb/");
				this.addChild(img);
				
				var txt:Text = new Text();
				txt.text = status.text.substr(7);
				this.addChild(txt);
			}
			else
			{
				var txt:Text = new Text();
				txt.text = status.text;
				this.addChild(txt);
			}
		}
	}
}