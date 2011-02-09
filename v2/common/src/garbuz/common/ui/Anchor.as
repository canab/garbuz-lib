package garbuz.common.ui
{
	/**
	 * ...
	 * @author Canab
	 */
	public class Anchor
	{
		private var _target:Object;
		private var _targetProperty:String;
		private var _source:Object;
		private var _sourceProperty:String;
		private var _distance:Number;

		public function Anchor(source:Object, sourceProperty:String, target:Object, targetProperty:String)
		{
			_target = target;
			_targetProperty = targetProperty;
			_source = source;
			_sourceProperty = sourceProperty;

			_distance = _source[_sourceProperty] - _target[_targetProperty];
		}

		public function apply():void
		{
			_target[_targetProperty] = _source[_sourceProperty] - _distance;
		}
	}
}
