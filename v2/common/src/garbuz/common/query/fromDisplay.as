package garbuz.common.query
{
	import flash.display.DisplayObjectContainer;

	/**
	 * ...
	 * @author canab
	 */
	
	public function fromDisplay(source:DisplayObjectContainer):DisplayQuery
	{
		return new DisplayQuery(source);
	}
}