package ru.nacid.utils.binding
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import ru.nacid.base.data.SimpleValueObject;
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.utils.HashUtils;
	import ru.nacid.utils.binding.types.PropertyBind;
	import ru.nacid.utils.binding.types.SetterBind;
	import ru.nacid.utils.binding.types.interfaces.IBind;

	public class BindViewer extends SimpleValueObject
	{
		private var _binds:VOList;
		private var _watchers:Vector.<ChangeWatcher>;
		private var _paused:Boolean;

		public function BindViewer($key:String = null)
		{
			super('bindViewer::'.concat($key || HashUtils.getRandomSigCRC(16)));

			_binds=new VOList;
			_watchers=Vector.<ChangeWatcher>([]);
		}

		public function addSetterBind($setter:Function, $name:Object, $chain:Object, $commitOnly:Boolean=false, $useWeakRef:Boolean=false):void
		{
			addBind(new SetterBind($setter, $name, $chain, $commitOnly, $useWeakRef));
		}

		public function addPropertyBind($targetHost:Object, $targetName:String, $name:Object, $chain:Object, $commitOnly:Boolean=false, $useWeakRef:Boolean=false):void
		{
			addBind(new PropertyBind($targetHost, $targetName, $name, $chain, $commitOnly, $useWeakRef));
		}

		public function clear():void
		{
			_binds.clear();
		}

		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			if (value != _paused)
			{
				_paused=value;
				updatePaused();
			}
		}

		private function addBind($bind:IBind):void
		{
			if (_binds.add($bind) && !paused)
			{
				_watchers.push($bind.createWatcher());
			}
		}

		private function updatePaused():void
		{
			if (paused)
			{
				while (_watchers.length)
				{
					_watchers.pop().unwatch();
				}
			}
			else
			{
				var iterator:VOIterator=_binds.createIterator();
				while (iterator.hasNext())
				{
					_watchers.push(IBind(iterator.next()).createWatcher());
				}
			}
		}
	}
}
