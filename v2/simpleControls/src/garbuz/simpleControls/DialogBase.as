package garbuz.simpleControls
{
	import garbuz.common.events.EventSender;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author canab
	 */
	public class DialogBase implements IDialog
	{
		private var _content:Sprite;
		private var _closeEvent:EventSender = new EventSender(this);
		
		public function DialogBase(content:Sprite) 
		{
			_content = content;
		}
		
		protected function handle(func:Function):void 
		{
			if (func != null)
				func();
		}
		
		public function get content():Sprite { return _content; }
		public function get closeEvent():EventSender { return _closeEvent; }
	}

}