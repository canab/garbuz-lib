package garbuz.common.comparing
{
	public class NotRequirement implements IRequirement
	{
		private var _targetRequirement:IRequirement;

		public function NotRequirement(targetRequirement:IRequirement)
		{
			_targetRequirement = targetRequirement;
		}
		
		public function accept(object:Object):Boolean
		{
			return !_targetRequirement.accept(object);
		}
	}
}