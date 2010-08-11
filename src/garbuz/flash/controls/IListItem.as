package garbuz.flash.controls 
{
	import garbuz.common.events.EventSender;
	
	/**
	 * ...
	 * @author canab
	 */
	public interface IListItem 
	{
		function get clickEvent():EventSender;
		function set selected(value:Boolean):void;
	}
	
}