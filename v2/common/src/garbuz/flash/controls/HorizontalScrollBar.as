package garbuz.flash.controls
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class HorizontalScrollBar extends ScrollBar
	{
		public function HorizontalScrollBar(content:Sprite)
		{
			super(content);
			_dragController.lockVertical = true;
		}
		
		override protected function updatePosition():void
		{
			_position = (_button.x - _line.x) / (_line.width - _button.width);
		}
		
		override public function set position(value:Number):void 
		{
			super.position = value;
			_button.x = _line.x + _position * (_line.width - _button.width);
		}
	}
	
}