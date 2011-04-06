package garbuz.common.utils 
{
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ReflectUtil
	{
		static public function getInstanceClass(instance:Object, domain:ApplicationDomain = null):Class
		{
			if (domain)
				return domain.getDefinition(getQualifiedClassName(instance)) as Class;
			else
				return getDefinitionByName(getQualifiedClassName(instance)) as Class;
		}
		
		static public function getClassName(object:Object):String
		{
			var fullName:String = getQualifiedClassName(object);
			var index:int = fullName.indexOf("::");
			
			return (index >= 0)
				? fullName.substr(index + 2)
				: fullName;
		}

		public static function cloneObject(source:Object):Object
		{
			var constructor:Class = source.constructor;
			var result:Object = new constructor();
			copyFieldsAndProperties(source, result);
			return result;
		}

		public static function copyFieldsAndProperties(source:Object, target:Object):void
		{
			var targetType:XML = describeType(target);
			var value:*;

			if (targetType.@isDynamic == "true")
			{
				for (var propName:String in source)
				{
					target[propName] = source[propName];
				}
			}

			for each (var variable:XML in targetType.variable)
			{
				var memberName:String = variable.@name;

				if (source.hasOwnProperty(memberName))
				{
					value = source[memberName];

					if (!(value is Function))
						target[memberName] = value;
				}
			}

			for each (var accessor:XML in targetType.accessor)
			{
				var accessorName:String = accessor.@name;
				var accessType:String = accessor.@access;

				if (accessType == "readwrite" && target.hasOwnProperty(memberName))
				{
					value = source[accessorName];

					if (!(value is Function))
						target[accessorName] = value;
				}
			}
		}
	}

}