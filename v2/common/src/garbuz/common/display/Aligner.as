package garbuz.common.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class Aligner
	{
		static public const TOP:String = "top";
		static public const BOTTOM:String = "bottom";
		static public const CENTER:String = "center";
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		static public const NONE:String = "none";
		
		private var _object:DisplayObject;
		private var _bounds:Rectangle;
		
		public function Aligner(object:DisplayObject, bounds:Rectangle) 
		{
			_object = object;
			_bounds = bounds;
		}
		
		public function align(horizontal:String, vertical:String):void 
		{
			var objectBounds:Rectangle = _object.getBounds(_object.parent);
			var x:Number = objectBounds.x;
			var y:Number = objectBounds.y;
			
			if (horizontal == LEFT)
				x = _bounds.left;
			else if (horizontal == CENTER)
				x = 0.5 * (_bounds.left + _bounds.right - objectBounds.width);
			else if (horizontal == RIGHT)
				x = _bounds.right - objectBounds.width;
				
			if (vertical == TOP)
				y = _bounds.top;
			else if (vertical == CENTER)
				y = 0.5 * (_bounds.top + _bounds.bottom - objectBounds.height);
			else if (vertical == BOTTOM)
				y = _bounds.bottom - objectBounds.height;
				
			_object.x += x - objectBounds.left;
			_object.y += y - objectBounds.top;
		}
		
		public function alignCenter():void 
		{
			align(CENTER, CENTER);
		}		
		
		
	}

}