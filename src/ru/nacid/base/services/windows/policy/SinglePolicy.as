package ru.nacid.base.services.windows.policy 
{
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class SinglePolicy extends WindowPolicy 
	{
		protected var closeOther:Boolean;
		
		public function SinglePolicy($closeOther:Boolean = false,$locks:Array = null) 
		{
			super('singleWindowPolicy', $locks);
			closeOther = $closeOther;
		}
		
		override public function applyOpen(activeList:Vector.<String>, targetId:String,data:Object):void 
		{
			if (closeOther) {
				var inc:int = 0;
				var last:String;
				
				while (activeList.length) {
					if (activeList[inc] == last) {
						if (++inc >= activeList.length)
							break;
						continue;
					}
					last = activeList[inc];
					
					dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.CLOSE_WINDOW, last));
				}
			}
			
			dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, targetId, data, activeList.length));
		}
		
	}

}