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

package org.juicekit.util.preloader {
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;

import mx.events.FlexEvent;
import mx.preloaders.IPreloaderDisplay;

/**
 * This custom preloader was originally copied from the examples on this website:
 * http://www.pathf.com/blogs/2008/08/custom-flex-3-lightweight-preloader-with-source-code/
 *
 * I merged the two classes (PathfinderCustomPreloader.as and PreloaderDisplayBase.as) into this one class
 * and added more constants for defining the sizes and colors of the preloader.
 *
 * The preloader has a main box which is rendered in a blue gradient background, and it contains
 * a logo, a progress bar Sprite, a progress bar frame Sprite, and a TextField for showing the "Loading 0%" text.
 *
 * This code has been modified to display a preloader for JuiceKit.
 *
 * @author Chris Callendar
 * @author Chris Gemignani
 */
public class JuiceKitPreloader extends Sprite implements IPreloaderDisplay {

  [Embed("assets/juicekit_logo.png")]
  [Bindable]
  public var LogoClass:Class;
  private var logo:DisplayObject;

  // Implementation variables, used to make everything work properly
  private var _IsInitComplete:Boolean = false;
  private var _timer:Timer; // we have a timer for animation
  private var _bytesLoaded:uint = 0;
  private var _bytesExpected:uint = 1; // we start at 1 to avoid division by zero errors.
  private var _fractionLoaded:Number = 0; // 0-1
  private var _preloader:Sprite;

  // drop shadow filters used on many sprites
  private var smallDropShadow:DropShadowFilter = new DropShadowFilter(1, 45, 0x333333, 0.5)
  private var largeDropShadow:DropShadowFilter = new DropShadowFilter(4, 45, 0x333333, 0.9)

  // this is the border mainBox
  private var mainBox:Sprite;
  // the progress sprite
  private var bar:Sprite = new Sprite();
  // draws the border around the progress bar
  private var barFrame:Sprite;
  // the textfield for rendering the "Loading 0%" string
  private var loadingTextField:TextField;
  // the textfield for rendering additional messages
  private var messageTextField:TextField;
  // the textfield for rendering the Tagline" string
  private var taglineTextField:TextField;

  // the background color(s) - specify 1 or 2 colors
  private var bgColors:Array = [0xffffff, 0xffffff];
  // the mainBox background gradient colors - specify 1 or 2 colors
  private var boxColors:Array = [0xffffff, 0xffffff];
  // the progress bar color - specify either 1, 2, or 4 colors
  private var barColors:Array = [0xfea400, 0xffcc72]; //0x0687d7;
  // the progress bar border color
  private var barBorderColor:uint = 0x333333;
  // the rounded corner radius for the progressbar
  private var barRadius:int = 2;
  // the width of the progressbar
  private var barWidth:int = 90;
  // the height of the progressbar
  private var barHeight:int = 10;
  // the loading text font
  private var textFont:String = "Arial";
  // the loading text color
  private var textColor:uint = 0xffffff;

  private var loading:String = "Loading ";

  public function JuiceKitPreloader() {
    super();
  }

  virtual public function initialize():void {
    _timer = new Timer(1);
    _timer.addEventListener(TimerEvent.TIMER, timerHandler);
    _timer.start();

    // clear here, rather than in draw(), to speed up the drawing
    clear();

    //creates all visual elements
    createAssets();
  }

  private function clear():void {
    // Don't draw background
    //      var bg:Sprite = new Sprite();
    //      if (bgColors.length == 2) {
    //        var matrix:Matrix = new Matrix();
    //        matrix.createGradientBox(stageWidth, stageHeight, Math.PI / 2);
    //        bg.graphics.beginGradientFill(GradientType.LINEAR, bgColors, [1, 1], [0, 255], matrix);
    //      } else {
    //        bg.graphics.beginFill(uint(bgColors[0]));
    //      }
    //      bg.graphics.drawRect(0, 0, stageWidth, stageHeight);
    //      bg.graphics.endFill();
    //      addChild(bg);
  }

  private function createAssets():void {
    // load the logo first so that we can get its dimensions
    logo = new LogoClass();
    var logoWidth:Number = logo.width;
    var logoHeight:Number = logo.height;

    // make the progress bar the same width as the logo if the logo is large
    barWidth = Math.max(barWidth, logoWidth);
    // calculate the box size and add some padding
    var boxWidth:Number = Math.max(logoWidth, barWidth) + 20;
    var boxHeight:Number = logoHeight + barHeight + 20;

    // create and position the main box (all other sprites are added to it)
    mainBox = new Sprite();
    mainBox.x = stageWidth / 2 - boxWidth / 2;
    mainBox.y = stageHeight / 2 - boxHeight / 2;
    mainBox.filters = [largeDropShadow];
    if (boxColors.length == 2) {
      var matrix:Matrix = new Matrix();
      matrix.createGradientBox(boxWidth, boxHeight, Math.PI / 2);
      mainBox.graphics.beginGradientFill(GradientType.LINEAR, boxColors, [1, 1], [0, 255], matrix);
    } else {
      mainBox.graphics.beginFill(uint(boxColors[0]));
    }

    mainBox.graphics.drawRoundRectComplex(0, 0, boxWidth, boxHeight, 10, 0, 0, 10);
    mainBox.graphics.endFill();
    addChild(mainBox);

    // position the logo
    logo.y = 10;
    logo.x = 10;

    mainBox.addChild(logo);

    //create progress bar
    bar = new Sprite();
    bar.graphics.drawRoundRect(0, 0, barWidth, barHeight, barRadius, barRadius);
    bar.x = 10;
    bar.y = logo.y + logoHeight + 2;
    mainBox.addChild(bar);

    //create progress bar frame
    barFrame = new Sprite();

    barFrame.graphics.lineStyle(0, 0, 0);
    barFrame.graphics.drawRoundRect(-1, -1, barWidth + 2, barHeight + 2, barRadius, barRadius);
    barFrame.graphics.endFill();
    barFrame.x = bar.x;
    barFrame.y = bar.y;
    barFrame.filters = [smallDropShadow];
    mainBox.addChild(barFrame);

    //create text field to show percentage of loading, centered over the progress bar
    loadingTextField = new TextField()
    loadingTextField.width = barWidth;
    // setup the loading text font, color, and center alignment
    var tf:TextFormat = new TextFormat(textFont, 12, textColor, false, null, null, null, null, "center");
    loadingTextField.defaultTextFormat = tf;
    // set the text AFTER the textformat has been set, otherwise the text sizes are wrong
    loadingTextField.text = '' // loading + " 0%";
    // important - give the textfield a proper height
    loadingTextField.height = loadingTextField.textHeight + 8;
    loadingTextField.x = barFrame.x;
    // center the textfield vertically on the progress bar
    loadingTextField.y = barFrame.y + Math.round((barFrame.height - loadingTextField.height) / 2);
    //mainBox.addChild(loadingTextField);

    //create text field to show additional messages
    messageTextField = new TextField()
    messageTextField.width = barWidth;
    // setup the loading text font, color, and center alignment
    var mtf:TextFormat = new TextFormat(textFont, 10, textColor, false, null, null, null, null, "center");
    messageTextField.defaultTextFormat = tf;
    // set the text AFTER the textformat has been set, otherwise the text sizes are wrong
    messageTextField.text = ""
    // important - give the textfield a proper height
    messageTextField.height = messageTextField.textHeight + 8;
    messageTextField.x = barFrame.x;
    // center the textfield vertically on the progress bar
    messageTextField.y = barFrame.y + 20;
    //mainBox.addChild(messageTextField);
  }

  // This function is called whenever the state of the preloader changes.
  // Use the _fractionLoaded variable to draw your progress bar.
  virtual protected function draw():void {
    // update the % loaded string
    loadingTextField.text = loading + Math.round(_fractionLoaded * 100).toString() + "%";

    // draw a complex gradient progress bar
    var matrix:Matrix = new Matrix();
    matrix.createGradientBox(bar.width, bar.height, Math.PI / 2);

    barFrame.graphics.lineStyle(1, 0x666666, 0.5, true);
    barFrame.graphics.beginFill(barBorderColor);
    bar.graphics.drawRoundRect(1, 1, bar.width * 1.0 - 2, bar.height - 2, barRadius, barRadius);
    if (barColors.length == 2) {
      bar.graphics.beginGradientFill(GradientType.LINEAR, barColors, [1, 1], [0, 255], matrix);
    } else if (barColors.length == 4) {
      bar.graphics.beginGradientFill(GradientType.LINEAR, barColors, [1, 1, 1, 1], [0, 127, 128, 255], matrix);
    } else {
      bar.graphics.beginFill(uint(barColors[0]), 1);
    }
    bar.graphics.drawRoundRect(1, 1, bar.width * _fractionLoaded - 2, bar.height - 2, barRadius, barRadius);
    bar.graphics.endFill();
  }

  /**
   * The Preloader class passes in a reference to itself to the display class
   * so that it can listen for events from the preloader.
   * This code comes from DownloadProgressBar.  I have modified it to remove some unused event handlers.
   */
  virtual public function set preloader(value:Sprite):void {
    _preloader = value;

    value.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    value.addEventListener(Event.COMPLETE, completeHandler);
    value.addEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
    value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
  }

  virtual public function set backgroundAlpha(alpha:Number):void {
  }

  virtual public function get backgroundAlpha():Number {
    return 1;
  }

  protected var _backgroundColor:uint = 0xffffffff;

  virtual public function set backgroundColor(color:uint):void {
    _backgroundColor = color;
  }

  virtual public function get backgroundColor():uint {
    return _backgroundColor;
  }

  virtual public function set backgroundImage(image:Object):void {
  }

  virtual public function get backgroundImage():Object {
    return null;
  }

  virtual public function set backgroundSize(size:String):void {
  }

  virtual public function get backgroundSize():String {
    return "auto";
  }

  protected var _stageHeight:Number = 300;

  virtual public function set stageHeight(height:Number):void {
    _stageHeight = height;
  }

  virtual public function get stageHeight():Number {
    return _stageHeight;
  }

  protected var _stageWidth:Number = 400;

  virtual public function set stageWidth(width:Number):void {
    _stageWidth = width;
  }

  virtual public function get stageWidth():Number {
    return _stageWidth;
  }

  //--------------------------------------------------------------------------
  //  Event handlers
  //--------------------------------------------------------------------------

  // Called from time to time as the download progresses.
  virtual protected function progressHandler(event:ProgressEvent):void {
    _bytesLoaded = event.bytesLoaded;
    _bytesExpected = event.bytesTotal;
    _fractionLoaded = Number(_bytesLoaded) / Number(_bytesExpected);

    draw();
  }

  // Called when the download is complete, but initialization might not be done yet.  (I *think*)
  // Note that there are two phases- download, and init
  virtual protected function completeHandler(event:Event):void {
  }


  // Called from time to time as the initialization continues.
  virtual protected function initProgressHandler(event:Event):void {
    draw();
  }

  // Called when both download and initialization are complete
  virtual protected function initCompleteHandler(event:Event):void {
    _IsInitComplete = true;
  }

  // Called as often as possible
  virtual protected function timerHandler(event:Event):void {
    if (_IsInitComplete) {
      // We're done!
      _timer.stop();
      dispatchEvent(new Event(Event.COMPLETE));
    } else {
      draw();
    }
  }

}

}