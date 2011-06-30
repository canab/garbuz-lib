package garbuz.common.logging
{
	public interface ILogFormatter
	{
		function format(sender:Object, level:String, message:String):String;
	}
}
