package
{
	import flash.display.Sprite;

	import flash.events.MouseEvent;

	import garbuz.motion.TweenManager;
	import garbuz.motion.tween;

	public class TestFromTo extends MotionTestBase
	{
		override protected function onInitialize():void
		{
			createTween();
		}

		private function createTween():void
		{
			tween(createSprite(), 2)
				.from({alpha: 0})
				.tween(2)
				.from({alpha: 0})
				.to({alpha: 0.5, y: 20})
				.autoDetach()
				.onComplete(createTween);
		}

	}
}
