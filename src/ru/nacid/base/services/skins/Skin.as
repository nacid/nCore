package ru.nacid.base.services.skins
{
	import flash.display.DisplayObject;
	
	import ru.nacid.base.services.CommandEvent;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;
	import ru.nacid.base.view.ViewObject;
	import ru.nacid.utils.interfaces.ILoader;

	/**
	 * Skin.as
	 * Created On: 21.8 15:18
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/Sand
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
	public class Skin extends ViewObject implements ILoader
	{
		private var _loader:ISkinLoader;
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _data:*;
		private var _void:Boolean;

		public var embed:Boolean;

		private var cont:*;
		private var empt:*;
		
		private var _flipX:Boolean;
		private var _flipY:Boolean;

		public function Skin($loader:ISkinLoader)
		{
			_loader=$loader;

			if (_loader == null)
			{
				_void=true;
			}
			applyId(_void ? 'voidSkin' : $loader.symbol);
		}

		public function load():void
		{
			if (loader && !loaded && !loading)
			{
				loader.execute();
			}
		}
		
		public function flipContent($x:Boolean = false,$y:Boolean = false):void{
			_flipX = $x;
			_flipY = $y;
			
			if(_data is DisplayObject){
				_data.scaleX = _flipX ? -1 : 1;
				_data.x = _flipX ? _data.width : 0;
				
				_data.scaleY = _flipY ? -1 : 1;
				_data.y = _flipY ? _data.height : 0;
			}
		}

		override protected function show():void
		{
			if (_void == false)
			{
				if (loaded)
				{
					_data=_loader.getInstance()

					if (empt && empt is DisplayObject && contains(empt))
					{
						removeChild(empt);
					}

					if (_data is DisplayObject)
						addChild(_data);
				}
				else
				{
					empt=_loader.getEmpty();
					if (empt is DisplayObject)
					{
						addChild(empt);
					}

					_loader.addEventListener(CommandEvent.COMPLETE, loaderHandler);
					if (!loading)
					{
						_loader.execute();
					}
				}
				
				flipContent(_flipX,_flipY);
			}
		}

		private function loaderHandler(e:CommandEvent):void
		{
			_loader.removeEventListener(CommandEvent.COMPLETE, loaderHandler);
			if (empt && empt is DisplayObject && contains(empt))
			{
				removeChild(empt);
			}
			addChild(_data=_loader.getInstance());
			e.preventDefault();
			flipContent(_flipX,_flipY);
		}

		public function get loaded():Boolean
		{
			return _void ? false : _loader.completed;
		}

		public function get loading():Boolean
		{
			return _void ? false : _loader.executing;
		}

		public function get loader():ISkinLoader
		{
			return _void ? null : _loader;
		}

		public function get data():*
		{
			return _data;
		}

		public function get isVoid():Boolean
		{
			return _void;
		}
	}

}
