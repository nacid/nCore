package ru.nacid.blanks.startup 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.lan.LanCommand;
	import ru.nacid.base.services.logs.CCInit;
	import ru.nacid.base.services.windows.Wm;
	import ru.nacid.base.view.data.Position;
	import ru.nacid.base.view.SimpleViewObject;
	import ru.nacid.utils.encoders.data.Json;
	/**
	 * Initializer.as
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
	public class Init extends CommandQueue 
	{
		protected var main:Sprite;
		protected var appLayer:SimpleViewObject;
		protected var sysLayer:SimpleViewObject;
		
		protected var progressIndicator:DisplayObject;
		protected var stagePosition:Position;
		protected var data:Object;
		
		public function Init($mainObject:Sprite, $settings:*) 
		{
			id = "initialization";
			
			data = readSettings($settings);
			main = $mainObject;
		}
		
		override protected function execInternal():void 
		{
			if (main.stage == null) {
				error('main object must have stage!');
				return onError();
			}
			appLayer = new SimpleViewObject;
			sysLayer = new SimpleViewObject;
			stagePosition = new Position(main.x, main.y, main.stage.stageWidth, main.stage.stageHeight);
			
			
			main.stage.scaleMode = StageScaleMode.NO_SCALE;
			main.stage.align = StageAlign.TOP_LEFT;
			
			main.addChild(appLayer);
			main.addChild(sysLayer);
			
			Global.appName = data.appname;
			Global.release = !(CONFIG::debug);
			Global.debugger = Capabilities.isDebugger;
			Global.language = Capabilities.language;
			Global.stageW = stagePosition.width;
			Global.stageH = stagePosition.height;
			Global.domain = new RequestVO(main.loaderInfo.url);
			
			if (data.remote is Array) {
				for (var i:int; i < data.remote.length; i++) {
					LanCommand.urls.writeAlias(data.remote[i].key, data.remote[i]);
				}
			}
			
			if (data.hasOwnProperty(CCInit.DEFAULT_FIELD)) {
				new CCInit(sysLayer).execute(data[CCInit.DEFAULT_FIELD]);
			}
			
			Wm.instance.setContainer(appLayer);
			
			collectQueue();
			super.execInternal();
		}
		
		protected function readSettings($settings:*):Object {
			return new Json().decodeObject($settings);
		}
		
		protected function collectQueue():void {
			//virtual
		}
		
	}

}