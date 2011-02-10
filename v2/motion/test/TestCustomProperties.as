package
{
	import flash.display.Sprite;

	import garbuz.motion.tween;

	public class TestCustomProperties extends MotionTestBase
	{
		private var _sprite:Sprite;

		override protected function onInitialize():void
		{
			_sprite = createSprite();
			createTween();
		}

		private function createTween():void
		{
			tween(_sprite)
				.from({scale: 0.1, alpha: 1})
				.to({scale: 1.5, alpha: 0.5})
				.updateNow()
				.tween()
				.delay(0.5)
				.to({scale: 0.1})
				.onComplete(createTween)
		}

	}
}
