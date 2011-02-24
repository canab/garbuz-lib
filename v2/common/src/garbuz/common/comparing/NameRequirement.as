package garbuz.common.comparing
{
	public class NameRequirement implements IRequirement
	{
		private static const NAME:String = 'name';

		private var _value:String;

		public function NameRequirement(name:String)
		{
			_value = name;
		}
		
		public function accept(object:Object):Boolean
		{
			return object
				&& object.hasOwnProperty(NAME)
				&& object[NAME] == _value;
		}
	}
}