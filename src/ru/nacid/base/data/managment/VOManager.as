package ru.nacid.base.data.managment 
{
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.managment.events.VOManagerEvent;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class VOManager extends EventDispatcher implements IChannelParent
	{
		protected const MANAGER_CHANNEL:String = 'MAN';
		
		protected var activeList:Vector.<String>;
		protected var list:VOList;
		
		protected var dispatcherMode:Boolean;
		
		public function VOManager() 
		{
			activeList = Vector.<String>([]);
			list = new VOList();
		}
		
		protected function activeIndex($id:String):int {
			return activeList.indexOf($id);
		}
		
		public function isActive($id:String):Boolean {
			return activeIndex($id) >= 0;
		}
		
		public function activate($id:String):void {
			if (list.containsId($id) && !isActive($id)) {
				activeList.push($id);
				
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_ACTIVATED, $id));
			}
		}
		
		public function deactivate($id:String):void {
			var index:int = activeIndex($id);
			if (index >= 0) {
				activeList.splice(index, 1);
				
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_DEACTIVATED, $id));
			}
		}
		
		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */
		
		public function log($string:String):void 
		{
			Cc.logch(MANAGER_CHANNEL, $string);
		}
		
		public function warning($string:String):void 
		{
			Cc.warnch(MANAGER_CHANNEL, $string);
		}
		
		public function info($string:String):void 
		{
			Cc.infoch(MANAGER_CHANNEL, $string);
		}
		
		public function error($string:String):void 
		{
			Cc.errorch(MANAGER_CHANNEL, $string);
		}
		
		public function critical($string:String):void 
		{
			Cc.fatalch(MANAGER_CHANNEL, $string);
		}
	}

}