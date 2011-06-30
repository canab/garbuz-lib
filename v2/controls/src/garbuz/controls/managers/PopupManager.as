package garbuz.controls.managers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import garbuz.common.events.EventManager;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.controls.ControlBase;

	public class PopupManager
	{
		private static const AUTO_HIDE_DISTANCE:int = 75;

		private static var _instance:PopupManager;
		
		public static function get instance():PopupManager
		{
			if (!_instance)
				_instance = new PopupManager(new PrivateConstructor());

			return _instance;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _currentControl:ControlBase;
		private var _relatedControl:ControlBase;
		private var _uiManager:UIManager = UIManager.instance;
		private var _events:EventManager = new EventManager();

		//noinspection JSUnusedLocalSymbols
		public function PopupManager(singleton:PrivateConstructor)
		{
		}

		public function showPopup(control:ControlBase, relatedControl:ControlBase):void
		{
			if (_currentControl)
				hideControl();

			_currentControl = control;
			_relatedControl = relatedControl;

			if (_currentControl)
				showControl();
		}

		private function showControl():void
		{
			DisplayUtil.claimBounds(_currentControl, _uiManager.bounds);

			_uiManager.root.addChild(_currentControl);

			_events.registerNativeEvent(_uiManager.root, Event.DEACTIVATE, hideControl);
			_events.registerNativeEvent(_uiManager.root, Event.ENTER_FRAME, onEnterFrame);
			_events.registerNativeEvent(_relatedControl, Event.REMOVED_FROM_STAGE, hideControl);
			_events.registerNativeEvent(_currentControl, Event.REMOVED_FROM_STAGE, onRemoved);
			_events.registerNativeEvent(_uiManager.stage, MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onEnterFrame(event:Event):void
		{
			var bounds:Rectangle = _currentControl.getBounds(_currentControl);
			bounds.left -= AUTO_HIDE_DISTANCE;
			bounds.top -= AUTO_HIDE_DISTANCE;
			bounds.right += AUTO_HIDE_DISTANCE;
			bounds.bottom += AUTO_HIDE_DISTANCE;

			var mousePos:Point = new Point(_currentControl.mouseX,  _currentControl.mouseY);

			if (!bounds.containsPoint(mousePos))
				hideControl();
		}

		private function onMouseDown(event:MouseEvent):void
		{
			if (!hitControl(_currentControl) && !hitControl(_relatedControl))
				hideControl();
		}

		private function hitControl(control:ControlBase):Boolean
		{
			var bounds:Rectangle = control.getBounds(control);
			var mousePos:Point = new Point(control.mouseX,  control.mouseY);
			return bounds.containsPoint(mousePos);
		}

		private function hideControl(event:Event = null):void
		{
			_events.clearEvents();
			DisplayUtil.detachFromDisplay(_currentControl);
			_currentControl = null;
		}

		private function onRemoved(e:Event):void
		{
			_events.clearEvents();
			_currentControl = null;
		}
	}
}

internal class PrivateConstructor {}
