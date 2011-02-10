package
{
	import garbuz.motion.tween;

	public class TestFromTo extends MotionTestBase
	{
		override protected function onInitialize():void
		{
			createTween();
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
