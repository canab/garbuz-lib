package garbuz.simpleControls
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Canab
	 */
	public class ProgressBar
	{
		static public const LINE_NAME:String = 'mcLine';
		
		private var _line:Sprite;
		private var _lineStartX:Number;
		private var _lineEndX:Number;
		private var _content:Sprite;
		
		private var _value:Number;
		
		public function ProgressBar(content:Sprite) 
		{
			_content = content;
			_line = content[LINE_NAME];
			_lineEndX = _line.x;
			_lineStartX = _line.x - _line.width;
			
			value = 0;
		}
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			if (value < 0)
				_value = 0;
			else if (value > 1)
				_value = 1;
			else
				_value = value;
				
			_line.x = _lineStartX + value * (_lineEndX - _lineStartX);
		}
		
		public function get visible():Boolean
		{
			return _content.visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_content.visible = value;
		}
		
		public function get content():Sprite { return _content; }
		
	}

}