package garbuz.simpleControls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.common.utils.MathUtil;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class ScrollableBox
	{
		static private const MASK_NAME:String = 'mcMask';
		static private const VSCROLL_NAME:String = 'mcVScrollBar';
		static private const HSCROLL_NAME:String = 'mcHScrollBar';
		
		protected var _content:Sprite;
		protected var _container:Sprite;
		protected var _mask:Sprite;
		
		protected var _vScrollBar:VerticalScrollBar;
		protected var _hScrollBar:HorizontalScrollBar;
		
		public function ScrollableBox(content:Sprite)
		{
			_content = content;
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			createMask();
			createScrollBars();
			createContainer();
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			var delta:Number = -e.delta * 30 / _content.height;
			_vScrollBar.position = MathUtil.claimRange(_vScrollBar.position + delta, 0, 1);
		}
		
		private function createMask():void
		{
			_mask = _content[MASK_NAME];
			_mask.alpha = 0;
			_mask.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function createContainer():void
		{
			_container = new Sprite();
			_container.x = _mask.x;
			_container.y = _mask.y;
			_content.addChild(_container);
		}
		
		private function createScrollBars():void
		{
			if (_content.getChildByName(VSCROLL_NAME))
			{
				_vScrollBar = new VerticalScrollBar(_content[VSCROLL_NAME]);
				_vScrollBar.changeEvent.addListener(onScroll);
			}
			
			if (_content.getChildByName(HSCROLL_NAME))
			{
				_hScrollBar = new HorizontalScrollBar(_content[HSCROLL_NAME]);
				_hScrollBar.changeEvent.addListener(onScroll);
			}
		}
		
		private function onScroll():void
		{
			updateScrollRect();
		}
		
		private function updateScrollRect():void
		{
			var bounds:Rectangle = DisplayUtil.getChildrenBounds(_container);
			var rect:Rectangle = new Rectangle(0, 0, _mask.width, _mask.height);
			
			if (_vScrollBar)
			{
				rect.y = (bounds.height - rect.height) * _vScrollBar.position;
				_vScrollBar.enabled = bounds.height > rect.height;
			}
			
			if (_hScrollBar)
			{
				rect.x = (bounds.width - rect.width) * _hScrollBar.position;
				_hScrollBar.enabled = bounds.width > rect.width;
			}
				
			_container.scrollRect = rect;
		}
		
		public function set vScrollPosition(position:Number):void
		{
			if (_vScrollBar)
			{
				_vScrollBar.position = position;
				updateScrollRect();
			}
		}
		
		public function set hScrollPosition(position:Number):void
		{
			if (_hScrollBar)
			{
				_hScrollBar.position = position;
				updateScrollRect();
			}
		}
		
		public function set container(value:DisplayObject):void 
		{
			_container.addChild(value);
			updateScrollRect();
		}
	}
	
}