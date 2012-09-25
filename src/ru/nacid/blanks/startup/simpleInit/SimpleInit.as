package ru.nacid.blanks.startup.simpleInit 
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.windows.Window;
	import ru.nacid.base.services.windows.WindowParam;
	
	/**
	 * PreloadWindow.as
	 * Created On: 9.8 16:50
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
	public class SimpleInit extends Window 
	{
		public static const ID:String = 'simpleInitWindow';
		
		private var progressIndicator:RotatePreloader;
		private var matrix:Matrix
		
		override protected function init():void 
		{
			super.init();
			progressIndicator = new RotatePreloader();
			matrix = new Matrix();
			
			addElement(progressIndicator);
		}
		
		override public function arrange():void 
		{
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight);
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.RADIAL, [0x505050, 0x333333], [1, 1], [0, 255], matrix);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			progressIndicator.x = stage.stageWidth >> 1;
			progressIndicator.y = stage.stageHeight >> 1;
		}
		
	}

}