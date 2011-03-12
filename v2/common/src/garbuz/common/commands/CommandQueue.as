package garbuz.common.commands
{
	import garbuz.common.errors.NullPointerError;
	import garbuz.common.events.EventSender;

	public class CommandQueue implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);

		private var _commands:Array = [];
		private var _currentCommand:IAsincCommand;

		private var _started:Boolean = false;
		private var _canceled:Boolean = false;
		private var _completed:Boolean = false;

		public function CommandQueue()
		{
			super();
		}

		public function onComplete(completeHandler:Function):CommandQueue
		{
			_completeEvent.addListener(completeHandler);
			return this;
		}

		public function add(command:IAsincCommand):CommandQueue
		{
			if (!command)
				throw new NullPointerError();

			_commands.push(command);

			return this;
		}

		public function execute():void
		{
			if (_started)
				throw new Error("Command is already executed.");

			_started = true;

			if (_commands.length > 0)
				executeCommand();
			else
				new CallLaterCommand(complete).execute();
		}

		private function executeCommand():void
		{
			_currentCommand = _commands.shift() as IAsincCommand;
			_currentCommand.completeEvent.addListener(onCommandComplete);
			_currentCommand.execute();
		}

		private function onCommandComplete():void
		{
			clearCurrentCommand();
			if (_commands.length > 0)
				executeCommand();
			else
				complete();
		}

		private function complete():void
		{
			_started = false;
			_completed = true;
			_completeEvent.dispatch();
		}

		public function cancel():void
		{
			_started = false;
			_canceled = true;

			if (_currentCommand is ICancelableCommand)
				ICancelableCommand(_currentCommand).cancel();
		}

		private function clearCurrentCommand():void
		{
			_currentCommand.completeEvent.removeListener(onCommandComplete);
			_currentCommand = null;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}

		public function get commands():Array
		{
			return _commands;
		}

		public function get started():Boolean
		{
			return _started;
		}

		public function get completed():Boolean
		{
			return _completed;
		}

		public function get canceled():Boolean
		{
			return _canceled;
		}

	}

}