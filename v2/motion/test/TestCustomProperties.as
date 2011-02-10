package
{
	import flash.display.Sprite;

	import garbuz.motion.tween;

	public class TestCustomProperties extends MotionTestBase
	{
		private var _sprite:Sprite;

		override protected function onInitialize():void
		{
		}

		private function createTween():void
		{
			tween(createSprite(), 3)
				.from({alpha: 0})
				.updateNow()
				.tween(2)
				.to({alpha: 0, y:20})
				.autoDetach()
				.onComplete(createTween);
		}

	}
}
