package garbuz.common.commands 
{
	/**
	 * ...
	 * @author canab
	 */
	public class Conveyor
	{
		private var _items:Array = [];
		private var _active:Boolean = true;
		private var _currentItem:Object;
		
		public function Conveyor() 
		{
		}
		
		/**
		 * Push call to the queue 
		 * 
		 * @param	action
		 * should be ICommand or Function
		 */
		public function pushAction(action:Object):void 
		{
			if (action is Function || action is ICommand)
				_items.push(action);
			else
				throw new ArgumentError();
				
			checkForExecute();
		}
		
		private function checkForExecute():void
		{
			if (_active && !_currentItem)
				executeNext();
		}
		
		private function executeNext():void
		{
			while (_active && _items.length > 0)
			{
				_currentItem = _items.shift();
			
				if (_currentItem is IAsincCommand)
				{
					IAsincCommand(_currentItem).completeEvent.addListener(onComplete);
					IAsincCommand(_currentItem).execute();
					break;
				}
				else if (_currentItem is Function)
				{
					(_currentItem as Function)();
					_currentItem = null;
				}
				else if (_currentItem is ICommand)
				{
					ICommand(_currentItem).execute();
					_currentItem = null;
				}
			}
		}
		
		public function dispose():void 
		{
			if (_currentItem is ICancelableCommand)
				ICancelableCommand(_currentItem).cancel();
				
			if (_currentItem is IAsincCommand)
				resetCurrentItem();
				
			_items = null;
		}
		
		private function onComplete():void
		{
			resetCurrentItem();
			executeNext();
		}
		
		private function resetCurrentItem():void 
		{
			IAsincCommand(_currentItem).completeEvent.removeListener(onComplete);
			_currentItem = null;
		}
		
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void 
		{
			if (_active != value)
			{
				_active = value;
			}
		}
	}

}