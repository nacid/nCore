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
		private var _name:Object;
		private var _chain:Object;
		private var _commitOnly:Boolean;

		private var _current:ChangeWatcher;

		public function PropertyBind($targetHost:Object, $targetName:String, $name:Object, $chain:Object, $commitOnly:Boolean=false, $useWeakRef:Boolean=false)
		{
			_targetHost=$targetHost;
			_targetName=$targetName;
			_name=$name;
			_chain=$chain;
			_commitOnly=$commitOnly;

			super(HashUtils.SHA([_targetName, _targetHost, _chain, _name, _commitOnly]));
		}

		public function createWatcher($safe:Boolean=true):ChangeWatcher
		{
			if ($safe && _current && _current.isWatching())
			{
				return null;
			}

			return _current=BindingUtils.bindProperty(_targetHost, _targetName, _chain, _name,_commitOnly);
		}
	}
}
