package ru.nacid.base.data.managment 
{
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.managment.events.VOManagerEvent;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	/**
	 * VOManager.as
	 * Created On: 5.8 20:22
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/nCore
	 *
	 *
	 *		Copyright 2012 Nikolay nacid Bondarev
	 *
	 *	Licensed under the Apache License, Version 2.0 (the "License");
	 *	you may not use this file except in compliance with the License.
	 *	You may obtain a copy of the License at
	 *
	 *		http://www.apache.org/licenses/LICENSE-2.0
	 *
	 *	Unless required by applicable law or agreed to in writing, software
	 *	distributed under the License is distributed on an "AS IS" BASIS,
	 *	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 *	See the License for the specific language governing permissions and
	 *	limitations under the License.
	 *
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
		
		protected function activate($id:String):void {
			if (list.containsId($id) && !isActive($id)) {
				activeList.push($id);
				
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_ACTIVATED, $id));
			}
		}
		
		protected function deactivate($id:String):void {
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