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

package org.juicekit.containers {
	
	/**
	 *
	 *  Copyright (c) 2008 Noel Billig (http://www.dncompute.com)
	 *
	 *  Permission is hereby granted, free of charge, to any person obtaining a copy
	 *  of this software and associated documentation files (the "Software"), to deal
	 *  in the Software without restriction, including without limitation the rights
	 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 *  copies of the Software, and to permit persons to whom the Software is
	 *  furnished to do so, subject to the following conditions:
	 *
	 *  The above copyright notice and this permission notice shall be included in
	 *  all copies or substantial portions of the Software.
	 *
	 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 *  THE SOFTWARE.
	 *
	 */
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	
	/**
	 *
	 *  This class encapsulates all of the code to resize an embedded
	 *  flash movie on an HTML page.
	 *
	 *  This class currently applies a collection of browser "hacks" to help
	 *  ease the use of this class cross browser. However, depending on how
	 *  complicated your usage is, it may be worthwhile to turn off hacks that
	 *  are not necessary to use. For instance, if you don't use any of the
	 *  min/max settings, you can turn off the IEReparenting.
	 *
	 *  If you run into any issues with this class, please post comments into
	 *  my blog so I can look into issues. Even better is if you can post fixes
	 *  for any issues you run into ;-)
	 *
	 *
	 */
	public class BrowserCanvas implements IMXMLObject {
		
		public static const HACK_MARGIN_BOTTOM:String = "marginBottom"; //Adds a negative bottom margin to object tags to compensate for browser weirdness
		public static const HACK_IE_REPARENT:String = "IEReparent"; //In IE, create a container div which encapsulates the object tag in order to hav min/max sizes work
		public static const HACK_UNIQUE_ID:String = "uniqueId"; //If you put both an embed and object tag with the same id, this tries to compensate
		
		public var containerId:String;
		
		private var _width:String;
		private var _minWidth:String;
		private var _maxWidth:String;
		
		private var _height:String;
		private var _minHeight:String;
		private var _maxHeight:String;
		
		private var timerSprite:Sprite;
		
		
		/**
		 *
		 * @param stage - A reference to the stage. We use the url of the stages loaderinfo object
		 *    as a way to figure out if we are targeting the right flash movie (for cases where an
		 *    id is not passed)
		 *
		 * @param containerId - We use the containerId as a reference to the div/obj/embed we should
		 *    resize. You should always send a containerId if you have multiple instances of the
		 *    same flash movie embedded in a page.
		 *
		 * @param browserHacks - A list of flags indicating which hacks to apply. This defaults to
		 *    applying all hacks. In order to overcome browser differences and HMTL errors, you can
		 *    turn these hacks on or off by sending in the appropriate flag. To turn them all off,
		 *    send in an empty array.
		 */
		public function BrowserCanvas(containerId:String = null, browserHacks:Array = null):void {
			trace("BrowserCanvas - Copyright (c) 2008 Noel Billig (http://www.dncompute.com)");
			
			timerSprite = new Sprite();
			
			// Removed HACK_ID_REPARENT
			// browserHacks = [HACK_MARGIN_BOTTOM, HACK_IE_REPARENT, HACK_UNIQUE_ID];
			if (browserHacks == null) {
				browserHacks = [HACK_MARGIN_BOTTOM, HACK_UNIQUE_ID];
			}
			
			this.containerId = containerId;
			if (this.containerId == null)
				this.containerId = ExternalInterface.objectID;
			
			if (browserHacks.length != 0) {
				this.containerId = ExternalInterface.call(JSScripts.INSERT_BROWSER_HACKS, this.containerId, browserHacks.join(","));
			}			
		}
		
		
		
		/**
		 * Implement IMXMLObject
		 */
		public  function initialized(document:Object, id:String):void {
			// Hook into Application resizing to automatically match the size
			// of the browser embed object to the application size
			FlexGlobals.topLevelApplication.removeEventListener(FlexEvent.UPDATE_COMPLETE, updateBrowserToApplicationDimensions);
			FlexGlobals.topLevelApplication.addEventListener(FlexEvent.UPDATE_COMPLETE, updateBrowserToApplicationDimensions);			
		}
		
		
		private function updateBrowserToApplicationDimensions(e:FlexEvent):void {
			height = FlexGlobals.topLevelApplication.measuredHeight;
			width = FlexGlobals.topLevelApplication.measuredWidth;
		}
		
		public function set width(newWidth:String):void {
			this._width = formatSize(newWidth);
			invalidate();
		}
		
		public function set minWidth(newWidth:String):void {
			this._minWidth = formatSize(newWidth);
			invalidate();
		}
		
		public function set maxWidth(newWidth:String):void {
			this._maxWidth = formatSize(newWidth);
			invalidate();
		}
		
		
		public function set height(newHeight:String):void {
			this._height = formatSize(newHeight);
			invalidate();
		}
		
		public function set minHeight(newHeight:String):void {
			this._minHeight = formatSize(newHeight);
			invalidate();
		}
		
		public function set maxHeight(newHeight:String):void {
			this._maxHeight = formatSize(newHeight);
			invalidate();
		}
		
		private function formatSize(size:String):String {
			if (size == null) {
				return ""; //Null causes opera to never clear the appropriate values, so use empty string
			}
			return (int(size) == 0) ? size : size + "px";
		}
		
		
		private function invalidate():void {
			timerSprite.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event):void {
			timerSprite.removeEventListener(Event.ENTER_FRAME, update);
			ExternalInterface.call(JSScripts.RESIZE_CONTAINER, containerId, _width, _height, _minWidth, _minHeight, _maxWidth, _maxHeight);
		}
		
	}
	
}

