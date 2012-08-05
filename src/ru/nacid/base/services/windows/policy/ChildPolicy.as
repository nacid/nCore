package ru.nacid.base.services.windows.policy 
{
	import com.junkbyte.console.Cc;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	/**
	 * ChildPolicy.as
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
	public class ChildPolicy extends WindowPolicy 
	{
		protected var parents:Vector.<String>
		
		public function ChildPolicy($parents:Array,$locks:Array=null) 
		{
			super('childPolicy', $locks);
			
			if ($parents) {
				parents = Vector.<String>($parents);
				parents.fixed = true;
			}
		}
		
		override public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void 
		{
			if(parents && parents.length){
				for (var i:int = 0; i < parents.length; i++) {
					if (activeList.indexOf(parents[i]) >= 0) {
						dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, targetId, data, activeList.length));
						return 
					}
				}
			}
			
			Cc.warnch('MAN', 'window', targetId, 'can not be opened because has no active parents');
		}
		
	}

}