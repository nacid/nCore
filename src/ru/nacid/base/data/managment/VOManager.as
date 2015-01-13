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
		protected const MANAGER_CHANNEL:String='MAN';

		protected var activeList:Vector.<String>;
		protected var list:VOList;

		protected var dispatcherMode:Boolean;

		public function VOManager($list:Object = null,$activeList:Array = null)
		{
			activeList=Vector.<String>($activeList || []);
			list=new VOList($list);
		}

		protected function activeIndex($id:String):int
		{
			return activeList.indexOf($id);
		}

		public function isActive($id:String):Boolean
		{
			return activeIndex($id) >= 0;
		}
		
		public function contains($id:String):Boolean
		{
			return list.containsId($id);
		}

		public function getIdList():Vector.<String>
		{
			return list.getKeys();
		}

		protected function activate($id:String):Boolean
		{
			if (contains($id) && !isActive($id))
			{
				activeList.push($id);

				if (dispatcherMode) {
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_ACTIVATED, $id));
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ACTIVE_CHANGED, $id));
				}

				return true;
			}

			return false
		}

		protected function deactivate($id:String):void
		{
			var index:int=activeIndex($id);
			if (index >= 0)
			{
				activeList.splice(index, 1);

				if (dispatcherMode) {
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_DEACTIVATED, $id));
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ACTIVE_CHANGED, $id));
				}
			}
		}

		public function iterate($callback:Function, $startIndex:int=0):void
		{
			var iterator:VOIterator=list.createIteratorAt($startIndex);

			while (iterator.hasNext())
			{
				$callback.call(null, iterator.next());
			}
		}

		public function getActive():Vector.<String>
		{
			var response:Vector.<String> = new Vector.<String>(activeList.length,true);
			for(var i:int = 0;i<response.length;i++)
				response[i] = activeList[i];

			return response;
		}

		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */

		public function channelLog($string:String):void
		{
			Cc.logch(MANAGER_CHANNEL, $string);
		}

		public function channelWarning($string:String):void
		{
			Cc.warnch(MANAGER_CHANNEL, $string);
		}

		public function channelInfo($string:String):void
		{
			Cc.infoch(MANAGER_CHANNEL, $string);
		}

		public function channelError($string:String):void
		{
			Cc.errorch(MANAGER_CHANNEL, $string);
		}

		public function channelCrit($string:String):void
		{
			Cc.fatalch(MANAGER_CHANNEL, $string);
		}
	}

}
