package ru.nacid.base.data 
{
	import com.junkbyte.console.Cc;
	import flash.utils.ByteArray;
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.utils.StringUtils;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class ValueObject extends SimpleValueObject implements IChannelParent,IData
	{
		protected const VO_CHANNEL:String = 'DTO';
		
		protected var parsers:Object = { };
		private var _inited:Boolean;
		
		public function ValueObject($id:String = null, $data:Object = null) 
		{
			super($id);
			
			init();
			apply($data);
			if ($id) id = $id;
		}
		
		protected function init():void {
			if (inited) return;
			
			_inited = true;
		}
		
		public function apply($data:Object):void {
			if ($data == null) return;
			
			for ( var field:* in $data) {
				if (parsers.hasOwnProperty(field)) {
					parsers[field].call(null, $data[field]);
				}else if (hasOwnProperty(field)) {
					this[field] = $data[field];
				}
			}
		}
		
		protected function internalClone():Object {
			var copier:ByteArray = new ByteArray();
			
			copier.writeObject(this);
			copier.position = 0;
			return copier.readObject();
		}
		
		protected function addParser($field:String, $callback:Function):void {
			parsers[$field] = $callback;
		}
		
		protected function removeParser($filed:String):void {
			delete parsers[$filed];
		}
		
		protected function dropParsers():void {
			parsers = { };
		}
		
		override public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
			_numericId = StringUtils.toCRC(value);
		}
		
		public function get inited():Boolean 
		{
			return _inited;
		}
		
		public function compare($vo:ValueObject):Boolean {
			return $vo.valueOf() == _numericId;
		}
		
		override public function valueOf():Number {
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