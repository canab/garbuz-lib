package garbuz.flash.controls 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author canab
	 */
	public class YesNoDialog extends DialogBase
	{
		static public const YES_NAME:String = 'btnYes';
		static public const NO_NAME:String = 'btnNo';
		
		private var _yesHandler:Function;
		private var _noHandler:Function;
		
		public function YesNoDialog(content:Sprite, yesHandler:Function, noHandler:Function = null) 
		{
			super(content);
			
			_yesHandler = yesHandler;
			_noHandler = noHandler;
			
			yesButton.addEventListener(MouseEvent.CLICK, onYesClick);
			noButton.addEventListener(MouseEvent.CLICK, onNoClick);
		}
		
		private function onYesClick(e:MouseEvent):void 
		{
			closeEvent.dispatch();
			handle(_yesHandler);
		}
		
		private function onNoClick(e:MouseEvent):void 
		{
			closeEvent.dispatch();
			handle(_noHandler);
		}
		
		private function get yesButton():InteractiveObject
		{
			return content[YES_NAME];
		}
		
		private function get noButton():InteractiveObject
		{
			return content[NO_NAME];
		}
	}

}