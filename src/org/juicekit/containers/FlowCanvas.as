package org.juicekit.containers
{
  import flash.display.Graphics;
  import flash.geom.Matrix;
  
  import mx.containers.Canvas;
  import mx.styles.StyleManager;
  
  import org.juicekit.util.Maths;
  
  /**
  * A canvas that displays a "flow" shape. The flow can be horizontal or vertical and
  * can optionally have a gradient background.
  * Initially derived from http://butterfliesandbugs.wordpress.com/2007/06/08/generic-background-gradient-for-containers/
  */
  public class FlowCanvas extends Canvas
  {

    /**
     * The direction of the shape. <code>horizontal</code> is
     * left to right. <code>vertical</code> is top to bottom.
     *
     * @default "horizontal"
     */
    [Inspectable(default='horizontal', enumeration='horizontal,vertical')]
    [Bindable]
    public function get direction():String {
      return _direction;
    }
    
    public function set direction(v:String):void {
      _direction = v;
      invalidateDisplayList();
    }
    
    private var _direction:String = 'horizontal';
    
    
    /**
     * The width of the shape on the left hand or
     * top side as a Number from 0.0 (converging to
     * a point) to 1.0 (the full width of the container).
     *
     * @default 1.0
     */
    [Inspectable(default=1.0)]
    [Bindable]
    public function get fromAmount():Number {
      return _fromAmount;
    }
    
    public function set fromAmount(v:Number):void {
      _fromAmount = v;
      invalidateDisplayList();
    }
    
    private var _fromAmount:Number = 1.0;
    
    
    /**
     * The width of the shape on the right hand or
     * bottom side as a Number from 0.0 (converging to
     * a point) to 1.0 (the full width of the container).
     *
     * @default 1.0
     */
    [Inspectable(default=1.0)]
    [Bindable]
    public function get toAmount():Number {
      return _toAmount;
    }
    
    public function set toAmount(v:Number):void {
      _toAmount = v;
      invalidateDisplayList();
    }
    
    private var _toAmount:Number = 1.0;
    
    
    /**
     * The colors used in the gradient fill.
     *
     * @default #000000, #999999
     */
    [Bindable]
    public function get fillColors():Array {
      return _fillColors;
    }
    
    public function set fillColors(v:Array):void {
      _fillColors = v;
      invalidateDisplayList();
    }
    
    private var _fillColors:Array = [0x000000, 0x999999];
    
    
    /**
     * The from color.
     *
     * @default #000000
     */
    [Bindable]
    public function set fromColor(v:*):void {
      var c:uint = StyleManager.getStyleManager(null).getColorName(v);
      if (c == StyleManager.NOT_A_COLOR) {
        c = 0;
      }
      _fillColors[0] = c;
      invalidateDisplayList();
    }
    
    public function get fromColor():uint {
      return _fillColors[0];
    }
    
    /**
     * The to color.
     *
     * @default #000000
     */
    [Bindable]
    public function set toColor(v:*):void {
      var c:uint = StyleManager.getStyleManager(null).getColorName(v);
      if (c == StyleManager.NOT_A_COLOR) {
        c = 0;
      }
      _fillColors[1] = c;
      invalidateDisplayList();
    }
    
    public function get toColor():uint {
      return _fillColors[1];
    }
    
    
    /**
     * The alphas used in the gradient fill.
     *
     * @default [1.0, 1.0]
     */
    public function get fillAlphas():Array {
      return _fillAlphas;
    }
    
    public function set fillAlphas(v:Array):void {
      _fillAlphas = v;
      invalidateDisplayList();
    }
    
    private var _fillAlphas:Array = [1.0, 1.0];
    
    /**
     * The from alpha.
     *
     * @default #000000
     */
    [Bindable]
    public function get fromAlpha():Number {
      return _fillAlphas[0];
    }
    
    public function set fromAlpha(v:Number):void {
      v = Maths.clampValue(v, 0.0, 1.0);
      _fillAlphas[0] = v;
      invalidateDisplayList();
    }
    
    /**
     * The to alpha.
     *
     * @default #000000
     */
    [Bindable]
    public function get toAlpha():Number {
      return _fillAlphas[1];
    }
    
    public function set toAlpha(v:Number):void {
      v = Maths.clampValue(v, 0.0, 1.0);
      _fillAlphas[1] = v;
      invalidateDisplayList();
    }
    
    /**
     * The type of gradient fill. Choices are 'linear' and 'radial'.
     *
     * @default linear
     */
    [Inspectable(default='linear', enumeration='linear,radial')]
    public function get gradientType():String {
      return _gradientType;
    }
    
    public function set gradientType(v:String):void {
      _gradientType = v;
      invalidateDisplayList();
    }
    
    private var _gradientType:String = 'linear';
    
    
    /**
     * The angle for the linear or radial fill.
     *
     * @default NaN
     */
    public function get angle():Number {
      return _angle;
    }
    
    public function set angle(v:Number):void {
      _angle = v;
      invalidateDisplayList();
    }
    
    protected var defaultAngle:Number = 90;
    private var _angle:Number = NaN;
    
    /**
     * The focal point ratio for a radial fill.
     *
     * @default 0.5
     */
    public function get focalPointRatio():Number {
      return _focalPointRatio;
    }
    
    public function set focalPointRatio(v:Number):void {
      _focalPointRatio = v;
      invalidateDisplayList();
    }
    
    private var _focalPointRatio:Number = 0.5;
    
    
    /**
     * Begins a gradient fill using CSS properties
     *
     * <p>If fillColors is not specified, a solid fill
     * will be created.</p>
     */
    protected function beginGradientFillFromCSS(graphics:Graphics, unscaledWidth:Number, unscaledHeight:Number):void {
      var useGradientFill:Boolean = (fillColors != null);
      
      if (useGradientFill) {
        // Default values, if styles aren’t defined
        var matrix:Matrix = new Matrix();
        if (isNaN(angle)) {
          angle = defaultAngle;
        }
        matrix.createGradientBox(unscaledWidth, unscaledHeight, angle * Math.PI / 180);
        graphics.beginGradientFill(gradientType, fillColors, fillAlphas, [0, 255], matrix, "pad", "rgb", focalPointRatio);
      } else {
        // if fillColors are not specified, use a solid fill
        var backgroundColor:uint = getStyle('backgroundColor');
        var backgroundAlpha:Number = getStyle('backgroundAlpha');
        if (isNaN(backgroundAlpha)) {
          backgroundAlpha = 1.0;
        }
        graphics.beginFill(backgroundColor, backgroundAlpha);
      }
      
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      graphics.clear();
      fromAmount = Maths.clampValue(fromAmount, 0.0, 1.0);
      toAmount = Maths.clampValue(toAmount, 0.0, 1.0);
      
      // If gradient fill angle is not specified, determine the angle automatically
      var angle:Number = getStyle("angle");
      if (isNaN(angle)) {
        if (direction == 'horizontal') {
          defaultAngle = 0;
        } else {
          defaultAngle = 90;
        }
      }
      
      // performs a graphics.beginGradientFill(...) or a
      // graphics.beginFill(...)
      beginGradientFillFromCSS(graphics, unscaledWidth, unscaledHeight);
      
      var w:Number;
      var h:Number;
      if (direction == 'horizontal') {
        w = unscaledWidth;
        h = unscaledHeight;
      } else {
        w = unscaledHeight;
        h = unscaledWidth;
      }
      
      var xStart:Number = w * 0.00;
      var xStartMid:Number = w * 0.25;
      var xMid:Number = w * 0.50;
      var xMidEnd:Number = w * 0.75;
      var xEnd:Number = w * 1.00;
      
      var _startYOffset:Number = (h * (1.0 - fromAmount)) / 2;
      var _endYOffset:Number = (h * (1.0 - toAmount)) / 2;
      var yStartTop:Number = _startYOffset;
      var yEndTop:Number = _endYOffset;
      var yMidTop:Number = (yStartTop + yEndTop) / 2;
      
      var yStartBottom:Number = h - _startYOffset;
      var yEndBottom:Number = h - _endYOffset;
      var yMidBottom:Number = (yStartBottom + yEndBottom) / 2;
      
      if (direction == 'horizontal') {
        graphics.moveTo(xStart, yStartTop);
        graphics.curveTo(xStartMid, yStartTop, xMid, yMidTop);
        graphics.curveTo(xMidEnd, yEndTop, xEnd, yEndTop);
        graphics.lineTo(xEnd, yEndBottom);
        graphics.curveTo(xMidEnd, yEndBottom, xMid, yMidBottom);
        graphics.curveTo(xStartMid, yStartBottom, xStart, yStartBottom);
        graphics.lineTo(xStart, yStartTop);
      } else {
        // reverse all the x and y values
        graphics.moveTo(yStartTop, xStart);
        graphics.curveTo(yStartTop, xStartMid, yMidTop, xMid);
        graphics.curveTo(yEndTop, xMidEnd, yEndTop, xEnd);
        graphics.lineTo(yEndBottom, xEnd);
        graphics.curveTo(yEndBottom, xMidEnd, yMidBottom, xMid);
        graphics.curveTo(yStartBottom, xStartMid, yStartBottom, xStart);
        graphics.lineTo(yStartTop, xStart);
      }
      graphics.endFill();
      
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    
    /**
    * Constructor
    */
    public function FlowCanvas()
    {
      super();
    }
  }
}