package ru.nacid.base.services.windows
{
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	import ru.nacid.base.services.windows.policy.WindowPolicy;

	/**
	 * WindowParam.as
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
	public class WindowParam extends ValueObject implements IWindowStorage
	{
		public var skinName:String;

		private var _policy:WindowPolicy;
		private var _render:Class;
		private var _cached:Boolean;
		private var _modal:Boolean;

		public function WindowParam($id:String, $render:Class, $policy:WindowPolicy, $cached:Boolean=false, $modal:Boolean=false, $skinName:String=null)
		{
			id=$id;
			skinName=$skinName;

			_policy=$policy;
			_render=$render;
			_cached=$cached;
			_modal=$modal;
		}

		public function get useSkin():Boolean
		{
			return skinName is String
		}
		;

		public function get policy():WindowPolicy
		{
			return _policy
		}
		;

		public function get render():Class
		{
			return _render
		}
		;

		public function get cached():Boolean
		{
			return _cached
		}
		;

		public function get modal():Boolean
		{
			return _modal
		}
		;

	}

}
