package garbuz.engine.components 
{
	import garbuz.common.events.EventSender;
	import garbuz.engine.core.Component;
	/**
	 * ...
	 * @author canab
	 */
	public class DataComponent extends Component
	{
		private var _changeEvent:EventSender = new EventSender(this);
		
		public function DataComponent() 
		{
			super();
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
	}

}