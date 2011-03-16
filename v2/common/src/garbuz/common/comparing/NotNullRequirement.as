package garbuz.common.comparing
{
	public class NotNullRequirement implements IRequirement
	{
		public function accept(object:Object):Boolean
		{
			return (object != null);
		}
	}
}
