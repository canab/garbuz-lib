package garbuz.common.utils 
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author canab
	 */
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
		
	}

}