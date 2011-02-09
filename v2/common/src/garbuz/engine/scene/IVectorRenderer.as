package garbuz.engine.scene 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author canab
	 */
	public interface IVectorRenderer
	{
		function get content():DisplayObject;
		function setScale(value:Number):void;
	}
	
}