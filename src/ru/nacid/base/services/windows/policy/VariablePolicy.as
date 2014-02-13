package ru.nacid.base.services.windows.policy
{
	import ru.nacid.base.services.windows.Window;
	import ru.nacid.base.services.windows.Wm;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;

	/**
	 * VariablePolicy.as
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
	public class VariablePolicy extends WindowPolicy
	{
		protected var closeOther:Boolean;
		protected var closeds:Array;

		protected var active:Vector.<String>=new Vector.<String>([]);
		protected var topLevel:Vector.<String>;

		private var indexes:Array;
		private var index:int;

		public function VariablePolicy($closeOther:Boolean=false, $closeds:Array=null, $locks:Array=null, $top:Array=null)
		{
			super('variableWindowPolicy', $locks);
			closeds=$closeds;
			closeOther=$closeOther;
			topLevel = Vector.<String>($top || []);

			indexes=[];
		}

		override public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void
		{
			active=activeList;
			index = activeList.length;
			
			if (closeOther)
			{
				for (var i:int=0; i < closeds.length; i++)
				{
					var ind:int=activeList.indexOf(closeds[i]);
					if (ind >= 0)
					{
						var window:Window=Wm.instance.getWindow(closeds[i]) as Window;
						indexes[i]={targetId: closeds[i], showData: window.getData()};
						dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, closeds[i]));
					}
				}
			}
			
			for (var j:int = 0; j<activeList.length;j++)
			{
				var t:int = topLevel.indexOf(activeList[j])
				
				if(t>=0)
				{
					index = Math.min(t,index);
				}
			}
			
			dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, targetId, data, getWindowIndex()));
		}

		protected function getWindowIndex():int
		{
			return index;
		}

		override public function applyClose(activeList:Vector.<String>, targetId:String, $force:Boolean=false):void
		{
			super.applyClose(activeList, targetId, $force);

			for each (var wndObj:Object in indexes)
			{
				dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, wndObj.targetId, wndObj.showData, activeList.length));
			}
			indexes=[];
		}

	}

}
