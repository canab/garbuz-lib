package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import flash.filters.DropShadowFilter;

	import garbuz.motion.tween;

	public class TestFilter extends MotionTestBase
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
				.to({ $filter: {name: DropShadowFilter, blurX: 100, blurY: 100} });
		}
	}
}
