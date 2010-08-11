package garbuz.common.query 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
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
	public class ButtonQuery
	{
		private var _source:SimpleButton;
		private var _requirement:IRequirement;
		
		public function ButtonQuery(source:SimpleButton) 
		{
			_source = source;
			_requirement = null;
		}
		
		public function byProperty(property:String, value:Object):ButtonQuery
		{
			_requirement = new PropertyRequirement(property, value);
			return this;
		}
		
		public function byName(name:String, isPrefix:Boolean = false):ButtonQuery
		{
			_requirement = new NameRequirement(name, isPrefix);
			return this;
		}
		
		public function byType(type:Class):ButtonQuery
		{
			_requirement = new TypeRequirement(type);
			return this;
		}
		
		public function byRequirement(requirement:IRequirement):ButtonQuery
		{
			_requirement = requirement;
			return this;
		}
		
		/**
		 * 
		 * @param	filterFunc
		 * filterFunc = function(param:Object):Boolean {...}
		 */
		public function byFilter(filterFunc:Function):ButtonQuery
		{
			_requirement = new FilterRequirement(filterFunc);
			return this;
		}
		
		public function findAll():Array
		{
			var states:Array = [_source.upState, _source.overState, _source.downState];
			var result:Array = [];
			for each (var state:DisplayObject in states) 
			{
				if (_requirement == null || _requirement.accept(state))
					result.push(state);
					
				if (state is Sprite)
				{
					result = result.concat(fromDisplay(Sprite(state))
						.byRequirement(_requirement)
						.findAll(true));
				}
			}
			return result;
		}
		
		public function findFirst():DisplayObject
		{
			return findAll()[0];
		}
		
		public function exists():Boolean
		{
			return Boolean(findFirst());
		}
	}

}