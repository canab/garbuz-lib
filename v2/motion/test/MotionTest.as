package
{
	import flash.display.Sprite;

	import garbuz.motion.motion;

	public class MotionTest extends Sprite
	{
		public function MotionTest()
		{
			var sprite:Sprite = createSprite();
			motion(sprite);
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
