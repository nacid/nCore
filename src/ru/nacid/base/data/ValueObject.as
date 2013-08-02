package ru.nacid.base.data
{
	import com.junkbyte.console.Cc;
	
	import flash.utils.ByteArray;
	
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.utils.HashUtils;

	/**
	 * ValueObject.as
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
	public class ValueObject extends SimpleValueObject implements IChannelParent, IData
	{
		protected const VO_CHANNEL:String='DTO';

		protected var parsers:Object={};
		
		private var _inited:Boolean;

		public function ValueObject($id:String=null, $data:Object=null)
		{
			super($id);

			init();
			apply($data);
			if ($id)
				symbol=$id;
		}

		protected function init():void
		{
			if (inited)
				return;

			_inited=true;
		}

		public function apply($data:Object):void
		{
			if ($data == null)
				return;

			for (var field:* in $data)
			{
				if (parsers.hasOwnProperty(field))
				{
					parsers[field].call($data[field]);
				}
				else if (hasOwnProperty(field))
				{
					this[field]=$data[field];
				}
			}
		}

		protected function internalClone():Object
		{
			var copier:ByteArray=new ByteArray();

			copier.writeObject(this);
			copier.position=0;
			return copier.readObject();
		}

		protected function addParser($field:String, $callback:Function,$data:Object = null):void
		{
			parsers[$field] = new ParserData($callback,$data);
		}

		protected function removeParser($filed:String):void
		{
			delete parsers[$filed];
		}

		protected function dropParsers():void
		{
			parsers={};
		}

		override public function get symbol():String
		{
			return _id;
		}

		public function set symbol(value:String):void
		{
			_id=value;
			_numericId=HashUtils.CRC(value);
		}

		public function get inited():Boolean
		{
			return _inited;
		}

		public function compare($vo:ValueObject):Boolean
		{
			return $vo.valueOf() == _numericId;
		}

		override public function valueOf():Number
		{
			return _numericId;
		}

		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */

		public function log($string:String):void
		{
			Cc.logch(VO_CHANNEL, $string);
		}

		public function warning($string:String):void
		{
			Cc.warnch(VO_CHANNEL, $string);
		}

		public function info($string:String):void
		{
			Cc.infoch(VO_CHANNEL, $string);
		}

		public function error($string:String):void
		{
			Cc.errorch(VO_CHANNEL, $string);
		}

		public function critical($string:String):void
		{
			Cc.fatalch(VO_CHANNEL, $string);
		}
	}

}

class ParserData{
	
	private var _call:Function;
	private var _data:Object;
	
	public function ParserData($call:Function,$data:Object = null){
		_call = $call;
		_data = $data;
	}
	
	public function call($exeData:*):void{
		if(_data == null){
			_call.call(null,$exeData);
		}else{
			_call.call(null,$exeData,_data);
		}
	}
}
