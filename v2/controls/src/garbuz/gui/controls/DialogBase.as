package garbuz.gui.controls
{
	import flash.events.Event;

	import garbuz.common.commands.DelayCommand;

	public class DialogBase extends WindowBase
	{
		private var _timeout:int = 0;

		public function DialogBase()
		{
		}

		protected function doDefaultAction():void
		{
			closeWindow();
		}

		public function setTimeout(value:int):void
		{
			if (value <= 0 || _timeout > 0)
				return;

			_timeout = value;

			if (stage)
				initTimeout();
			else
				addEventListener(Event.ADDED_TO_STAGE, initTimeout);
		}

		private function initTimeout(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initTimeout);
			new DelayCommand(_timeout, onTimeout).execute();
		}

		private function onTimeout():void
		{
			if (stage)
				doDefaultAction();
		}
	}
}
