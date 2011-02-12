package garbuz.common.comparing
{
	
	/**
	 * ...
	 * @author Canab
	 */
	public class PrefixRequirement implements IRequirement
	{
		private static const NAME:String = 'name';

		private var _value:String;
		
		public function PrefixRequirement(name:String)
		{
			_value = name;
		}
		
		public function accept(object:Object):Boolean
		{
			return object
				&& object.hasOwnProperty(NAME)
				&& String(object[NAME]).indexOf(_value) == 0;
		}
		
	}
	
}