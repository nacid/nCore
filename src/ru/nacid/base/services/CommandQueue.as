package ru.nacid.base.services 
{
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.store.VOList;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class CommandQueue extends Command 
	{
		private var list:VOList = new VOList();
		private var step:uint = 0;
		
		private var stepProgress:Number;
		
		public function addCommand(cmd:Command):void {
			if (list.add(cmd))
				Cc.logch(CMD_CHANNEL, cmd.id, 'added to queue');
			else
				Cc.warnch(CMD_CHANNEL, 'unable to add command', cmd.id, 'to queue');
		}
		
		override protected function execInternal():void 
		{
			stepProgress = 1 / list.size;
			list.sort(prioritySorter);
			makeStep();
		}
		
		private function makeStep(e:CommandEvent = null):void {
			if (e){
				processListeners(currentCommand, false);
				++step;
			}
			
			if (step < list.size) {
				processListeners(currentCommand, true);
				currentCommand.execute();
			}else {
				onComplete();
			}
		}
		
		protected function onComplete():void {
			notifyComplete();
		}
		
		protected function progressHandler(e:CommandEvent):void {
			commitProgress((step + e.progress) * stepProgress);
		}
		
		private function prioritySorter(x:Command, y:Command):Number {
			return x.priority > y.priority ? -1 : 1;
		}
		
		private function processListeners($target:Command, $add:Boolean):void {
			if ($add) {
				$target.addEventListener(CommandEvent.PROGRESS, progressHandler);
				$target.addEventListener(CommandEvent.COMPLETE, makeStep);
				$target.addEventListener(CommandEvent.ERROR, onError);
			}else {
				$target.removeEventListener(CommandEvent.PROGRESS, progressHandler);
				$target.removeEventListener(CommandEvent.COMPLETE, makeStep);
				$target.removeEventListener(CommandEvent.ERROR, onError);
			}
		}
		
		private function get currentCommand():Command {
			return list.at(step) as Command;
		}
		
		public function getCurrentID():String {
			return currentCommand.id;
		}
	}

}