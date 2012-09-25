package ru.nacid.base.services.windows
{
	import flash.events.Event;
	import ru.nacid.base.services.CommandEvent;
	import ru.nacid.base.services.skins.Skin;
	import ru.nacid.base.services.skins.Sm;
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	import ru.nacid.base.services.windows.policy.WindowPolicy;
	import ru.nacid.base.view.ViewObject;
	/**
	 * Window.as
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
	public class Window extends ViewObject implements IWindowStorage
	{
		private var windowParam:WindowParam;
		
		protected var skin:Skin;
		protected var skinManager:Sm;
		
		protected function get param():WindowParam {
			return windowParam;
		}
		
		public function Window($param:WindowParam)
		{
			windowParam = $param;
			tabEnabled = true;
			focusRect = false;
			skinManager = Sm.instance;
			
			skin = skinManager.getSkin(windowParam.skinName);
			if (skin.loader && !skin.loaded) {
				skin.loader.addEventListener(CommandEvent.COMPLETE, skinLoadedHandler);
			}
			
			super(windowParam.id);
			info(id.concat(' created'));
		}
		
		private function skinLoadedHandler(e:Event):void {
			skin.loader.removeEventListener(CommandEvent.COMPLETE, skinLoadedHandler);
			
			if (onStage) {
				arrange();
			}
		}
		
		public function get policy():WindowPolicy
		{
			return windowParam.policy;
		}
		
		public function get render():Class
		{
			return windowParam.render;
		}
		
		public function get cached():Boolean
		{
			return windowParam.cached;
		}
		
		public function get modal():Boolean
		{
			return windowParam.modal;
		}
		
		public function setData($data:Object):void
		{
			showData = $data;
		}
		
		public function onFocus():void
		{
			
		}
	}

}