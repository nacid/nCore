package ru.nacid.base.services
{
	import flash.events.EventDispatcher;

	import ru.nacid.base.data.store.VOList;
	import ru.nacid.utils.DelayedAction;

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
		protected var list:VOList=new VOList();
		protected var step:uint=0;
		protected var interrupt:int=0;
		protected var skipedCount:int=0;
		protected var interruptFrame:int=60;

		private var stepProgress:Number;
		private var currentInterrupt:int;
		private var delayed:DelayedAction;

		public function CommandQueue()
		{
		}

		public function addCommand(cmd:Command, $skipProgress:Boolean=false, autoPriority:Boolean=true):void
		{
			if (list.add(cmd))
			{
				if (autoPriority)
				{
					cmd.priority=-list.size;
				}

				if ($skipProgress)
				{
					cmd.useProgress=false;
					++skipedCount;
				}

				if (msgEnabled)
				{
					log(cmd.symbol.concat(' added to queue ', symbol));
				}
			}
			else if (msgEnabled)
				log(cmd.symbol.concat('not added to queue'));
		}

		override protected function execInternal():void
		{
			if (interrupt)
			{
				delayed=new DelayedAction(interruptFrame);
				currentInterrupt=interrupt;
			}

			stepProgress=1 / (list.size - skipedCount);
			skipedCount=0;
			list.sort(prioritySorter);
			makeStep();
		}

		private function makeStep(e:CommandEvent=null):void
		{
			if (e)
			{
				processListeners(currentCommand, false);
				
				
				if (currentCommand.useProgress)
				{
					++skipedCount;
				}
				++step;
			}
			
			if (step < list.size)
			{
				processListeners(currentCommand, true);
				if (delayed && interrupt)
				{
					if (--currentInterrupt)
					{
						currentCommand.execute();
					}
					else
					{
						currentInterrupt=interrupt;
						delayed.addAction(currentCommand.execute);
					}
				}
				else
				{
					currentCommand.execute();
				}
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
			commitProgress((skipedCount + e.progress) * stepProgress);
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

		public function get size():int
		{
			return list.size;
		}
	}

}
