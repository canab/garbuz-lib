package garbuz.common.display
{
	import flash.display.Stage;

	import garbuz.common.errors.NotInitializedError;

	public class StageReference
	{
		private static var _stage:Stage;

		public static function initialize(stage:Stage):void
		{
			_stage = stage;
		}

		public static function get stage():Stage
		{
			if (!_stage)
				throw new NotInitializedError();
			
			return _stage;
		}
	}
}
