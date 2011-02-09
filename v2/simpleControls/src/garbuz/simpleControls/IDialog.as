package garbuz.simpleControls
{
	import garbuz.common.events.EventSender;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author canab
	 */
	public interface IDialog
	{
		function get content():Sprite;
		function get closeEvent():EventSender;
	}

}