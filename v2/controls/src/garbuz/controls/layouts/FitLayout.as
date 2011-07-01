package garbuz.controls.layouts
{
	import garbuz.controls.Container;
	import garbuz.controls.ControlBase;
	import garbuz.controls.interfaces.ILayout;

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
				item.validate();
			}
		}
	}
}
