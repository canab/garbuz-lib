package garbuz.flash.controls 
{
	import garbuz.common.events.EventSender;
	/**
	 * ...
	 * @author canab
	 */
	public class RadioGroup
	{
		private var _items:Array = [];
		private var _selectedItem:CheckBox = null;
		
		private var _clickEvent:EventSender = new EventSender(this);
		
		public function RadioGroup(items:Array = null)
		{
			initialize(items || []);
		}
		
		private function initialize(items:Array):void
		{
			for each (var item:CheckBox in items)
			{
				addItem(item);
			}
		}
		
		public function addItem(item:CheckBox):void 
		{
			_items.push(item);
			item.clickEvent.addListener(onButtonClick);			
		}
		
		private function onButtonClick(sender:CheckBox):void
		{
			selectedItem = sender;
			_clickEvent.dispatch();
		}
		
		private function setSelection(value:CheckBox):void
		{
			if (_selectedItem)
			{
				_selectedItem.checked = false;
				_selectedItem.enabled = true;
			}
			
			_selectedItem = value;
			
			if (_selectedItem)
			{
				_selectedItem.checked = true;
				_selectedItem.enabled = false;
			}
		}
		
		public function get items():Array { return _items; }
		
		public function get selectedItem():CheckBox { return _selectedItem; }
		public function set selectedItem(value:CheckBox):void 
		{
			if (_selectedItem != value)
				setSelection(value);
		}
		
		public function get selectedIndex():int
		{
			return _items.indexOf(_selectedItem);
		}
		
		public function set selectedIndex(value:int):void 
		{
			selectedItem = _items[value];
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
	}
	

}