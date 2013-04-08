package ru.nacid.blanks.startup
{
	import com.junkbyte.console.Cc;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;

	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.lan.LanCommand;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.logs.CCInit;
	import ru.nacid.base.services.windows.Wm;
	import ru.nacid.base.view.data.Position;
	import ru.nacid.base.view.interfaces.IDisplayContainerProxy;
	import ru.nacid.utils.debug.fps.Fps;
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
		protected var appLayer:IDisplayContainerProxy;
		protected var sysLayer:IDisplayContainerProxy;

		protected var progressIndicator:DisplayObject;
		protected var data:Object;

		public function Init($mainObject:IDisplayContainerProxy, $settings:*)
		{
			symbol="initialization";

			data=readSettings($settings);

			$mainObject.add(appLayer=$mainObject.empty());
			$mainObject.add(sysLayer=$mainObject.empty());
		}

		override protected function execInternal():void
		{
			if (appLayer.main.stage == null)
			{
				error('main object must have stage!');
				return onError();
			}
			if (appLayer.main.stage is Stage)
			{
				appLayer.main.stage.scaleMode=StageScaleMode.NO_SCALE;
				appLayer.main.stage.align=StageAlign.TOP_LEFT;
			}

			fillGlobal();

			if (data.remote is Array)
			{
				for (var i:int; i < data.remote.length; i++)
				{
					LanCommand.urls.writeAlias(data.remote[i].key, data.remote[i]);
				}
			}

			if ((exeData && exeData.debug) || data[CCInit.DEFAULT_FIELD])
			{
				ccInit(data[CCInit.DEFAULT_FIELD] as Object);
			}

			Wm.instance.setContainer(appLayer);
			addFpsSlash()

			collectQueue();
			super.execInternal();
		}

		protected function addFpsSlash():void
		{
			var callback:Function=(new Fps(sysLayer)).execute;
			Cc.addSlashCommand(Fps.COMMAND_LINE, callback, 'show/hide stats frame');

			if (Global.isDebug())
			{
				callback.call();
			}
		}

		protected function readSettings($settings:*):Object
		{
			return new Json().decodeObject($settings);
		}

		protected function collectQueue():void
		{
			//virtual
		}

		protected function setDebug($value:Boolean):void
		{
			Global.release=!$value;
		}

		protected function fillGlobal():void
		{
			Global.attachFlashVars(exeData);
			Global.appName=data.appname;
			Global.debugger=Capabilities.isDebugger;
			Global.language=Capabilities.language;
			Global.stage=appLayer.main.stage;
			Global.domain=new RequestVO(appLayer.main.stage.loaderInfo.url);
		}

		protected function ccInit($data:Object):void
		{
			new CCInit(sysLayer).execute($data);
		}

	}

}
