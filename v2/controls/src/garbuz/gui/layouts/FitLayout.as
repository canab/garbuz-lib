package garbuz.gui.layouts
{
	import garbuz.gui.controls.Container;
	import garbuz.gui.controls.ControlBase;
	import garbuz.gui.interfaces.ILayout;

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
