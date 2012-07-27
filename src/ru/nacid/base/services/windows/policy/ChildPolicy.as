package ru.nacid.base.services.windows.policy 
{
	import com.junkbyte.console.Cc;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class ChildPolicy extends WindowPolicy 
	{
		protected var parents:Vector.<String>
		
		public function ChildPolicy($parents:Array,$locks:Array=null) 
		{
			super('childPolicy', $locks);
			
			if ($parents) {
				parents = Vector.<String>($parents);
				parents.fixed = true;
			}
		}
		
		override public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void 
		{
			if(parents && parents.length){
				for (var i:int = 0; i < parents.length; i++) {
					if (activeList.indexOf(parents[i]) >= 0) {
						dispatchEvent(new WindowPolicyEvent(WindowPolicyEvent.OPEN_WINDOW, targetId, data, activeList.length));
						return 
					}
				}
			}
			
			Cc.warnch('MAN', 'window', targetId, 'can not be opened because has no active parents');
		}
		
	}

}