package garbuz.motion.errors
{
	public class InvalidValueError extends Error
	{
		public function InvalidValueError(name:String, value:Object)
		{
			super("Invalid parameter: " + name + " = " + String(value));
		}
	}
}
