package garbuz.controls.layouts
{
	import garbuz.controls.interfaces.ILayout;
	import garbuz.gui.DefaultStyle;
	import garbuz.gui.controls.Container;
	import garbuz.gui.controls.ControlBase;

	public class TileLayout implements ILayout
	{
		private var _hGap:int;
		private var _vGap:int;

		public function TileLayout(hGap:int = DefaultStyle.H_GAP, vGap:int = DefaultStyle.V_GAP)
		{
			_hGap = hGap;
			_vGap = vGap;
		}

		public function apply(container:Container):void
		{
			if (container.controls.length == 0)
				return;

			var item:ControlBase = ControlBase(container.controls[0]);
			var itemWidth:int = item.width;
			var itemHeight:int = item.height;
			var columnCount:int = getNumColumns(container.width, itemWidth);
			var columnNum:int = 0;

			var x:int = 0;
			var y:int = 0;

			for each (item in container.controls)
			{
				item.x = x;
				item.y = y;

				x += item.width + _hGap;

				if (++columnNum == columnCount)
				{
					x = 0;
					y += itemHeight + _vGap;
					columnNum = 0;
				}
			}
		}

		public function getNumRows(containerHeight:int, itemHeight:int):int
		{
			var numRows:Number = (containerHeight + _vGap) / (itemHeight + _vGap);
			return int(Math.max(numRows, 1));
		}

		public function getNumColumns(containerWidth:int, itemWidth:int):int
		{
			var numColumns:Number = (containerWidth + _hGap) / (itemWidth + _hGap);
			return int(Math.max(numColumns, 1));
		}

		public function getItemsCount(container:Container, renderer:ControlBase):int
		{
			return getNumRows(container.height, renderer.height)
				* getNumColumns(container.width, renderer.width);
		}

	}
}
