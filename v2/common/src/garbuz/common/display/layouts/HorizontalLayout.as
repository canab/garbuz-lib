package garbuz.common.display.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class HorizontalLayout implements ILayout
	{
		private var _distance:int;
		
		public function HorizontalLayout(distance:Number = -1)
		{
			_distance = distance;
		}
		
		/* INTERFACE common.flash.layouts.ILayout */
		
		public function apply(content:DisplayObjectContainer):void
		{
			var x:Number = 0;
			
			for (var i:int = 0; i < content.numChildren; i++) 
			{
				var child:DisplayObject = content.getChildAt(i);
				child.x = x;
				x += (_distance > 0) ? _distance : child.width;
			}
		}
		
	}

}