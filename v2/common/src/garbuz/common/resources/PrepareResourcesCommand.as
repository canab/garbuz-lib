package garbuz.common.resources
{
	import garbuz.common.commands.AsincMacroCommand;
	import garbuz.common.commands.WaitForEventCommand;

	public class PrepareResourcesCommand extends AsincMacroCommand
	{
		private var _urls:Array /*of String*/;
		private var _reference:Object;

		public function PrepareResourcesCommand(urls:Array /*of String*/, reference:Object)
		{
			_urls = urls;
			_reference = reference;
		}

		override public function execute():void
		{
			addCommands();
			super.execute();
		}

		private function addCommands():void
		{
			for each (var url:String in _urls)
			{
				var bundle:ResourceBundle = ResourceManager.instance.allocateResource(url, _reference);
				
				if (!bundle.isReady)
					add(new WaitForEventCommand(bundle.readyEvent));
			}
		}
	}
}
