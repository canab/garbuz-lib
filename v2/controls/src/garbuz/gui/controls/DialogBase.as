package garbuz.gui.controls
{
	import flash.events.Event;

	import garbuz.common.commands.DelayCommand;
	import garbuz.common.events.EventSender;

	public class DialogBase extends WindowBase
	{
		private var _closeEvent:EventSender = new EventSender(this);
		private var _timeout:int = 0;

		public function DialogBase()
		{
		}

		protected function closeDialog():void
		{
			_closeEvent.dispatch();
		}

		protected function doDefaultAction():void
		{
			closeDialog();
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

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get closeEvent():EventSender
		{
			return _closeEvent;
		}
	}
}
