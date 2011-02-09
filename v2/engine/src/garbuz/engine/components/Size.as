package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class Size extends Component
	{
		public var width:Number;
		public var height:Number;
		
		public function Size(width:Number = 1, height:Number = 1) 
		{
			this.width = width;
			this.height = height;
		}
		
	}

}