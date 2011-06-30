package garbuz.controls
{
	import flash.display.Sprite;

	import garbuz.common.localization.MessageBundle;
	import garbuz.common.query.fromDisplay;

	public class ImageButton extends PushButton
	{
		private var _image:Sprite;

		public function ImageButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick, bundle);
		}

		override protected function assignStates():void
		{
			var children:Array = fromDisplay(this).findAll();

			_image = children.pop();
			_upState = children.pop();
			_overState = (children.length > 0) ? children.pop() : _upState;
			_downState = (children.length > 0) ? children.pop() : _overState;
		}

		public function get image():Sprite
		{
			return _image;
		}
	}
}
