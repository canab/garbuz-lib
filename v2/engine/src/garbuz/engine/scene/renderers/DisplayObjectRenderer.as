package garbuz.engine.scene.renderers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import garbuz.common.errors.NullPointerError;
	import garbuz.engine.components.Position;
	import garbuz.engine.components.Rotation;
	import garbuz.engine.components.Size;
	import garbuz.engine.core.Component;
	import garbuz.engine.scene.IVectorRenderer;
	import garbuz.engine.scene.VectorLayer;

	public class DisplayObjectRenderer extends Component implements IVectorRenderer
	{
		private var _content:DisplayObject;
		private var _layer:VectorLayer;
		
		private var _position:Position;
		private var _size:Size;
		private var _rotation:Rotation;
		private var _renderOnFrame:Boolean = false;
		
		public function DisplayObjectRenderer(content:DisplayObject) 
		{
			if (content == null)
				throw new NullPointerError();
				
			_content = content;
		}
		
		override protected function onDispose():void 
		{
			layer = null;
		}
		
		public function render():void 
		{
			if (_position)
			{
				_content.x = _position.x;
				_content.y = _position.y;
			}
			
			if (_rotation)
				_content.rotation = _rotation.degrees;
			
			if (_size)
				setSize();
		}

		protected function setSize():void
		{
			_content.width = _size.width;
			_content.height = _size.height;
		}
		
		public function get layer():VectorLayer { return _layer; }
		public function set layer(value:VectorLayer):void 
		{
			if (_layer)
				_layer.removeItem(this);
				
			_layer = value;
			
			if (_layer)
				_layer.addItem(this);
		}
		
		public function get position():Position { return _position; }
		public function set position(value:Position):void 
		{
			_position = value;
			render();
		}
		
		public function get size():Size { return _size; }
		public function set size(value:Size):void 
		{
			_size = value;
			render();
		}
		
		public function get rotation():Rotation { return _rotation; }
		public function set rotation(value:Rotation):void 
		{
			_rotation = value;
			render();
		}
		
		public function setScale(scale:Number):void 
		{
			_content.scaleX = scale;
			_content.scaleY = scale;
		}
		
		public function get visible():Boolean
		{
			return _content.visible;
		}
		
		public function set visible(value:Boolean):void 
		{
			_content.visible = value;
		}
		
		public function get content():DisplayObject { return _content; }

		public function getBounds(targetContainer:Sprite = null):Rectangle
		{
			return content.getBounds(targetContainer || content.parent);
		}

		public function get renderOnFrame():Boolean
		{
			return _renderOnFrame;
		}

		public function set renderOnFrame(value:Boolean):void
		{
			if (_renderOnFrame != value)
			{
				_renderOnFrame = value;

				if (_renderOnFrame)
				{
					engine.addFrameListener(this);
					onEnterFrame();
				}
				else
				{
					engine.removeFrameListener(this);
				}
			}
		}

		override public function onEnterFrame():void
		{
			render();
		}
	}

}