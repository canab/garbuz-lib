package garbuz.flash.controls
{
	import flash.display.Sprite;
	import garbuz.common.utils.MathUtil;
	/**
	 * ...
	 * @author Canab
	 */
	public class VerticalScrollBar extends ScrollBar
	{
		public function VerticalScrollBar(content:Sprite)
		{
			super(content);
			
			_dragController.lockHorizontal = true;
		}
		
		override protected function updatePosition():void
		{
			_position = (_button.y - _line.y) / (_line.height - _button.height);
			if (_position > 0.99)
				_position = 1.0;
			else if (_position < 0.01)
				_position = 0.0;
		}
		
		override public function set position(value:Number):void 
		{
			super.position = value;
			_button.y = _line.y + _position * (_line.height - _button.height);
		}
	}
	
}