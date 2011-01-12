package garbuz.common.commands 
{
	import garbuz.common.events.EventSender;
	/**
	 * ...
	 * @author canab
	 */
	public class DelayCommand extends CallLaterCommand
	{
		/**
		 * 
		 * @param	delay
		 * time to delay, milliseconds
		 */
		public function DelayCommand(delay:int, onComplete:Function = null)
		{
			super(null, delay);

			if (onComplete)
				completeEvent.addListener(onComplete);
		}
	}

}