package garbuz.common.events
{
	/**
	 * ...
	 * @author canab
	 */
	public class EventSender
	{
		private var _sender:Object;
		private var _listeners:Vector.<Function>;
		private var _listenersCopy:Vector.<Function>;
		
		public function EventSender(sender:Object)
		{
			_sender = sender;
			_listeners = new Vector.<Function>();
		}
		
		public function addListener(listener:Function):void
		{
			if (hasListener(listener))
				throw new Error("List already contains such listener");
			else
				_listeners.push(listener);
		}
		
		public function removeListener(listener:Function):void
		{
			if (hasListener(listener))
				_listeners.splice(_listeners.indexOf(listener), 1);
			else
				throw new Error("List doesn't contain such listener");
		}
		
		public function dispatch(argument:* = null):void
		{
			var handlers:Vector.<Function> = _listeners.slice();
			var handler:Function;
		
			for each (handler in handlers)
			{
				if (handler.length == 0)
					handler();
				else if (handler.length == 1)
					handler(_sender);
				else if (handler.length == 2)
					handler(_sender, argument);
				else
					throw new ArgumentError();
			}
		}

		public function hasListener(func:Function):Boolean
		{
			return _listeners.indexOf(func) >= 0;
		}
	}
}