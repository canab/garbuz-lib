package garbuz.engine.components 
{
	import flash.geom.Point;
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class Position extends Component
	{
		static public function fromPoint(point:Point):Position
		{
			return new Position(point.x, point.y);
		}
		
		public var x:Number;
		public var y:Number;
		
		public function Position(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		public function toString():String
		{
			return "[Position: (" + x + "; " + y + ")]"
		}
		
	}

}