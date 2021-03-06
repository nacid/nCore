package ru.nacid.base.services.windows.policy
{
	import com.junkbyte.console.Cc;

	import flash.events.EventDispatcher;

	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	import ru.nacid.utils.HashUtils;

	/**
	 * WindowPolicy.as
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
	public class WindowPolicy extends EventDispatcher implements IData
	{
		private var _id:String;
		private var _numericId:Number;
		private var _top:Vector.<String>;
		private var _close:Vector.<String>;

		protected var locks:Vector.<String>

		public function WindowPolicy($id:String, $locks:Array=null, $close:Array=null, $top:Array=null)
		{
			_id=$id;
			_numericId=HashUtils.CRC($id);
			_top=Vector.<String>($top || []);
			_close=Vector.<String>($close || []);

			if ($locks)
			{
				locks=Vector.<String>($locks);
				locks.fixed=true;
			}
		}

		public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void
		{
			for (var i:int=0; i < activeList.length; i++)
			{
				var target:String=activeList[i];

				if (_close.indexOf(target) >= 0)
				{
					dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, target, null))
				}
			}
		}

		public function applyClose(activeList:Vector.<String>, targetId:String, $force:Boolean=false):void
		{
			if (!$force && locks && locks.length)
			{
				for (var i:int=0; i < activeList.length; i++)
				{
					if (locks.indexOf(activeList[i]) >= 0)
						return Cc.warnch('MAN', 'window', targetId, 'can not be closed until', activeList[i], 'is opened');
				}
			}

			dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, targetId, null));
		}

		protected function getWindowIndex(activeList:Vector.<String>):int
		{
			var response:int=activeList.length;

			for (var i:int=0; i < activeList.length; i++)
			{
				var temp:int=_top.indexOf(activeList[i]);

				if (temp >= 0)
				{
					response=Math.min(response, temp);
				}
			}
			return response;
		}

		/* INTERFACE ru.nacid.base.data.interfaces.IData */

		public function get symbol():String
		{
			return _id;
		}

		public function valueOf():Number
		{
			return _numericId;
		}

	}

}
