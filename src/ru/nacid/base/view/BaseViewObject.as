package ru.nacid.base.view 
{
	import ru.nacid.base.view.data.Position;
	import spark.components.SkinnableContainer;
	import spark.core.SpriteVisualElement;
	/**
	 * SimpleViewObject.as
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
	public class BaseViewObject extends SkinnableContainer   
	{
		public function writePosition($position:Position):void {
			x = $position.x;
			y = $position.y;
			width = $position.width;
			height = $position.height;
		}
		
		public function readPosition($from:Position = null):Position {
			return Position.FROM_OBJECT(this);
		}
	}

}