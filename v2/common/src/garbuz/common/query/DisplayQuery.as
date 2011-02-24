package garbuz.common.query 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import garbuz.common.comparing.FilterRequirement;
	import garbuz.common.comparing.IRequirement;
	import garbuz.common.comparing.NameRequirement;
	import garbuz.common.comparing.PrefixRequirement;
	import garbuz.common.comparing.PropertyRequirement;
	import garbuz.common.comparing.TypeRequirement;
	import garbuz.common.errors.NullPointerError;

	public class DisplayQuery
	{
		private var _source:DisplayObjectContainer;
		private var _requirement:IRequirement;
		
		public function DisplayQuery(source:DisplayObjectContainer)
		{
			if (!source)
				throw new NullPointerError();

			_source = source;
		}
		
		public function byProperty(property:String, value:Object):DisplayQuery
		{
			_requirement = new PropertyRequirement(property, value);
			return this;
		}
		
		public function byName(name:String):DisplayQuery
		{
			_requirement = new NameRequirement(name);
			return this;
		}
		
		public function byPrefix(prefix:String):DisplayQuery
		{
			_requirement = new PrefixRequirement(prefix);
			return this;
		}
		
		public function byType(type:Class):DisplayQuery
		{
			_requirement = new TypeRequirement(type);
			return this;
		}
		
		public function byRequirement(requirement:IRequirement):DisplayQuery
		{
			_requirement = requirement;
			return this;
		}
		
		/**
		 * 
		 * @param	filterFunc
		 * filterFunc = function(param:Object):Boolean {...}
		 */
		public function byFilter(filterFunc:Function):DisplayQuery
		{
			_requirement = new FilterRequirement(filterFunc);
			return this;
		}
		
		public function findAll():Array
		{
			return getChildren(DisplayObjectContainer(_source), _requirement);
		}
		
		public function findAllRecursive():Array
		{
			return getChildrenRecursive(DisplayObjectContainer(_source), _requirement);
		}

		public function findFirst():DisplayObject
		{
			return getChildren(DisplayObjectContainer(_source), _requirement)[0];
		}
		
		public function findFirstRecursive():DisplayObject
		{
			return getChildrenRecursive(DisplayObjectContainer(_source), _requirement)[0];
		}

		public function exists():Boolean
		{
			return Boolean(findFirst());
		}
		
		public function existsRecursive():Boolean
		{
			return Boolean(findFirstRecursive());
		}

		private function getChildren(object:DisplayObjectContainer, requirement:IRequirement = null):Array
		{
			var result:Array = [];
			for (var i:int = 0; i < object.numChildren; i++)
			{
				var child:DisplayObject = object.getChildAt(i);
				if (requirement == null || requirement.accept(child))
					result.push(child)
			}
			return result;
		}
		
		private function getChildrenRecursive(object:DisplayObjectContainer, requirement:IRequirement = null):Array
		{
			var children:Array = getChildren(object);
			var result:Array = [];
			for each (var item:DisplayObject in children)
			{
				if (requirement == null || requirement.accept(item))
					result.push(item);
				
				if (item is DisplayObjectContainer)
					result = result.concat(getChildrenRecursive(DisplayObjectContainer(item), requirement));
				
			}
			return result;
		}
	}

}