package
{
	import flash.display.Sprite;

	import flash.events.MouseEvent;

	import garbuz.motion.TweenManager;
	import garbuz.motion.easing.Elastic;
	import garbuz.motion.tween;

	public class TestBasicTween extends MotionTestBase
	{
		override protected function onInitialize():void
		{
			move(createSprite());
		}

		override protected function onMouseDown(event:MouseEvent):void
		{
			TweenManager.pauseAll();
		}

		override protected function onMouseUp(event:MouseEvent):void
		{
			TweenManager.resumeAll();
		}

		private function move(target:Sprite):void
		{
			tween(target)
				.to({x: 400, y:100})
				.easing(Elastic.easeOut)
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
				.to({x: 300, y:100})
				.onComplete(move, target);
		}

	}
}