class JSScripts {

	public static var INSERT_BROWSER_HACKS:XML = <script><![CDATA[
			  function (containerId,browserHacks) {
				  var objNode = document.getElementById(containerId);
				  if (objNode.nodeName.toLowerCase() == "div") return;
				  
				  //If you make the mistake of naming the object and embed nodes with the same id, firefox will get confused
				  if (	((navigator.userAgent.toLowerCase().indexOf("firefox") != -1) ||
						  (navigator.userAgent.toLowerCase().indexOf("opera") != -1)) &&
						  (objNode.nodeName.toLowerCase() == "object") &&
						  (browserHacks.indexOf("uniqueId") != -1)
						  ) {
					  
					  //Check if we have an embed tag inside of us, if so, ignore the obj tag
					  var newNode = objNode.getElementsByTagName("embed")[0];
					  if (newNode != null) {
						  newNode.setAttribute("id",objNode.attributes["id"].nodeValue);
						  objNode.attributes["id"].nodeValue += new Date().getTime();
						  objNode.attributes['width'].nodeValue = "auto";
						  objNode.attributes['height'].nodeValue = "auto";
						  objNode.style.width = "";
						  objNode.style.height = "";
						  objNode = newNode;
					  }
					  
				  }
				  
				  //All of the browsers but IE seem to put a margin underneath all object/embed tags. 
				  //Seems like a bug, but it's suspicious that it's a problem in all browsers but IE.
				  if (	(navigator.userAgent.toLowerCase().indexOf("msie") == -1) && 
						  (browserHacks.indexOf("marginBottom") != -1)
						  ) {
					  if (navigator.userAgent.toLowerCase().indexOf("opera") != -1) {
						  objNode.style.marginBottom = "-4px";
					  } else {
						  objNode.style.marginBottom = "-5px";
					  }
				  }
				  
				  
				  //IE has a bug where it doesn't respect the min-height/max-width style settings on an object tag
				  //To work around this, we reparent the object tag into a div, and use the ref to the div instead.
				  if (	(navigator.userAgent.toLowerCase().indexOf("msie") != -1) && 
						  (objNode.nodeName.toLowerCase() == "object") && 
						  (browserHacks.indexOf("IEReparent") != -1)
						  ) {
					  
					  //Insert a parent div above the object node
					  var newId = "swfContainer"+(new Date().getTime());
					  divNode = document.createElement('div');
					  objNode.parentNode.insertBefore(divNode,objNode);
					  divNode.setAttribute('id',newId);
					  divNode.appendChild(objNode);
					  
					  //Set the parent div to the size of the object node, and the object node to 100%
					  var getFormattedValue = function(val) {
						  if ((val.indexOf("px") == -1) && (val.indexOf("%") == -1)) return val+"px";
						  return val;
					  }
					  divNode.style.width = getFormattedValue(objNode.attributes['width'].nodeValue);
					  divNode.style.height = getFormattedValue(objNode.attributes['height'].nodeValue);
					  objNode.attributes['width'].nodeValue = "100%";
					  objNode.attributes['height'].nodeValue = "100%";
					  return newId;
				  }
				  return containerId;
			  }
			  ]]></script>;
	
	
	public static var RESIZE_CONTAINER:XML = <script><![CDATA[
			  function(containerId,width,height,minWidth,minHeight,maxWidth,maxHeight) {
				  var objNode = document.getElementById(containerId);
				  objNode.style.width = width;
				  objNode.style.height = height;
				  objNode.style.minWidth = minWidth;
				  objNode.style.minHeight = minHeight;
				  objNode.style.maxWidth = maxWidth;
				  objNode.style.maxHeight = maxHeight;
				  objNode.attributes.width.nodeValue = width;
				  objNode.attributes.height.nodeValue = height;
			  }
			  ]]></script>;
	
}