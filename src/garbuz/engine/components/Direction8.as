package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class Direction8 extends DataComponent
	{
		public static const UP:int         = 0;
		public static const RIGHT_UP:int   = 1;
		public static const RIGHT:int      = 2;
		public static const RIGHT_DOWN:int = 3;
		public static const DOWN:int       = 4;
		public static const LEFT_DOWN:int  = 5;
		public static const LEFT:int       = 6;
		public static const LEFT_UP:int    = 7;
		
		static public function getRightDirection(direction:int):int
		{
			if (direction == LEFT_UP)
				return RIGHT_UP;
			else if (direction == LEFT)
				return RIGHT;
			else if (direction == LEFT_DOWN)
				return RIGHT_DOWN;
			else
				return direction;
		}
		
		private var _value:int = 0;
		
		public function Direction8(newValue:int = DOWN) 
		{
			_value = newValue;
		}
		
		public function setFromCoords(xDiff:Number, yDiff:Number):void
		{
			//noinspection JSSuspiciousNameCombinationInspection
			var angle:Number = (Math.atan2(yDiff, xDiff)) / Math.PI * 180 + 90;
			
			if (angle < 0)
				angle += 360;
			
			value = Math.round(angle / 45.0) % 8;
		}
		
		public function get value():int { return _value; }
		public function set value(newValue:int):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
		
	}

}