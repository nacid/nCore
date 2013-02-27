package ru.nacid.base.view.data
{

	/**
	 * Position.as
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
	public class Position
	{
		public static function FROM_OBJECT($obj:Object):Position
		{
			return new Position($obj.x, $obj.y, $obj.width, $obj.height);
		}
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;

		public function Position(x:Number=0, y:Number=0, w:Number=0, h:Number=0)
		{
			this.x=x;
			this.y=y;
			this.width=w;
			this.height=h;
		}

		public function clone():Position
		{
			return new Position(x, y, width, height);
		}

	}

}
