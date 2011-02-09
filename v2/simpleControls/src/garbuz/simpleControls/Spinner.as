package garbuz.simpleControls
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author canab
	 */
	public class Spinner
	{
		static public const UP_NAME:String = 'btnUp';
		static public const DOWN_NAME:String = 'btnDown';
		static public const FIELD_NAME:String = 'txtValue';
		
		private var _content:Sprite;
		private var _value:Number = 0;
		private var _minValue:Number = Number.NEGATIVE_INFINITY;
		private var _maxValue:Number = Number.POSITIVE_INFINITY;
		private var _step:Number = 1.0;
		
		public function Spinner(content:Sprite) 
		{
			_content = content;
			initialize();
			refresh();
		}
		
		private function initialize():void
		{
			upButton.addEventListener(MouseEvent.CLICK, onUpClick);
			downButton.addEventListener(MouseEvent.CLICK, onDownClick);
		}
		
		private function onUpClick(e:MouseEvent):void 
		{
			value += step;
		}
		
		private function onDownClick(e:MouseEvent):void 
		{
			value -= step;
		}
		
		public function get upButton():InteractiveObject
		{
			return _content[UP_NAME];
		}
		
		public function get downButton():InteractiveObject
		{
			return _content[DOWN_NAME];
		}
		
		public function get valueField():TextField
		{
			return _content[FIELD_NAME];
		}
		
		public function get value():Number { return _value; }
		public function set value(newValue:Number):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				checkRanges();
				refresh();
			}
		}
		
		public function get newValue():Number { return _minValue; }
		public function set minValue(newValue:Number):void 
		{
			if (_minValue != newValue)
			{
				_minValue = newValue;
				checkRanges();
				refresh();
			}
		}
		
		public function get maxValue():Number { return _maxValue; }
		public function set maxValue(newValue:Number):void 
		{
			if (_maxValue != newValue)
			{
				_maxValue = newValue;
				checkRanges();
				refresh();
			}
		}
		
		public function get step():Number { return _step; }
		public function set step(value:Number):void 
		{
			_step = value;
		}
		
		private function checkRanges():void
		{
			_value = Math.min(_value, _maxValue);
			_value = Math.max(_value, _minValue);
		}
		
		private function refresh():void
		{
			valueField.text = String(_value);
		}
	}

}