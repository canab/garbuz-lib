package garbuz.simpleControls
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author canab
	 */
	public class OkDialog extends DialogBase
	{
		static public const BUTTON_NAME:String = 'btnOk';
		
		private var _closeHandler:Function;
		
		public function OkDialog(content:Sprite, closeHandler:Function = null) 
		{
			super(content);
			
			_closeHandler = closeHandler;
			
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		private function onOkClick(e:MouseEvent):void 
		{
			closeEvent.dispatch();
			handle(_closeHandler);
		}
		
		private function get okButton():InteractiveObject
		{
			return content[BUTTON_NAME];
		}
		
	}

}