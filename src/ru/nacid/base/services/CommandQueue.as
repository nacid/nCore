package ru.nacid.base.services
{
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.store.VOList;

	/**
	 * CommandQueue.as
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
	public class CommandQueue extends Command
	{
		private var list:VOList=new VOList();
		private var step:uint=0;

		private var stepProgress:Number;
		
		public function addCommand(cmd:Command):void
		{
			if (list.add(cmd))
				Cc.logch(CMD_CHANNEL, cmd.symbol, 'added to queue', symbol);
			else
				Cc.warnch(CMD_CHANNEL, 'unable to add command', cmd.symbol, 'to queue');
		}

		override protected function execInternal():void
		{
			stepProgress=1 / list.size;
			list.sort(prioritySorter);
			makeStep();
		}

		private function makeStep(e:CommandEvent=null):void
		{
			if (e)
			{
				processListeners(currentCommand, false);
				++step;
			}

			if (step < list.size)
			{
				processListeners(currentCommand, true);
				currentCommand.execute();
			}
			else
			{
				onComplete();
			}
		}

		protected function onComplete():void
		{
			notifyComplete();
		}

		protected function progressHandler(e:CommandEvent):void
		{
			commitProgress((step + e.progress) * stepProgress);
		}

		private function prioritySorter(x:Command, y:Command):Number
		{
			return x.priority > y.priority ? -1 : 1;
		}

		private function processListeners($target:Command, $add:Boolean):void
		{
			if ($add)
			{
				$target.addEventListener(CommandEvent.PROGRESS, progressHandler);
				$target.addEventListener(CommandEvent.COMPLETE, makeStep);
				$target.addEventListener(CommandEvent.ERROR, onError);
			}
			else
			{
				$target.removeEventListener(CommandEvent.PROGRESS, progressHandler);
				$target.removeEventListener(CommandEvent.COMPLETE, makeStep);
				$target.removeEventListener(CommandEvent.ERROR, onError);
			}
		}

		private function get currentCommand():Command
		{
			return list.at(step) as Command;
		}

		public function getCurrentID():String
		{
			return currentCommand.symbol;
		}
	}

}
