package ru.nacid.base.services.windows.commands 
{
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class UpWindow extends WindowCommand 
	{
		
		public function UpWindow($id:String) 
		{
			super('upWindow', $id);
		}
		
		override protected function execInternal():void 
		{
			navigator.makeTop(windowId);
			notifyComplete();
		}
		
	}

}