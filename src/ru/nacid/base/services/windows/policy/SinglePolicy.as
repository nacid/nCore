package ru.nacid.base.services.windows.policy
{
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;

	/**
	 * SinglePolicy.as
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
	public class SinglePolicy extends WindowPolicy
	{
		protected var closeOther:Boolean;

		public function SinglePolicy($closeOther:Boolean=false, $locks:Array=null)
		{
			super('singleWindowPolicy', $locks);
			closeOther=$closeOther;
		}

		override public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void
		{
			if (closeOther)
			{
				var inc:int=0;
				var last:String;

				while (activeList.length)
				{
					if (activeList[inc] == last)
					{
						if (++inc >= activeList.length)
							break;
						continue;
					}
					last=activeList[inc];

					dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, last));
				}
			}

			dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, targetId, data, activeList.length));
		}

	}

}
