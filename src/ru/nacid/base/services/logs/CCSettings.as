package ru.nacid.base.services.logs 
{
	import ru.nacid.base.data.ValueObject;
	/**
	 * CCSettings.as
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
	public class CCSettings extends ValueObject 
	{
		public var keystrokePassword	:String = '';
		public var remoting				:Boolean = false;
		public var commandLine			:Boolean = false;
		public var allowedRemoteDomain 	:String = "*";
		public var showTimestamp		:Boolean = true;
		public var tracing				:Boolean = false;
		public var alwaysOnTop			:Boolean = false;
		public var useObjectLinking		:Boolean = false;
		
		public var menuFont				:String = "Arial";
		public var menuFontSize			:int = 12;
		public var traceFont			:String = "Courier";
		public var traceFontSize		:int = 8;
		public var backgroundAlpha		:Number = 0.7;
		public var controlSize			:uint = 5;
		
		public var backgroundColor		:uint = 0;
		public var controlColor			:uint = 0x990000;
		public var commandLineColor		:uint = 0x10AA00;
		public var highColor			:uint = 0xFFFFFF;
		public var lowColor				:uint = 0xC0C0C0; 
		public var logHeaderColor		:uint = 0xC0C0C0; 
		public var menuColor			:uint = 0xFF8800;
		public var menuHighlightColor	:uint = 0xDD5500; 
		public var channelsColor		:uint = 0xFFFFFF;
		public var channelColor			:uint = 0x0099CC;
		public var priority0			:uint = 0x3A773A;
		public var priority1			:uint = 0x449944;
		public var priority2			:uint = 0x77BB77;
		public var priority3			:uint = 0xA0D0A0;
		public var priority4			:uint = 0xD6EED6;
		public var priority5			:uint = 0xE9E9E9;
		public var priority6			:uint = 0xFFDDDD;
		public var priority7			:uint = 0xFFAAAA;
		public var priority8			:uint = 0xFF7777;
		public var priority9			:uint = 0xFF2222;
		public var priority10			:uint = 0xFF2222;
		public var priorityC1			:uint = 0x0099CC;
		public var priorityC2			:uint = 0xFF8800;
		
		public var wFactor				:Number = 1;
		public var hFactor				:Number = .5;
		
		public function CCSettings($id:String=null, $data:Object=null) 
		{
			super($id, $data);
		}
		
		override protected function init():void 
		{
			super.init();
			addParser('displayOptions', apply);
		}
		
	}

}