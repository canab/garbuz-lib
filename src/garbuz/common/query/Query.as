package garbuz.common.query 
{
	import garbuz.common.comparing.FilterRequirement;
	import garbuz.common.comparing.IRequirement;
	import garbuz.common.comparing.NameRequirement;
	import garbuz.common.comparing.PropertyRequirement;
	import garbuz.common.comparing.TypeRequirement;
	import garbuz.common.converting.ConstructorConverter;
	import garbuz.common.converting.FunctionConverter;
	import garbuz.common.converting.IConverter;
	import garbuz.common.converting.ToPropertyConverter;

	/**
	 * ...
	 * @author canab
	 */
	public class Query
	{
		private var _source:Object;
		private var _requirement:IRequirement;
		
		public function Query(source:Object) 
		{
			_source = source;
			_requirement = null;
		}
		
		public function byProperty(property:String, value:Object):Query
		{
			_requirement = new PropertyRequirement(property, value);
			return this;
		}
		
		public function byName(name:String, isPrefix:Boolean = false):Query
		{
			_requirement = new NameRequirement(name, isPrefix);
			return this;
		}
		
		public function byType(type:Class):Query
		{
			_requirement = new TypeRequirement(type);
			return this;
		}
		
		public function byRequirement(requirement:IRequirement):Query
		{
			_requirement = requirement;
			return this;
		}
		
		/**
		 * 
		 * @param	filterFunc
		 * filterFunc = function(param:Object):Boolean {...}
		 */
		public function byFilter(filterFunc:Function):Query
		{
			_requirement = new FilterRequirement(filterFunc);
			return this;
		}
		
		public function findAll():Array
		{
			var result:Array = [];
			for each (var item:Object in _source)
			{
				if (_requirement == null || _requirement.accept(item))
					result.push(item);
			}
			return result;			
		}
		
		public function getUniqueItems():Array
		{
			var result:Array = [];
			for each (var item:Object in _source)
			{
				if (result.indexOf(item) >= 0)
					continue;
					
				if (_requirement == null || _requirement.accept(item))
					result.push(item);
			}
			return result;			
		}
		
		public function sum(field:String = null):Number
		{
			var sum:Number = 0;
			for each (var item:Object in _source)
			{
				if (_requirement == null || _requirement.accept(item))
				{
					sum += (field) ? item[field] : item;
				}

			}
			return sum;
		}
		
		public function findFirst():Object
		{
			for each (var item:Object in _source)
			{
				if (_requirement == null || _requirement.accept(item))
					return item;
			}
			return null;
		}
		
		public function convert(converter:IConverter):Array
		{
			var result:Array = [];
			for each (var item:Object in _source) 
			{
				if (_requirement == null || _requirement.accept(item))
					result.push(converter.convert(item));
			}
			return result;
		}
		
		public function convertByConstructor(type:Class):Array
		{
			return convert(new ConstructorConverter(type));
		}

		public function selectProperty(property:String):Array
		{
			return convert(new ToPropertyConverter(property));
		}

		public function select(selector:Function):Array
		{
			return convert(new FunctionConverter(selector));
		}
		
		public function exists():Boolean
		{
			return Boolean(findFirst());
		}
		
	}

}