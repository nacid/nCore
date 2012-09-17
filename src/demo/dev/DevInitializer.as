package demo.dev 
{
	import flash.display.Sprite;
	import ru.nacid.base.services.localization.commands.LoadLocaleMap;
	import ru.nacid.base.services.logs.CCInit;
	import ru.nacid.base.services.windows.policy.SinglePolicy;
	import ru.nacid.base.services.windows.WindowParam;
	import ru.nacid.blanks.startup.DisplayedInit;
	import ru.nacid.blanks.startup.Init;
	import ru.nacid.blanks.startup.simpleInit.SimpleInit;
	
	/**
	 * DevInitializer.as
	 * Created On: 5.8 22:10
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
	public class DevInitializer extends DisplayedInit
	{
		[Embed(source="../../../assets/debug/config.json", mimeType="application/octet-stream")]
		private var config:Class;
		
		public function DevInitializer($mainObject:Sprite)
		{
			super($mainObject, new config);
		}
		
		override protected function collectQueue():void 
		{
			addCommand(new LoadLocaleMap('static'));
		}
		
	}

}