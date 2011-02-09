package garbuz.common.commands
{
	import garbuz.common.events.EventSender;
	
	public interface IAsincCommand extends ICommand
	{
		function get completeEvent():EventSender;
	}
	
}