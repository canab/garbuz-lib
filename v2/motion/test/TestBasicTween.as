package
{
	import flash.display.Sprite;

	import garbuz.motion.tween;

	public class TestBasicTween extends MotionTestBase
	{
		override protected function onInitialize():void
		{
			move(createSprite());
		}

		private function move(target:Sprite):void
		{
			tween(target)
				.to({x: 500, y:50})
				.tween()
				.to({y: 100})
				.tween(0.5)
				.delay(1)
				.to({y: 250})
				.onUpdate(update, target)
				.onComplete(moveBack, target);
		}

		private function update(target:Sprite):void
		{
			target.rotation += 5;
		}

		private function moveBack(target:Sprite):void
		{
			tween(target)
				.to({x: 0, y:50})
				.onComplete(move, target);
		}

	}
}
