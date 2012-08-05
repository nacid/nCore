package ru.nacid.base {
	/**
	 * Model.as
	 * Created On: 5.8 16:34
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
	public class Model {
 
		private static var m_instance:Model;
 
		
 
		/* Model
		 * Use Model.instance
		 * @param singleton DO NOT USE THIS - Use Model.instance */
		public function Model(singleton:Singleton) {
			if (singleton == null)
				throw new Error("Model is a singleton class.  Access via ''Model.instance''.");
		}
 
		/* instance
		 * Gets the Model instance */
		public static function get instance():Model {
 			if (Model.m_instance == null)
				Model.m_instance = new Model(new Singleton());
 			return Model.m_instance;
 		}
	}
}
 
class Singleton { }