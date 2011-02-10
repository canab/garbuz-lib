package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MotionTestBase
	{
		private var _root:Sprite;

		public function MotionTestBase()
		{
			super()
		}

		public function initialize(root:Sprite):void
		{
			_root = root;
			_root.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_root.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			onInitialize();
		}

		protected function createSprite():Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x0000FF);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();

			_root.addChild(sprite);

			return sprite;
		}

		protected function onInitialize():void
		{
			// virtual
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			// virtual
		}

	}
}
