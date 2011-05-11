package garbuz.common.commands
{
	import flash.utils.Dictionary;

	import garbuz.common.errors.NullPointerError;
	import garbuz.common.events.EventSender;

	public class AsincMacroCommand implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		private var _commands:Dictionary = new Dictionary();

		private var _started:Boolean = false;
		private var _canceled:Boolean = false;
		private var _completed:Boolean = false;

		public function AsincMacroCommand()
		{
			super()
		}

		public function onComplete(completeHandler:Function):AsincMacroCommand
		{
			_completeEvent.addListener(completeHandler);
			return this;
		}

		public function add(command:IAsincCommand):AsincMacroCommand
		{
			if (!command)
				throw new NullPointerError();

			_commands[command] = false;

			return this;
		}

		public function addAll(commands:/*iterable*/Object):AsincMacroCommand
		{
			for each (var command:IAsincCommand in commands)
			{
				add(command);
			}

			return this;
		}

		public function execute():void
		{
			if (_started)
				throw new Error("Command is already executed.");

			_started = true;

			if (isEmpty)
				add(new CallLaterCommand());

			for (var command:Object in _commands)
			{
				IAsincCommand(command).completeEvent.addListener(onCommandComplete);
				IAsincCommand(command).execute();
			}
		}

		private function onCommandComplete(command:IAsincCommand):void
		{
			_commands[command] = true;
			command.completeEvent.removeListener(onCommandComplete);

			for each (var completed:Boolean in _commands)
			{
				if (!completed)
					return;
			}

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
			for (var command:Object in _commands)
			{
				if (command is ICancelableCommand && !_commands[command])
				{
					ICancelableCommand(command).completeEvent.removeListener(onCommandComplete);
					ICancelableCommand(command).cancel();
				}
			}

			_started = false;
			_canceled = true;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}

		public function get commands():Dictionary
		{
			return _commands;
		}

		public function get isEmpty():Boolean
		{
			//noinspection LoopStatementThatDoesntLoopJS
			for (var command:Object in _commands)
			{
				return false;
			}

			return true;
		}

		public function get started():Boolean
		{
			return _started;
		}

		public function get canceled():Boolean
		{
			return _canceled;
		}

		public function get completed():Boolean
		{
			return _completed;
		}
	}
}