package garbuz.common.query
{
	import flash.display.SimpleButton;

	public function fromButton(source:SimpleButton):ButtonQuery
	{
		return new ButtonQuery(source);
	}
}