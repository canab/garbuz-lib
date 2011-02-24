package garbuz.common.query
{
	import flash.display.DisplayObjectContainer;

	public function fromDisplay(source:DisplayObjectContainer):DisplayQuery
	{
		return new DisplayQuery(source);
	}
}