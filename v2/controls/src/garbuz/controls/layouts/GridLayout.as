package garbuz.controls.layouts
{
	import garbuz.controls.interfaces.ILayout;
	import garbuz.gui.controls.Container;
	import garbuz.gui.controls.ControlBase;

	public class GridLayout implements ILayout
	{
		private var _hSize:int;
		private var _vSize:int;
		private var _numColumns:int;

		public function GridLayout(hSize:int, vSize:int, numColumns:int)
		{
			_hSize = hSize;
			_vSize = vSize;
			_numColumns = numColumns;
		}

		public function apply(container:Container):void
		{
			var x:int = 0;
			var y:int = 0;
			var column:int = 0;

			for each (var item:ControlBase in container.controls)
			{
				item.x = x;
				item.y = y;

				x += _hSize;

				if (++column == _numColumns)
				{
					x = 0;
					y += _vSize;
					column = 0;
				}
			}
		}
	}
}
