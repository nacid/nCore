package ru.nacid.base.services.windows.commands 
{
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class ShowWindow extends WindowCommand 
	{
		
		public function ShowWindow($id:String) 
		{
			super('openWindow', $id);
		}
		
		override protected function execInternal():void 
		{
			navigator.showWindow(windowId, exeData);
			notifyComplete();
		}
		
	}

}