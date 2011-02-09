package
{
	import flash.display.Sprite;

	import flash.events.MouseEvent;

	import garbuz.motion.TweenManager;
	import garbuz.motion.tween;

	[SWF(width="640", height="480", frameRate="30")]
	public class MotionTest extends Sprite
	{
		public function MotionTest()
		{
			var sprite:Sprite = createSprite();
			addChild(sprite);
			move(sprite);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			TweenManager.pause();
		}

		private function onMouseUp(event:MouseEvent):void
		{
			TweenManager.resume();
		}

		private function move(target:Sprite):void
		{
			tween(target, 2)
				.to({x: 500, y:50})
				.tween()
				.tween()
				.to({y: 100})
				.tween(0.5)
				.to({y: 250})
				.onComplete(moveBack, target);
		}

		private function moveBack(target:Sprite):void
		{
			tween(target)
				.to({x: 0, y:0})
				.onComplete(move, target);
		}

		private function createSprite():Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x0000FF);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();

			return sprite;
		}
	}
}
