package garbuz.common.commands
{
	import flash.utils.Dictionary;
	import garbuz.common.events.EventSender;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class AsincMacroCommand implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		private var _commands:Dictionary = new Dictionary();

		public function AsincMacroCommand(completeHandler:Function = null)
		{
			if (completeHandler != null)
				_completeEvent.addListener(completeHandler);
		}
		
		public function add(command:IAsincCommand):void
		{
			_commands[command] = false;
		}
		
		public function execute():void
		{
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
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		// DEPRECATED
		public function get commands():Dictionary { return _commands; }

		public function get isEmpty():Boolean
		{
			for (var command:Object in _commands)
			{
				return false;
			}

			return true;
		}
	}
}