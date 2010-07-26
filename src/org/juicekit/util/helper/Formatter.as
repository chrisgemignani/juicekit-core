/*
* Copyright 2007-2010 Juice, Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


package org.juicekit.util.helper {
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	
	import org.juicekit.util.Strings;
	
	/**
	 * The Formatter class methods produce labeling functions for use as values
	 * for a DataGridColumn labelFunction property.
	 *
	 * @author Jon Buffington
	 * @author Chris Gemignani
	 */
	public class Formatter {
		
		
		/**
		 * <p>Creates a labeling function used by a DataGridColumn instance
		 * using Strings.format conventions. This follows the String formatting
		 * conventions of the .NET framework. An overview can be found
		 * <a href="http://msdn2.microsoft.com/en-us/library/fbxft59x.aspx">here</a>.
		 * This formatting convention is very similar to Microsoft Excel custom formats.</p>
		 *
		 * @param fmt a formatting string. The formatting string will be receive only
		 * a single argument <code>item[column.dataField]</code> where item is the object
		 * representing the current row of the DataGrid and column represents the current
		 * column. <code>fmt</code> can take two forms. Form one: a simple picture like "0.00".
		 * In this case fmt will be wrapped in '{0:'+fmt+'}'. Form two: a complete formatting
		 * string like '{0:0.00} widgets'.
		 * @param formatField an optional field that contains a formatting string. This
		 * will be evaluated using the same rules as <code>fmt</code>.
		 * @return A formatting function suitable for use as a DataGrid.labelFunction
		 *
		 * @see flare.util.Strings
		 */
		public static function dataGridLabelFunction(fmt:String, formatField:String = ''):Function {
			var fn:Function = null;
			// if the string is a simple picture, it will not contain
			// {, }, or :
			if (fmt.indexOf('{') == -1 &&
				fmt.indexOf('}') == -1 &&
				fmt.indexOf(':') == -1) {
				if (fmt.length > 0) {
					fn = function (item:Object, column:DataGridColumn):String {
						return Strings.format('{0:' + fmt + '}', item[column.dataField]);
					}
				} else {
					fn = function (item:Object, column:DataGridColumn):String {
						return Strings.format('{0}', item[column.dataField]);
					}
				}
			} else {
				// the format string is of the form 'This is the {0:0.00} value'
				fn = function (item:Object, column:DataGridColumn):String {
					return Strings.format(fmt, item[column.dataField]);
				}
			}
			
			// If a format field has been specified
			if (formatField.length > 0) {
				return function (item:Object, column:DataGridColumn):String {
					if (item.hasOwnProperty(formatField)) {
						fmt = item[formatField].toString();
						return dataGridLabelFunction(fmt)(item, column) as String
					} else {
						return fn(item, column) as String;
					}
				}
			}
			
			return fn;
		}
		
		
		
		/**
		 * Provided as an auxillary function to access an array-based named
		 * property value as a String. Intended to be assigned to a
		 * DataGridColumn's labelFunction property.
		 */
		public static function arrayIndexProperty(item:Object, column:DataGridColumn):String {
			// TODO: this should use Property. Evaluate for inclusion.
			const cachedProp:* = item[column.dataField];
			if (cachedProp !== undefined) {
				return cachedProp.toString();
			}
			// Extract parts from "array.index.property".
			const parts:Array = column.dataField.split(".");
			const arrName:String = parts[0] as String;
			const indexI:uint = parseInt(parts[1] as String);
			const propName:String = parts[2] as String;
			// a safe "item[arrName][indexI][propName].toString()" follows...
			const ac:ArrayCollection = item[arrName];
			if (!ac) {
				return "";
			}
			const obj:Object = ac.getItemAt(indexI);
			if (!obj) {
				return "";
			}
			const prop:* = obj[propName];
			if (prop === undefined) {
				return "";
			}
			// Need to cache value so sorting works.
			item[column.dataField] = prop;
			return prop.toString();
		}
		
		
		// TODO: Test and improve the following before making public.
		/**
		 * @private
		 *
		 * A DataGridColumn helper function creates functions to navigate
		 * an object tree structure using dotted-name notation. The column
		 * parameter's dataField property is parsed to extract an object
		 * navigation pattern. This pattern is walked to return the leaf
		 * data value as a string. The last member of the pattern must be an
		 * Array type which is indexed using the index outer parameter.
		 */
		private static function treeNavigator(index:uint):Function {
			// TODO: this should use Property. Evaluate for inclusion.
			return function (item:Object, column:DataGridColumn):String {
				// Note: This is should be foldl.
				const parts:Array = column.dataField.split(".");
				const nextToLast:uint = parts.length - 1;
				var p:* = item;
				for (var i:uint = 0; i < nextToLast; i++) {
					p = p[parts[i]];
					if (p === undefined) {
						break;
					}
				}
				return (!p is Array) ? p[index].toString() : "";
			}
		}
	}
}
