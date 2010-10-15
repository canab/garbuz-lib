package garbuz.flash.controls 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import garbuz.common.events.EventSender;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.common.utils.MathUtil;
	/**
	 * ...
	 * @author canab
	 */
	public class ListBox
	{
		static private const SCROLL_BAR:String = "mcVScrollBar";
		static private const ITEMS_CONTAINER:String = "mcItems";
		
		private var _selectionChangeEvent:EventSender = new EventSender(this);
		
		private var _items:Array;
		private var _selectedItem:IListItem;
		
		private var _content:Sprite;
		private var _listContent:Sprite;
		private var _listBounds:Rectangle;
		private var _scrollBar:VerticalScrollBar;
		private var _position:Number = 0;
		
		public function ListBox(content:Sprite)
		{
			_content = content;
			initContent();
		}
		
		private function initContent():void
		{
			_listContent = _content[ITEMS_CONTAINER];
			_listBounds = _listContent.getBounds(_content);
			
			DisplayUtil.removeChildren(_listContent);
			
			if (_content[SCROLL_BAR])
			{
				_scrollBar = new VerticalScrollBar(_content[SCROLL_BAR]);
				_scrollBar.changeEvent.addListener(onScroll);
			}
			
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			position = position - e.delta * 0.1 * _listBounds.height / _listContent.height;
		}
		
		private function onScroll():void
		{
			position = _scrollBar.position;
		}
		
		public function get selectedIndex():int
		{
			return (_selectedItem)
				? _items.indexOf(_selectedItem)
				: -1;
		}
		
		public function set selectedIndex(value:int):void 
		{
			selectedItem = _items[value];
		}
		
		public function get selectedItem():IListItem { return _selectedItem; }
		public function set selectedItem(value:IListItem):void 
		{
			if (_selectedItem)
				_selectedItem.selected = false;
				
			_selectedItem = value;
			
			if (_selectedItem)
				_selectedItem.selected = true;
		}
		
		public function get items():Array { return _items; }
		public function set items(value:Array):void 
		{
			_items = value;
			_selectedItem = null;
			rebuild();
		}
		
		
		private function rebuild():void
		{
			DisplayUtil.removeChildren(_listContent);
			
			var y:int = 0;
			for each (var item:Sprite in _items) 
			{
				_listContent.addChild(item);
				IListItem(item).clickEvent.addListener(onItemClick);
				item.y = y;
				y += item.height;
			}
		}
		
		private function onItemClick(sender:IListItem):void
		{
			selectedItem = sender;
			_selectionChangeEvent.dispatch();
		}
		
		public function get selectionChangeEvent():EventSender { return _selectionChangeEvent; }
		
		public function get content():Sprite { return _content; }
		
		public function get position():Number { return _position; }
		public function set position(value:Number):void 
		{
			_position = MathUtil.claimRange(value, 0, 1);
			_listContent.y = _listBounds.y - _position * (_listContent.height - _listBounds.height);
			
			if (_scrollBar)
				_scrollBar.position = _position;
		}
	}

}