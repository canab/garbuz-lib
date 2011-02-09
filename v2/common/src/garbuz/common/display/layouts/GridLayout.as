package garbuz.common.display.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class GridLayout implements ILayout
	{
		private var _numColumns:int;
		private var _hGridSize:Number;
		private var _vGridSize:Number;
		
		public function GridLayout(numColumns:int, hGridSize:Number, vGridSize:Number)
		{
			_numColumns = numColumns;
			_hGridSize = hGridSize;
			_vGridSize = vGridSize;
		}
		
		/* INTERFACE common.flash.layouts.ILayout */
		
		public function apply(content:DisplayObjectContainer):void
		{
			var column:int = 0;
			var row:int = 0;
			
			for (var i:int = 0; i < content.numChildren; i++) 
			{
				var child:DisplayObject = content.getChildAt(i);
				child.x = column * _hGridSize;
				child.y = row * _vGridSize;
				
				column++;
				if (column == _numColumns)
				{
					column = 0;
					row++;
				}
				
			}
		}
		
	}

}