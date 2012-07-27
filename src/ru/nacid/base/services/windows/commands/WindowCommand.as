package ru.nacid.base.services.windows.commands 
{
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.windows.Navigator;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class WindowCommand extends Command 
	{
		protected var windowId:String;
		protected var navigator:Navigator;
		
		public function WindowCommand($commandId:String, $windowId:String)
		{
			navigator = Navigator.instance;
			windowId = $id;
			msgEnabled = false;
		}
		
	}

}