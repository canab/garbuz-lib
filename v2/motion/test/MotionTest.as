package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import garbuz.motion.TweenManager;

	[SWF(width="640", height="480", frameRate="30")]
	public class MotionTest extends Sprite
	{
		private var _field:TextField;

		public function MotionTest()
		{
			createDebugInfo();
			addEventListener(Event.ENTER_FRAME, refreshDebugInfo);

//			new TestBasicTween().initialize(this);
			new TestOverride().initialize(this);
		}

		private function refreshDebugInfo(event:Event):void
		{
			_field.text = TweenManager.getDebugText();
			_field.height = _field.textHeight + 10;
		}

		private function createDebugInfo():void
		{
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat("_typewriter");
			_field.background = true;
			_field.border = true;
			_field.multiline = true;
			_field.width = 150;
			_field.x = 200;

			addChild(_field);
		}
	}
}
