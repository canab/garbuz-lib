package
{
	import flash.display.Sprite;

	import garbuz.motion.motion;

	[SWF(width="640", height="480", frameRate="30")]
	public class MotionTest extends Sprite
	{
		public function MotionTest()
		{
			var sprite:Sprite = createSprite();
			addChild(sprite);
			move(sprite);
		}

		private function move(target:Sprite):void
		{
			motion(target)
				.duration(2)
				.to({x: 500, y:50})
				.onComplete(moveBack, target);
		}

		private function moveBack(target:Sprite):void
		{
			motion(target)
				.to({x: 0, y:0})
				.onUpdate(update, target)
				.onComplete(move, target);
		}

		private function update(target:Sprite):void
		{
			target.alpha = Math.random();
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
