package ru.nacid.utils.binding.types
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import ru.nacid.base.data.SimpleValueObject;
	import ru.nacid.utils.HashUtils;
	import ru.nacid.utils.binding.types.interfaces.IBind;

	public class SetterBind extends SimpleValueObject implements IBind
	{
		private var _setter:Function;
		private var _name:Object;
		private var _chain:Object;
		private var _commitOnly:Boolean;

		private var _current:ChangeWatcher;

		public function SetterBind($setter:Function, $name:Object, $chain:Object, $commitOnly:Boolean=false, $useWeakRef:Boolean=false)
		{
			_setter=$setter;
			_name=$name;
			_chain=$chain;
			_commitOnly=$commitOnly;

			//super(HashUtils.SHA([_setter, _name, _chain, _commitOnly, _useWeakRef]));
			super(HashUtils.getRandomSigSHA())
		}

		public function createWatcher($safe:Boolean=true):ChangeWatcher
		{
			if ($safe && _current && _current.isWatching())
			{
				return null;
			}

			return _current=BindingUtils.bindSetter(_setter, _chain, _name, _commitOnly);
		}
	}
}
