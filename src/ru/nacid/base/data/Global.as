package ru.nacid.base.data
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import ru.nacid.base.services.lan.data.RequestVO;

	/**
	 * Global.as
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
	public class Global
	{
		private static var _flashVars:Object = {};
		
		public static function attachFlashVars($data:Object):void{
			if($data){
				for (var field:String in $data){
					_flashVars[field] = $data[field];
				}
			}else{
				_flashVars = {};
			}
		}
		
		public static var language:String;
		public static var debugger:Boolean;
		public static var release:Boolean;
		public static var appName:String;
		public static var domain:RequestVO;

		public static var stageW:Number;
		public static var stageH:Number;
		public static var stage:IEventDispatcher;
		public static var stageFPS:int;
		
		public static function isDebug():Boolean{
			return _flashVars.debug;
		}
		
		public static function isRelease():Boolean{
			return !isDebug();
		}
	}

}
