package garbuz.simpleControls
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import garbuz.common.utils.AlignUtil;
	import garbuz.common.utils.ArrayUtil;
	import garbuz.common.utils.DisplayUtil;

	public class ScreenManager
	{
		private var _container:Sprite;
		private var _currentScreen:ScreenBase;
		private var _dialogs:Array = [];
		private var _frame:Sprite = new Sprite();
		private var _bounds:Rectangle;

		public function ScreenManager(container:Sprite, width:int,  height:int)
		{
			_container = container;
			_bounds = new Rectangle(0, 0, width, height);
		}

		public function changeScreen(screen:ScreenBase):void
		{
			if (_currentScreen)
			{
				if (_currentScreen.isActive)
					_currentScreen.deactivate();
				_currentScreen.processRemove();
				_container.removeChild(_currentScreen.content);
			}

			_currentScreen = screen;

			if (_currentScreen)
			{
				_container.addChildAt(_currentScreen.content, 0);
				_currentScreen.processAdd();
				if (_dialogs.length == 0)
					_currentScreen.activate();
			}
		}

		public function showDialog(dialog:DialogBase, shadowColor:int = 0x000000, shadowAlpha:Number = 0.25):void
		{
			if (_dialogs.indexOf(dialog) >= 0)
				throw new Error("Dialog already exists");

			if (_dialogs.length == 0 && _currentScreen && _currentScreen.isActive)
				_currentScreen.deactivate();

			_frame.graphics.clear();
			_frame.graphics.beginFill(shadowColor, shadowAlpha);
			_frame.graphics.drawRect(0, 0, 100, 100);
			_frame.graphics.endFill();

			_container.addChild(dialog.content);
			_dialogs.push(dialog);

			dialog.closeEvent.addListener(hideDialog);
			alignDialog(dialog);
			refreshModalFrame();
			dialog.onShow();
		}

		public function hideDialog(dialog:DialogBase = null):void
		{
			if (!dialog)
				dialog = ArrayUtil.lastItem(_dialogs) as DialogBase;

			if (_dialogs.indexOf(dialog) == -1)
				throw new Error("Dialog does not exist");

			dialog.onHide();
			dialog.closeEvent.removeListener(hideDialog);
			DisplayUtil.detachFromDisplay(dialog.content);
			ArrayUtil.removeItem(_dialogs, dialog);

			if (_dialogs.length == 0 && _currentScreen)
				_currentScreen.activate();

			refreshModalFrame();
		}

		private function refreshModalFrame():void
		{
			if (_frame.parent)
				DisplayUtil.detachFromDisplay(_frame);

			var dialog:DialogBase = ArrayUtil.lastItem(_dialogs) as DialogBase;

			if (dialog)
			{
				var depth:int = _container.getChildIndex(dialog.content);
				_container.addChildAt(_frame, depth);

				_frame.width = _bounds.width;
				_frame.height = _bounds.height;
			}
		}

		private function alignDialog(dialog:DialogBase):void
		{
			AlignUtil.alignCenter(dialog.content, _bounds);
		}

	}

}
