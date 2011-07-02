package garbuz.controls.layouts
{
	import garbuz.controls.interfaces.ILayout;
	import garbuz.gui.controls.Container;
	import garbuz.gui.controls.ControlBase;

	public class FitLayout implements ILayout
	{
		public function FitLayout()
		{
		}

		public function apply(container:Container):void
		{
			for each (var item:ControlBase in container.controls)
			{
				item.move(0, 0);
				item.setSize(container.width, container.height);
			}
		}
	}
}
