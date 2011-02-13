package
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;

	import garbuz.motion.filter.FilterTween;
	import garbuz.motion.tween;

	public class TestFilter extends MotionTestBase
	{
		private var _sprites:Array = [];

		override protected function onInitialize():void
		{
			createSprites();
			createSingleFilter(_sprites[0]);
		}

		private function createSingleFilter(sprite:Sprite):void
		{
			sprite.filters = [new BlurFilter(0, 0)];

			tween(sprite)
				.to({
			        $filter: FilterTween.byNum(0).to({blurX:15, blurY:15})
			    })
				.tween()
				.to({
					$filter: FilterTween.byNum(0).to({blurX:0, blurY:0})
			    })
				.onComplete(createSingleFilter, sprite);
		}

		private function createSprites():void
		{
			var rows:int = 4;
			var cols:int = 5;
			var gridSize:int = 100;

			for (var i:int = 0; i < rows; i++)
			{
				for (var j:int = 0; j < cols; j++)
				{
					var sprite:Sprite = createSprite(
							(j + 1) * gridSize,
							(i + 1) * gridSize);
					_sprites.push(sprite);
				}
			}
		}

	}
}
