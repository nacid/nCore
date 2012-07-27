package ru.nacid.base.services.windows.policy 
{
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	import ru.nacid.utils.StringUtils;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class WindowPolicy extends EventDispatcher implements IData 
	{
		private var _id:String;
		private var _numericId:Number;
		protected var locks:Vector.<String>
		
		public function WindowPolicy($id:String, $locks:Array = null) {
			_id = $id;
			_numericId = StringUtils.toCRC($id);
			
			if ($locks) {
				locks = Vector.<String>($locks);
				locks.fixed = true;
			}
		}
		
		public function applyOpen(activeList:Vector.<String>, targetId:String,data:Object):void {
			//virtual
		}
		
		public function applyClose(activeList:Vector.<String>, targetId:String,$force:Boolean = false):void {	
			if(!$force && locks && locks.length){
				for (var i:int = 0; i < activeList.length; i++) {
					if (locks.indexOf(activeList[i]) >= 0)
						return Cc.warnch('MAN', 'window', targetId, 'can not be closed until', activeList[i], 'is opened');
				}
			}
			
			dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, targetId));
		}
		
		/* INTERFACE ru.nacid.base.data.interfaces.IData */
		
		public function get id():String 
		{
			return _id;
		}
		
		public function valueOf():Number 
		{
			return _numericId;
		}
		
	}

}