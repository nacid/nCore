package ru.nacid.utils.binding.types
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import ru.nacid.base.data.SimpleValueObject;
	import ru.nacid.utils.HashUtils;
	import ru.nacid.utils.binding.types.interfaces.IBind;

	public class PropertyBind extends SimpleValueObject implements IBind
	{
		private var _targetHost:Object;
		private var _targetName:String;
		private var _name:String;
		private var _chain:Object;
		private var _commitOnly:Boolean;
		private var _useWeakRef:Boolean;

		private var _current:ChangeWatcher;

		public function PropertyBind($targetHost:Object, $targetName:String, $name:String, $chain:Object, $commitOnly:Boolean=false, $useWeakRef:Boolean=false)
		{
			_targetHost=$targetHost;
			_targetName=$targetName;
			_name=$name;
			_chain=$chain;
			_commitOnly=$commitOnly;
			_useWeakRef=$useWeakRef;

			super(HashUtils.SHA([_targetName, _targetHost, _chain, _name, _commitOnly, _useWeakRef]));
		}

		public function createWatcher($safe:Boolean=true):ChangeWatcher
		{
			if ($safe && _current && _current.isWatching())
			{
				return null;
			}

			return _current=BindingUtils.bindProperty(_targetHost, _targetName, _name, _chain, _commitOnly, _useWeakRef);
		}
	}
}
