package ru.nacid.base.services.windows.commands 
{
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.windows.Navigator;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class CloseWindow extends WindowCommand 
	{
		private var force:Boolean;
		
		public function CloseWindow($id:String,$force:Boolean = false) 
		{
			super('closeWindow', $id);
			
			force = $force;
		}
		
		override protected function execInternal():void 
		{
			navigator.closeWindow(windowId, force);
			notifyComplete();
		}
		
	}

}