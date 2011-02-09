package garbuz.common.query 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import garbuz.common.comparing.FilterRequirement;
	import garbuz.common.comparing.IRequirement;
	import garbuz.common.comparing.NameRequirement;
	import garbuz.common.comparing.PropertyRequirement;
	import garbuz.common.comparing.TypeRequirement;
	/**
	 * ...
	 * @author canab
	 */
	public class DisplayQuery
	{
		private var _source:Sprite;
		private var _requirement:IRequirement;
		
		public function DisplayQuery(source:Sprite) 
		{
			_source = source;
			_requirement = null;
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
			_requirement = new NameRequirement(prefix, true);
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
		
		public function findAll(recursive:Boolean = false):Array
		{
			return (recursive)
				? getChildrenRecursive(DisplayObjectContainer(_source), _requirement)
				: getChildren(DisplayObjectContainer(_source), _requirement);
		}
		
		public function findFirst(recursive:Boolean = false):DisplayObject
		{
			return (recursive)
				? getChildrenRecursive(DisplayObjectContainer(_source), _requirement)[0]
				: getChildren(DisplayObjectContainer(_source), _requirement)[0];
		}
		
		public function exists(recursive:Boolean = false):Boolean
		{
			return Boolean(findFirst(recursive));
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