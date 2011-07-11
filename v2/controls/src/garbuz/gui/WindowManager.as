package garbuz.gui
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import garbuz.common.query.from;
	import garbuz.common.ui.DragController;
	import garbuz.common.ui.KeyboardManager;
	import garbuz.common.utils.ArrayUtil;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.gui.controls.DialogBase;
	import garbuz.gui.controls.WindowBase;

	use namespace ui_internal;

	internal class WindowManager extends ManagerBase
	{
		private var _windows:Vector.<WindowBase> = new <WindowBase>[];
		private var _dialogs:Vector.<WindowBase> = new <WindowBase>[];
		private var _currentScreen:WindowBase;
		private var _activeWindow:WindowBase;

		private var _modalFrame:Sprite = new Sprite();
		private var _locked:Boolean = false;

		public function WindowManager()
		{
			super();
			initialize();
		}

		private function initialize():void
		{
			KeyboardManager.instance.pressEvent.addListener(onKeyPress);
		}

		//noinspection JSUnusedLocalSymbols
		private function onKeyPress(sender:KeyboardManager, event:KeyboardEvent):void
		{
			if (_activeWindow)
				_activeWindow.processKey(event);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// screens
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function changeScreen(screen:WindowBase):void
		{
			removeScreen();
			addScreen(screen);
		}

		private function addScreen(screen:WindowBase):void
		{
			_currentScreen = screen;
			attachWindow(_currentScreen, 0);
			if (!_locked && _dialogs.length == 0)
				activateWindow(screen);
		}

		public function removeScreen():void
		{
			if (_currentScreen)
			{
				deactivateWindow(_currentScreen);
				detachWindow(_currentScreen);
				_currentScreen = null;
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// dialogs
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function showDialog(dialog:DialogBase, position:Point = null):void
		{
			dialog.closeEvent.addListener(hideDialog);
			dialog.position = position || getDialogPosition(dialog);

			ArrayUtil.addItemSafe(_dialogs, dialog);
			attachWindow(dialog);
			createModalFrame();
			refreshModalFrame();

			if (!_locked)
				activateWindow(dialog);
		}

		public function hideDialog(dialog:DialogBase = null):void
		{
			if (!dialog)
				dialog = ArrayUtil.lastItem(_dialogs) as DialogBase;

			deactivateWindow(dialog);
			detachWindow(dialog);
			ArrayUtil.removeItemSafe(_dialogs, dialog);
			dialog.closeEvent.removeListener(hideDialog);

			refreshModalFrame();
			tryActivateNext();
		}

		private function createModalFrame():void
		{
			_modalFrame.graphics.clear();
			_modalFrame.graphics.beginFill(DefaultStyle.MODAL_COLOR, DefaultStyle.MODAL_ALPHA);
			_modalFrame.graphics.drawRect(0, 0, 100, 100);
			_modalFrame.graphics.endFill();
		}

		private function refreshModalFrame():void
		{
			if (_modalFrame.parent)
				DisplayUtil.detachFromDisplay(_modalFrame);

			if (_dialogs.length == 0)
				return;

			var dialog:DialogBase = ArrayUtil.lastItem(_dialogs) as DialogBase;
			var depth:int = ui.root.getChildIndex(dialog);

			ui.root.addChildAt(_modalFrame, depth);

			_modalFrame.width = ui.bounds.width;
			_modalFrame.height = ui.bounds.height;
		}

		private function getDialogPosition(dialog:DialogBase):Point
		{
			return new Point(
					0.5 * (ui.bounds.width - dialog.width),
					0.5 * (ui.bounds.height - dialog.height));
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// windows
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function addWindow(window:WindowBase):void
		{
			ArrayUtil.addItemSafe(_windows, window);
			attachWindow(window);
			new DragController(window, window.hitArea).bounds = ui.bounds;
			window.addEventListener(MouseEvent.MOUSE_DOWN, onWindowMouseDown);
		}

		public function removeWindow(window:WindowBase):void
		{
			ArrayUtil.removeItemSafe(_windows, window);
			detachWindow(window);
		}

		private function onWindowMouseDown(event:MouseEvent):void
		{
			var window:WindowBase = WindowBase(event.currentTarget);
			activateWindow(window);
			DisplayUtil.bringToFront(window);
		}

		public function removeAllWindows():void
		{
			var windows:Vector.<WindowBase> = _windows.slice();
			for each (var window:WindowBase in windows)
			{
				removeWindow(window);
			}
		}

		public function hideAllWindows():void
		{
			for each (var window:WindowBase in _windows)
			{
				window.visible = false;
			}
		}

		public function showAllWindows():void
		{
			for each (var window:WindowBase in _windows)
			{
				window.visible = true;
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

		private function attachWindow(window:WindowBase, depth:int = -1):void
		{
			if (depth == -1)
				ui.root.addChild(window);
			else
				ui.root.addChildAt(window, depth);

			window.processAdd();
		}

		private function detachWindow(window:WindowBase):void
		{
			window.processRemove();
			DisplayUtil.detachFromDisplay(window);
		}

		public function activateWindow(window:WindowBase):void
		{
			if (window == _activeWindow)
				return;

			if (_activeWindow)
				deactivateWindow(_activeWindow);

			_activeWindow = window;
			_activeWindow.activate();
		}

		private function deactivateWindow(window:WindowBase):void
		{
			if (window == _activeWindow)
			{
				_activeWindow.deactivate();
				_activeWindow = null;
			}
		}

		private function tryActivateNext():void
		{
			if (!_locked)
				return;

			if (_dialogs.length > 0)
				activateWindow(ArrayUtil.lastItem(_dialogs) as WindowBase);
			else if (_currentScreen)
				activateWindow(_currentScreen);
		}

		internal function bringWindowToFront(window:WindowBase):void
		{
			activateWindow(window);
			DisplayUtil.bringToFront(window);
		}
	}
}
