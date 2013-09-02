package ru.nacid.base.services.windows.commands
{
	public class CloseAllWindows extends WindowCommand
	{
		public function CloseAllWindows()
		{
			super('closeAllWindows', null);
		}
		
		override protected function execInternal():void
		{
			navigator.closeAll();
			notifyComplete();
		}
	}
}