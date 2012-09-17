package ru.nacid.blanks.startup 
{
	import flash.display.Sprite;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.windows.commands.ShowWindow;
	import ru.nacid.base.services.windows.policy.SinglePolicy;
	import ru.nacid.base.services.windows.WindowParam;
	import ru.nacid.base.services.windows.Wm;
	import ru.nacid.blanks.startup.Init;
	import ru.nacid.blanks.startup.simpleInit.SimpleInit;
	
	/**
	 * SimpleInit.as
	 * Created On: 9.8 17:23
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
	public class DisplayedInit extends Init 
	{
		private var wp:WindowParam;
		private var winCmd:Command;
		
		public function DisplayedInit($mainObject:Sprite, $settings:*) {
			super($mainObject, $settings);
			
			wp = determineWindow();
		}
		
		override protected function execInternal():void 
		{
			Wm.instance.regWindow(wp);
			
			winCmd = new ShowWindow(wp.id);
			winCmd.priority = Command.HIGHER_PRIORITY;
			addCommand(winCmd);
			
			super.execInternal();
		}
		
		override protected function onComplete():void 
		{
			Wm.instance.closeWindow(wp.id);
			super.onComplete();
		}
		
		protected function determineWindow():WindowParam {
			return new WindowParam(SimpleInit.ID, SimpleInit, new SinglePolicy);
		}
	}

}