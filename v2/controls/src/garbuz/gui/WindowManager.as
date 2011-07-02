package garbuz.gui
{
	import flash.events.MouseEvent;

	import garbuz.common.query.from;
	import garbuz.common.ui.DragController;
	import garbuz.common.utils.ArrayUtil;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.controls.WindowBase;
	import garbuz.controls.controls_internal;

	use namespace controls_internal;

	internal class WindowManager extends ManagerBase
	{
		private var _windows:Vector.<WindowBase> = new <WindowBase>[];

		public function WindowManager()
		{
			super();
		}

		public function addWindow(window:WindowBase):void
		{
			ArrayUtil.addItemSafe(_windows, window);
			ui.root.addChild(window);
			new DragController(window, window.hitArea).bounds = ui.bounds;
			window.addEventListener(MouseEvent.MOUSE_DOWN, onWindowMouseDown);
			window.processAdd();
		}

		private function onWindowMouseDown(event:MouseEvent):void
		{
			activateWindow(WindowBase(event.currentTarget));
		}

		public function removeWindow(window:WindowBase):void
		{
			ArrayUtil.removeItemSafe(_windows, window);
			window.processRemove();
			ui.root.removeChild(window);
		}

		public function removeAllWindows():void
		{
			var windows:Vector.<WindowBase> = _windows.slice();
			for each (var window:WindowBase in windows)
			{
				removeWindow(window);
			}
		}

		public function getWindow(windowName:String):WindowBase
		{
			return WindowBase(from(_windows).byName(windowName).findFirst());
		}

		public function hasWindow(windowName:String):Boolean
		{
			return from(_windows).byName(windowName).exists();
		}

		public function activateWindow(window:WindowBase):void
		{
			DisplayUtil.bringToFront(window);
		}
	}
}
