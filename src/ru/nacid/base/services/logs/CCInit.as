package ru.nacid.base.services.logs
{
	import com.junkbyte.console.Cc;
	import mx.core.UIComponent;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.view.ViewObject;

	/**
	 * CCInit.as
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
	public class CCInit extends Command
	{
		public static const DEFAULT_FIELD:String='logging';

		private var data:CCSettings;
		private var cont:ViewObject;
		private var screen:UIComponent;

		public function CCInit($container:ViewObject)
		{
			symbol='consoleInit';
			data=new CCSettings(DEFAULT_FIELD);
			cont=$container;
		}

		override protected function execInternal():void
		{
			data.apply(exeData);

			Cc.config.style.menuFont=data.menuFont;
			Cc.config.style.menuFontSize=data.menuFontSize;
			Cc.config.style.traceFont=data.traceFont;
			Cc.config.style.traceFontSize=data.traceFontSize;
			Cc.config.style.backgroundAlpha=data.backgroundAlpha;
			Cc.config.style.controlSize=data.controlSize;
			Cc.config.style.backgroundColor=data.backgroundColor;
			Cc.config.style.controlColor=data.controlColor;
			Cc.config.style.commandLineColor=data.commandLineColor;
			Cc.config.style.highColor=data.highColor;
			Cc.config.style.lowColor=data.lowColor;
			Cc.config.style.logHeaderColor=data.logHeaderColor;
			Cc.config.style.menuColor=data.menuColor;
			Cc.config.style.menuHighlightColor=data.menuHighlightColor;
			Cc.config.style.channelsColor=data.channelsColor;
			Cc.config.style.channelColor=data.channelColor;
			Cc.config.style.priority0=data.priority0;
			Cc.config.style.priority1=data.priority1;
			Cc.config.style.priority2=data.priority2;
			Cc.config.style.priority3=data.priority3;
			Cc.config.style.priority4=data.priority4;
			Cc.config.style.priority5=data.priority5;
			Cc.config.style.priority6=data.priority6;
			Cc.config.style.priority7=data.priority7;
			Cc.config.style.priority8=data.priority8;
			Cc.config.style.priority9=data.priority9;
			Cc.config.style.priority10=data.priority10;
			Cc.config.style.priorityC1=data.priorityC1;
			Cc.config.style.priorityC2=data.priorityC2;

			Cc.remoting=data.remoting;
			Cc.config.commandLineAllowed=data.commandLine;
			Cc.config.alwaysOnTop=data.alwaysOnTop;
			Cc.config.allowedRemoteDomain=data.allowedRemoteDomain;
			Cc.config.showTimestamp=data.showTimestamp;
			Cc.config.tracing=data.tracing;
			Cc.config.useObjectLinking=data.useObjectLinking;

			cont.addElement(screen=new UIComponent);
			Cc.start(screen, data.keystrokePassword);

			Cc.commandLine=data.commandLine
			Cc.width=cont.stage.stageWidth * data.wFactor;
			Cc.height=cont.stage.stageHeight * data.hFactor;

			notifyComplete();
		}

		override protected function msgComplete():void
		{
			Cc.logch(CMD_CHANNEL, 'console created');
		}

	}

}
