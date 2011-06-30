package garbuz.controls
{
	import garbuz.common.ui.Anchor;
	import garbuz.common.utils.ArrayUtil;
	import garbuz.controls.interfaces.ILayout;

	public class Container extends ControlBase
	{
		private var _controls:Array = [];
		private var _anchors:Array = [];
		private var _layout:ILayout;

		public function Container()
		{
		}

		public function addAnchor(
			source:Object, sourceProp:String,
			target:Object, targetProp:String,
			multiplier:Number = 1.0):void
		{
			_anchors.push(new Anchor(source, sourceProp, target, targetProp, multiplier));
		}

		public function addControls(controls:Object):void
		{
			for each (var control:ControlBase in controls)
			{
				addControl(control);
			}
		}

		public function addControl(control:ControlBase):void
		{
			_controls.push(control);
			addChild(control);
		}

		public function removeControl(control:ControlBase):void
		{
			ArrayUtil.removeItem(_controls, control);
			removeChild(control);
		}

		public function removeAllControls():void
		{
			while (_controls.length > 0)
			{
				removeControl(_controls[0]);
			}
		}

		override public function applyLayout():void
		{
			for each (var item:ControlBase in _controls)
			{
				item.applyLayout();
			}

			for each (var anchor:Anchor in _anchors)
			{
				anchor.apply();
			}

			if (_layout)
				_layout.apply(this);

			super.applyLayout();
		}

		override protected function applyEnabled():void
		{
			for each (var control:ControlBase in _controls)
			{
				control.enabled = enabled;
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get controls():Array
		{
			return _controls.slice();
		}

		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			_layout = value;

			if (!_layoutSuspended)
				applyLayout();
		}
	}

}