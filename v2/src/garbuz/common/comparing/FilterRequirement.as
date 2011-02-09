package garbuz.common.comparing
{
	
	/**
	* ...
	* @author canab
	*/
	public class FilterRequirement implements IRequirement
	{
		private var _func:Function;
		
		/**
		 * 
		 * @param	filterFunc
		 * filterFunc = function(param:Object):Boolean {...}
		 */
		public function FilterRequirement(filterFunc:Function)
		{
			_func = filterFunc;
		}
		
		public function accept(object:Object):Boolean
		{
			return _func(object);
		}
		
	}
}