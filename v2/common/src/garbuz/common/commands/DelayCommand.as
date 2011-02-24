package garbuz.common.commands 
{
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

			if (onComplete != null)
				completeEvent.addListener(onComplete);
		}
	}

}