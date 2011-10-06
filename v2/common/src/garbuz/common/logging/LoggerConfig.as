package garbuz.common.logging
{
	internal class LoggerConfig
	{
		private var _properties:Object = {};

		public function setProperties(properties:Object):void
		{
			_properties = properties || {};
		}

		public function getLevel(loggerName:String):int
		{
			var maxLength:int = 0;
			var levelName:String = null;

			for (var key:String in _properties)
			{
				if (key.length > maxLength && loggerName.indexOf(key) == 0)
				{
					levelName = _properties[key];
					maxLength = key.length;
				}
			}

			if (!levelName)
				levelName = _properties.root;

			return (levelName) ? LogLevels.getLevel(levelName) : Logger.defaultLevel;
		}
	}
}
