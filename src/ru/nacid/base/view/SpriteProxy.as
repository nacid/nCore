package ru.nacid.base.view
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import ru.nacid.base.view.interfaces.IDisplayContainerProxy;
	import ru.nacid.base.view.interfaces.IDisplayObject;

	/**
	 * SimpleViewObject.as
	 * Created On: 9.2 03:22
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/nCore
	 *
	 *
	 *		Copyright 2013 Nikolay nacid Bondarev
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

	public class SpriteProxy implements IDisplayContainerProxy
	{
		private var _main:DisplayObjectContainer;

		public function SpriteProxy($main:DisplayObjectContainer)
		{
			_main=$main || new ViewObject;
		}

		public function get main():*
		{
			return _main;
		}

		public function empty($safe:Boolean=false):IDisplayContainerProxy
		{
			return new SpriteProxy(new ViewObject);
		}

		public function add($display:IDisplayObject):IDisplayObject
		{
			var add:DisplayObject=$display is IDisplayContainerProxy ? ($display as IDisplayContainerProxy).main : $display as DisplayObject;
			_main.addChild(add);
			return $display;
		}

		public function addAt($display:IDisplayObject, $depth:int):IDisplayObject
		{
			var add:DisplayObject=$display is IDisplayContainerProxy ? ($display as IDisplayContainerProxy).main : $display as DisplayObject;
			_main.addChildAt(add, $depth);
			return $display;
		}

		public function rem($display:IDisplayObject):IDisplayObject
		{
			var rem:DisplayObject=$display is IDisplayContainerProxy ? ($display as IDisplayContainerProxy).main : $display as DisplayObject;
			_main.removeChild(rem);
			return $display;
		}

		public function move($display:IDisplayObject, $depth:int):void
		{
			_main.setChildIndex($display as DisplayObject, $depth);
		}

		public function getDepth($display:IDisplayObject):int
		{
			return _main.getChildIndex($display as DisplayObject);
		}

		public function get numChild():int
		{
			return _main.numChildren;
		}

		public function compatibility($with:*):Boolean
		{
			return $with is DisplayObject;
		}
		
		public function setFocus($value:IDisplayObject = null):void{
			if(_main.stage is Stage){
				Stage(_main.stage).focus = $value as InteractiveObject || _main;
			}
		}
	}
}
