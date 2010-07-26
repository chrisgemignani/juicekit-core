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


package org.juicekit.util {
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * This class supplies utility methods for working with colors.
	 *
	 * <p>Derived from the Flare Colors class extended with color manipulation  
	 * elements of the NodeBox colors module (http://nodebox.net/code/index.php/Colors).</p>
	 *
	 * Synonyms in parentheses.
	 *
	 * <h3>Color construction functions</h3>
	 * 
	 * <ul>
	 * <li>grey</li>
	 * <li>rgba</li>
	 * <li>hsv</li>
	 * <li>setAlpha</li>
	 * <li>setHue</li>
	 * <li>setSaturation</li>
	 * <li>setValue (setBrightness)</li>
	 * <li>setHsv</li>
	 * <li>adjustHsv -- perform relative adjustments</li>
	 * <li>adjustHue</li>
	 * <li>adjustSaturation</li>
	 * <li>adjustValue (adjustBrightness)</li>
	 * </ul>
	 *
	 * <h3>Color properties</h3>
	 *
	 * <ul>
	 * <li>hue (h)</li>
	 * <li>saturation (s)</li>
	 * <li>value (brightness, v, b)</li>
	 * <li>r</li>
	 * <li>g</li>
	 * <li>b</li>
	 * <li>a</li>
	 * <li>luminance (luminanceFromWhite)</li>
	 * <li>luminanceFromBlack</li>
	 * <li>isGrey (isGray)</li>
	 * <li>isBlack</li>
	 * <li>isWhite</li>
	 * <li>isTransparent</li>
	 * </ul>
	 *
	 * <h3>Color manipulation</h3>
	 *
	 * <ul>
	 * <li>darker (darken)</li>
	 * <li>lighter (lighten)</li>
	 * <li>desaturate</li>
	 * <li>saturate</li>
	 * <li>adjustContrast</li>
	 * <li>complement</li>
	 * <li>analog</li>
	 * <li>rotateColorwheel</li>
	 * <li>darker2 (flare routine)</li>
	 * <li>lighter2 (flare routine)</li>
	 * <li>desaturate2 (flare routine)</li>
	 * </ul>
	 *
	 * <h3>Color comparison and utility</h3>
	 * 
	 * <ul>
	 * <li>interpolate</li>
	 * <li>interpolate_hsv</li>
	 * <li>luminosityDifference</li>
	 * <li>brightnessDifference</li>
	 * <li>colorDifference</li>
	 * <li>whiteOrBlack</li>
	 * <li>getDesaturationMatrix</li>
	 * <li>getBackgroundColor</li>
	 * </ul>
	 *
	 */
	public class Colors {
		/**
		 * Constructor, throws an error if called, as this is an abstract class.
		 */
		public function Colors() {
			throw new Error("This is an abstract class.");
		}
		
		
		//----------------------------------
		// color construction functions
		//
		// These functions create colors from parameters
		//----------------------------------
		
		/**
		 * Returns a grayscale color value with the given brightness
		 * @param v the brightness component (0-255)
		 * @param a the alpha component (0-255, 255 by default)
		 * @return the color value
		 */
		public static function gray(v:uint, a:uint = 255):uint {
			return ((a & 0xFF) << 24) | ((v & 0xFF) << 16) |
				((v & 0xFF) << 8) | (v & 0xFF);
		}
		
		
		/**
		 * Returns a color value with the given red, green, blue, and alpha
		 * components
		 * @param r the red component (0-255)
		 * @param g the green component (0-255)
		 * @param b the blue component (0-255)
		 * @param a the alpha component (0-255, 255 by default)
		 * @return the color value
		 *
		 */
		public static function rgba(r:uint, g:uint, b:uint, a:uint = 255):uint {
			return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) |
				((g & 0xFF) << 8) | (b & 0xFF);
		}
		
		
		/**
		 * Returns a color value by updating the alpha component of another
		 * color value.
		 * @param c a color value
		 * @param a the desired alpha component (0-255)
		 * @return a color value with adjusted alpha component
		 */
		public static function setAlpha(c:uint, a:uint):uint {
			return ((a & 0xFF) << 24) | (c & 0x00FFFFFF);
		}
		
		
		/**
		 * Returns the RGB color value for a color specified in HSV (hue,
		 * saturation, value) color space.
		 * @param h the hue, a value between 0 and 1
		 * @param s the saturation, a value between 0 and 1
		 * @param v the value (brighntess), a value between 0 and 1
		 * @param a the (optional) alpha value, an integer between 0 and 255
		 *  (255 is the default)
		 * @return the corresponding RGB color value
		 */
		public static function hsv(h:Number, s:Number, v:Number, a:uint = 255):uint {
			h = h % 1;
			s = Maths.clampValue(s, 0, 1);
			v = Maths.clampValue(v, 0, 1);
			var r:uint = 0, g:uint = 0, b:uint = 0;
			if (s == 0) {
				r = g = b = uint(v * 255 + .5);
			} else {
				const i:Number = (h - Math.floor(h)) * 6.0;
				const f:Number = i - Math.floor(i);
				const p:Number = v * (1 - s);
				const q:Number = v * (1 - s * f);
				const t:Number = v * (1 - (s * (1 - f)));
				switch (int(i)) {
					case 0:
						r = uint(v * 255 + .5);
						g = uint(t * 255 + .5);
						b = uint(p * 255 + .5);
						break;
					case 1:
						r = uint(q * 255 + .5);
						g = uint(v * 255 + .5);
						b = uint(p * 255 + .5);
						break;
					case 2:
						r = uint(p * 255 + .5);
						g = uint(v * 255 + .5);
						b = uint(t * 255 + .5);
						break;
					case 3:
						r = uint(p * 255 + .5);
						g = uint(q * 255 + .5);
						b = uint(v * 255 + .5);
						break;
					case 4:
						r = uint(t * 255 + .5);
						g = uint(p * 255 + .5);
						b = uint(v * 255 + .5);
						break;
					case 5:
						r = uint(v * 255 + .5);
						g = uint(p * 255 + .5);
						b = uint(q * 255 + .5);
						break;
				}
			}
			return rgba(r, g, b, a);
		}
		
		
		/**
		 * Returns the RGB color value for a color adjusted by factors
		 * in HSV (hue, saturation, value) color space.
		 *
		 * @param color the color to adjust
		 * @param h the hue, a value between -1.0 and 1.0
		 * @param s the saturation, a value between -1.0 and 1.0
		 *          -1.0 fully desaturates, 1.0 fully saturates the color
		 * @param v the value (brightness), a value between -1.0 and 1.0
		 * @param a the (optional) alpha value, an integer between 0 and 255
		 *  (255 is the default)
		 * @return the corresponding RGB color value
		 */
		public static function adjustHsv(color:uint, h:Number = 0, s:Number = 0, v:Number = 0, a:uint = 255):uint {
			var ch:Number = Maths.clampValue((hue(color) + h) % 1, 0, 1);  // the hue goes round and round
			var cs:Number = Maths.clampValue(saturation(color) + s, 0, 1);
			var cv:Number = Maths.clampValue(value(color) + v, 0, 1);
			return hsv(ch, cs, cv, a);
		}
		
		/**
		 * Adjusts the hue of the input color.
		 *
		 * @param color the base color
		 * @param h desired change in hue -1.0-1.0
		 * @param a desired alpha 0-255
		 * @return the base color with hue adjusted
		 */
		public static function adjustHue(color:uint, h:Number = 0, a:uint = 255):uint {
			return adjustHsv(color, h, 0, 0, a);
		}
		
		
		/**
		 * Adjusts the saturation of the input color.
		 *
		 * @param color the base color
		 * @param s desired change in saturation -1.0-1.0
		 * @param a desired alpha 0-255
		 * @return the base color with saturation adjusted
		 */
		public static function adjustSaturation(color:uint, s:Number = 0, a:uint = 255):uint {
			return adjustHsv(color, 0, s, 0, a);
		}
		
		
		/**
		 * Adjust the value of the input color
		 *
		 * @param color the base color
		 * @param v the desired change in value 0.0-1.0
		 * @param a desired alpha 0-255
		 * @return the base color with value adjusted
		 */
		public static function adjustValue(color:uint, v:Number = 0, a:uint = 255):uint {
			return adjustHsv(color, 0, 0, v, a);
		}
		
		/**
		 * Adjusts the brightness of the input color. This is a synonym for
		 * <code>adjustValue</code>.
		 *
		 * @param color the base color
		 * @param v the desired change in value -1.0-1.0
		 * @param a desired alpha 0-255
		 * @return the base color with value adjusted
		 */
		public var adjustBrightness:Function = adjustValue;
		
		
		/**
		 * Returns the RGB color value for a color using specified
		 * values in HSV (hue, saturation, value) color space.
		 *
		 * @param color the color to adjust
		 * @param h the hue, a value between 0.0 and 1.0. This will override
		 *          the hue for the color
		 * @param s the saturation, a value between 0.0 and 1.0. This will override
		 *          the saturation for the color. 1.0 if fully saturated.
		 * @param v the value (brightness), a value between 0.0 and 1.0. This will
		 *          override the value for the color
		 * @param a the (optional) alpha value, an integer between 0 and 255
		 *  (255 is the default)
		 * @return the corresponding RGB color value
		 */
		public static function setHsv(color:uint, h:Number = NaN, s:Number = NaN, v:Number = NaN, a:uint = 255):uint {
			const ch:Number = isNaN(h) ? hue(color) : h % 1;
			const cs:Number = isNaN(s) ? saturation(color) : Maths.clampValue(s, 0, 1);
			const cv:Number = isNaN(v) ? value(color) : Maths.clampValue(v, 0, 1);
			return hsv(ch, cs, cv, a);
		}
		
		
		public static function setHue(color:uint, h:Number = 0, a:uint = 255):uint {
			return setHsv(color, h, NaN, NaN, a);
		}
		
		
		public static function setSaturation(color:uint, s:Number = 0, a:uint = 255):uint {
			return setHsv(color, NaN, s, NaN, a);
		}
		
		
		public static function setValue(color:uint, v:Number = 0, a:uint = 255):uint {
			return setHsv(color, NaN, NaN, v, a);
		}
		
		/**
		 * setBrightness is a synonym for set_value.
		 */
		public var setBrightness:Function = setValue;
		
		
		//----------------------------------
		// color properties
		//
		// These functions return properties of colors
		//----------------------------------
		
		/**
		 * Returns the alpha component of a color value
		 * @param c the color value
		 * @return the alpha component
		 */
		public static function a(c:uint):uint {
			return (c >> 24) & 0xFF;
		}
		
		
		/**
		 * Returns the red component of a color value
		 * @param c the color value
		 * @return the red component
		 */
		public static function r(c:uint):uint {
			return (c >> 16) & 0xFF;
		}
		
		
		/**
		 * Returns the green component of a color value
		 * @param c the color value
		 * @return the green component
		 */
		public static function g(c:uint):uint {
			return (c >> 8) & 0xFF;
		}
		
		
		/**
		 * Returns the blue component of a color value
		 * @param c the color value
		 * @return the blue component
		 */
		public static function b(c:uint):uint {
			return (c & 0xFF);
		}
		
		
		/**
		 * Returns the hue component of an ARGB color.
		 * @param c the input color
		 * @return the hue component of the color is HSV color space as a
		 *  number between 0 and 1
		 */
		public static function hue(c:uint):Number {
			var h:Number;
			const r:uint = (c >> 16) & 0xFF;
			const g:uint = (c >> 8) & 0xFF;
			const b:uint = (c & 0xFF);
			const cmax:uint = Math.max(r, g, b) as uint;
			const cmin:uint = Math.min(r, g, b) as uint;
			const range:Number = (cmax - cmin) as Number;
			
			if (range == 0)
				h = 0;
			else {
				const rc:Number = Number(cmax - r) / range;
				const gc:Number = Number(cmax - g) / range;
				const bc:Number = Number(cmax - b) / range;
				if (r == cmax)
					h = bc - gc;
				else if (g == cmax)
					h = 2.0 + rc - bc;
				else
					h = 4.0 + gc - rc;
			}
			h = (h / 6.0) % 1.0
			if (h < 0) h += 1.0;
			return h;
		}
		
		/**
		 * h is a synonym for hue
		 */
		public var h:Function = hue;
		
		
		/**
		 * Returns the saturation component of an ARGB color.
		 * @param c the input color
		 * @return the saturation of the color is HSV color space as a
		 *  number between 0 and 1
		 */
		public static function saturation(c:uint):Number {
			var r:uint, g:uint, b:uint, cmax:uint, cmin:uint;
			r = (c >> 16) & 0xFF;
			g = (c >> 8) & 0xFF;
			b = (c & 0xFF);
			cmax = (r > g) ? r : g;
			if (b > cmax)
				cmax = b;
			if (cmax == 0)
				return 0;
			cmin = (r < g) ? r : g;
			if (b < cmin)
				cmin = b;
			return Number(cmax - cmin) / cmax;
		}
		
		/**
		 * s is a synonym for saturation
		 */
		public var s:Function = saturation;
		
		
		/**
		 * Returns the value (brightness) component of an ARGB color.
		 * @param c the input color
		 * @return the value component of the color is HSV color space as a
		 *  number between 0 and 1
		 */
		public static function value(c:uint):Number {
			var r:uint, g:uint, b:uint, cmax:uint;
			r = (c >> 16) & 0xFF;
			g = (c >> 8) & 0xFF;
			b = (c & 0xFF);
			cmax = (r > g) ? r : g;
			if (b > cmax)
				cmax = b;
			return cmax / 255.0;
		}
		
		/***
		 * Brightness and v are synonyms for value
		 */
		public var brightness:Function = value;
		public var v:Function = value;
		
		
		/**
		 * Returns luminosity difference from white.
		 */
		public static function luminance(c:uint):Number {
			const white:uint = 0xffffff;
			return luminosityDifference(c, white);
		}
		
		public var luminanceFromWhite:Function = luminance;
		
		
		/**
		 * Returns luminosity difference from black.
		 */
		public static function luminanceFromBlack(c:uint):Number {
			const black:uint = 0x000000;
			return luminosityDifference(c, black);
		}
		
		
		/**
		 * Is the color grey
		 * @param c a color value
		 * @return a boolean indicating if the color is grey
		 */
		public static function isGrey(c:uint):Boolean {
			const cr:uint = r(c);
			const cg:uint = g(c);
			const cb:uint = b(c);
			return (cr == cg && cg == cb);
		}
		
		public var isGray:Function = isGrey
		
		
		/**
		 * Is the color "black"
		 * @param c a color value
		 * @return a boolean indicating if the color is black
		 *         black is defined fuzzily
		 */
		public static function isBlack(c:uint):Boolean {
			const cr:uint = r(c);
			const cg:uint = g(c);
			const cb:uint = b(c);
			return (cr <= 20 && cg <= 20 && cb <= 20);
		}
		
		
		/**
		 * Is the color white
		 * @param c a color value
		 * @return a boolean indicating if the color is white
		 */
		public static function isWhite(c:uint):Boolean {
			const cr:uint = r(c);
			const cg:uint = g(c);
			const cb:uint = b(c);
			return cr == 255 && cg == 255 && cb == 255;
		}
		
		
		/**
		 * Is the color transparent
		 * @param c a color value
		 * @return a boolean indicating if the color is white
		 */
		public static function isTransparent(c:uint):Boolean {
			return a(c) == 255;
		}
		
		//----------------------------------
		// color manipulation functions
		//
		// These functions manipulate an input color.
		//----------------------------------
		
		/*******************************************************************
		 *
		 * COLOR MANIPULATION FUNCTIONS
		 *
		 ********************************************************************/
		
		
		/**
		 * (NodeBox) Get a darker shade of an input color.
		 * @param c a color value
		 * @param step an optional step value, default=0.1
		 * @return a darkened color value
		 */
		public static function darken(c:uint, step:Number = 0.1):uint {
			return hsv(hue(c), saturation(c), value(c) - step, a(c));
		}
		
		public var darker:Function = darken;
		
		
		/**
		 * (NodeBox) Get a lighter shade of an input color.
		 * @param c a color value
		 * @param step an optional step value, default=0.1
		 * @return a lightened color value
		 */
		public static function lighten(c:uint, step:Number = 0.1):uint {
			return darken(c, -step);
		}
		
		public var lighter:Function = lighten;
		
		
		/**
		 * (NodeBox) Get a less saturated shade of an input color
		 * @param c a color value
		 * @param step an optional step value, default=0.1
		 * @return a darkened color value
		 */
		public static function desaturate(c:uint, step:Number = 0.1):uint {
			return hsv(hue(c), saturation(c) - step, value(c), a(c));
		}
		
		
		/**
		 * (NodeBox) Get a more saturated shade of an input color
		 * @param c a color value
		 * @param step an optional step value, default=0.1
		 * @return a darkened color value
		 */
		public static function saturate(c:uint, step:Number = 0.1):uint {
			return desaturate(c, -step);
		}
		
		
		/**
		 * (NodeBox) Adjust the contrast of an input color
		 * @param c a color value
		 * @param step an optional step value, default=0.1
		 * @return a darkened color value
		 */
		public static function adjustContrast(c:uint, step:Number = 0.1):uint {
			if (value(c) <= 0.5) {
				return darken(c, step);
			} else {
				return lighten(c, step);
			}
		}
		
		
		/**
		 * (Flare) Get a darker shade of an input color.
		 * @param c a color value
		 * @return a darkened color value
		 */
		public static function darker2(c:uint, s:Number = 1):uint {
			s = Math.pow(0.7, s);
			return rgba(Math.max(0, int(s * r(c))),
				Math.max(0, int(s * g(c))),
				Math.max(0, int(s * b(c))),
				a(c));
		}
		
		
		/**
		 * Get a brighter shade of an input color.
		 * @param c a color value
		 * @return a brighter color value
		 */
		public static function brighter2(c:uint, s:Number = 1):uint {
			var cr:uint, cg:uint, cb:uint, i:uint;
			s = Math.pow(0.7, s);
			
			cr = r(c),cg = g(c),cb = b(c);
			i = 30;
			if (cr == 0 && cg == 0 && cb == 0) {
				return rgba(i, i, i, a(c));
			}
			if (cr > 0 && cr < i)
				cr = i;
			if (cg > 0 && cg < i)
				cg = i;
			if (cb > 0 && cb < i)
				cb = i;
			
			return rgba(Math.min(255, (int)(cr / s)),
				Math.min(255, (int)(cg / s)),
				Math.min(255, (int)(cb / s)),
				a(c));
		}
		
		
		/**
		 * Get a completely desaturated shade of an input color.
		 * @param c a color value
		 * @return a desaturated color value
		 */
		public static function desaturate2(c:uint):uint {
			var a:uint = c & 0xff000000;
			var cr:Number = Number(r(c));
			var cg:Number = Number(g(c));
			var cb:Number = Number(b(c));
			
			cr *= 0.2125; // red band weight
			cg *= 0.7154; // green band weight
			cb *= 0.0721; // blue band weight
			
			var gray:uint = uint(Math.min(int(cr + cg + cb), 0xff)) & 0xff;
			return a | (gray << 16) | (gray << 8) | gray;
		}
		
		
		/**
		 * Return a complementary color using the artistic colorwheel
		 */
		public static function complement(c:uint):uint {
			return rotateColorwheel(c, 0.5);
		}
		
		
		/**
		 * Return colors that are similar to c
		 *
		 * @param c an initial color
		 * @param angle amount of random hue variation, 0=no variation, 0.5=maximum variation
		 *   default is 0.0555
		 * @param d amount of saturation and value variation
		 *   default is 0.5
		 */
		public static function analog(c:uint, angle:Number = 0.0555, d:Number = 0.5):uint {
			angle = angle % 1;
			d = Maths.clampValue(d, 0, 1);
			// get a random number between [-angle, angle]
			const randAngle:Number = Math.random() * angle * 2 - angle;
			// get a random number between [-d, d]
			const randSat:Number = Math.random() * d * 2 - d;
			const randVal:Number = Math.random() * d * 2 - d;
			return adjustHsv(rotateColorwheel(c, randAngle), 0, randSat, randVal);
		}
		
		
		/*******************************************************************
		 *
		 * COLOR UTILITY FUNCTIONS
		 *
		 ********************************************************************/
		
		/**
		 * Returns a color with the hue rotated on the artistic RYB
		 * color wheel.
		 *
		 * <p>An artistic color wheel has slightly different opposites
		 * (e.g. purple-yellow instead of purple-lime).
		 * It is mathematically incorrect but generally assumed
		 * to provide better complementary colors.</p>
		 *
		 * <p>See http://en.wikipedia.org/wiki/RYB_color_model</p>
		 *
		 * <p>Implementation and selected comments from NodeBox colors module</p>
		 *
		 * @param c the color to rotate
		 * @param angle a value between 0 and 1 indicating the angle
		 * to rotate the color, 0.5 returns the complementary color
		 * @returns the rotated color
		 */
		public static function rotateColorwheel(c:uint, angle:Number = 0.5):uint {
			// the wheel supports mapping from actual hue ranges
			// to desired wheel ranges
			const wheel:Array = [
				// actual      desired
				// min  max    min    max
				[0.000, 0.022, 0.000, 0.042],
				[0.022, 0.047, 0.042, 0.083],
				[0.047, 0.072, 0.083, 0.125],
				[0.072, 0.094, 0.125, 0.167],
				[0.094, 0.114, 0.167, 0.208],
				[0.114, 0.133, 0.208, 0.250],
				[0.133, 0.150, 0.250, 0.292],
				[0.150, 0.167, 0.292, 0.333],
				[0.167, 0.225, 0.333, 0.375],
				[0.225, 0.286, 0.375, 0.417],
				[0.286, 0.342, 0.417, 0.458],
				[0.342, 0.383, 0.458, 0.500],
				[0.383, 0.431, 0.500, 0.542],
				[0.431, 0.475, 0.542, 0.583],
				[0.475, 0.519, 0.583, 0.625],
				[0.519, 0.567, 0.625, 0.667],
				[0.567, 0.608, 0.667, 0.708],
				[0.608, 0.650, 0.708, 0.750],
				[0.650, 0.697, 0.750, 0.792],
				[0.697, 0.742, 0.792, 0.833],
				[0.742, 0.783, 0.833, 0.875],
				[0.783, 0.828, 0.875, 0.917],
				[0.828, 0.914, 0.917, 0.958],
				[0.914, 1.000, 0.958, 1.000]
			];
			var h:Number = hue(c);
			var tuple:Array;
			var amin:Number, amax:Number, dmin:Number, dmax:Number;
			var new_h:Number;
			
			// Given a hue, find out under what angle it is
			// located on the artistic color wheel.
			for each (tuple in wheel) {
				// unpack the tuple
				amin = tuple[0];
				amax = tuple[1];
				dmin = tuple[2];
				dmax = tuple[3];
				if (amin <= h && h <= amax) {
					// interpolate
					new_h = dmin + (dmax - dmin) * (h - amin) / (amax - amin);
					break;
				}
			}
			
			new_h += angle;
			h = new_h % 1
			
			// Given the new hue, convert back to the actual hue
			for each (tuple in wheel) {
				// unpack the tuple
				// note that actuals (amin,amax) and desireds (dmin,dmax)
				// are reversed from the previous time through this loop
				dmin = tuple[0];
				dmax = tuple[1];
				amin = tuple[2];
				amax = tuple[3];
				if (amin <= h && h <= amax) {
					// interpolate
					new_h = dmin + (dmax - dmin) * (h - amin) / (amax - amin);
					break;
				}
			}
			
			// make sure we're in the [0, 1] range
			new_h = new_h % 1;
			return hsv(new_h, saturation(c), value(c), a(c));
		}
		
		
		/**
		 * Interpolate between two color values by the given mixing proportion.
		 * A mixing fraction of 0 will result in c1, a value of 1.0 will result
		 * in c2, and value of 0.5 will result in the color mid-way between the
		 * two in RGB color space.
		 * @param c1 the starting color
		 * @param c2 the target color
		 * @param f a fraction between 0 and 1 controlling the interpolation
		 * @return the interpolated color
		 */
		public static function interpolate(c1:uint, c2:uint, f:Number):uint {
			var t:uint;
			return rgba(
				(1 - f) * r(c1) + f * r(c2),
				(1 - f) * g(c1) + f * g(c2),
				(1 - f) * b(c1) + f * b(c2),
				(1 - f) * a(c1) + f * a(c2)
			);
		}
		
		
		/**
		 * Interpolate between two color values by the given mixing proportion.
		 * A mixing fraction of 0 will result in c1, a value of 1.0 will result
		 * in c2, and value of 0.5 will result in the color mid-way between the
		 * two in HSV color space.
		 * 
		 * @param c1 the starting color
		 * @param c2 the target color
		 * @param f a fraction between 0 and 1 controlling the interpolation
		 * @return the interpolated color
		 */
		public static function interpolateHsv(c1:uint, c2:uint, f:Number):uint {
			return hsv(
				(1 - f) * hue(c1) + f * hue(c2),
				(1 - f) * saturation(c1) + f * saturation(c2),
				(1 - f) * value(c1) + f * value(c2),
				(1 - f) * a(c1) + f * a(c2)
			);
		}
		
		
		/**
		 * Calculate the luminosity difference between two colors
		 *
		 * <p>Luminosity values of greater than 3.0 are recommended for large
		 * text and values of greater than 4.5 are recommended for small text.</p>
		 *
		 * <p>For more discussion see:
		 * http://juicystudio.com/article/luminositycontrastratioalgorithm.php
		 * http://www.d.umn.edu/itss/support/Training/Online/webdesign/color.html#contrast</p>
		 *
		 * @param c1 the first color
		 * @param c2 the second color
		 * @result the luminosity difference between c1, c2 (a number
		 * between 0.0 and 21.0)
		 *
		 */
		public static function luminosityDifference(c1:uint, c2:uint):Number {
			const r1:Number = r(c1);
			const g1:Number = g(c1);
			const b1:Number = b(c1);
			const r2:Number = r(c2);
			const g2:Number = g(c2);
			const b2:Number = b(c2);
			const l1:Number = 0.2126 * Math.pow(r1 / 255, 2.2) + 0.7152 * Math.pow(g1 / 255, 2.2) + 0.0722 * Math.pow(b1 / 255, 2.2);
			const l2:Number = 0.2126 * Math.pow(r2 / 255, 2.2) + 0.7152 * Math.pow(g2 / 255, 2.2) + 0.0722 * Math.pow(b2 / 255, 2.2);
			if (l1 > l2)
				return (l1 + 0.05) / (l2 + 0.05);
			else
				return (l2 + 0.05) / (l1 + 0.05);
		}
		
		
		/**
		 * Determine the color difference between colors.
		 *
		 * Color differences greater than 500 are recommended.
		 * However, this algorithm is considered inferior to
		 * luminosityDifference.
		 */
		public static function colorDifference(c1:uint, c2:uint):Number {
			const r1:Number = r(c1);
			const g1:Number = g(c1);
			const b1:Number = b(c1);
			const r2:Number = r(c2);
			const g2:Number = g(c2);
			const b2:Number = b(c2);
			return Math.max(r1, r2) - Math.min(r1, r2) +
				Math.max(g1, g2) - Math.min(g1, g2) +
				Math.max(b1, b2) - Math.min(b1, b2);
		}
		
		
		/**
		 * Determine the brightness difference between colors.
		 *
		 * Brightness differences greater than 125 are recommended.
		 * However, this algorithm is considered inferior to
		 * luminosityDifference.
		 */
		public static function brightnessDifference(c1:uint, c2:uint):Number {
			const r1:Number = r(c1);
			const g1:Number = g(c1);
			const b1:Number = b(c1);
			const r2:Number = r(c2);
			const g2:Number = g(c2);
			const b2:Number = b(c2);
			const br1:Number = (299 * r1 + 587 * g1 + 114 * b1) / 1000.0;
			const br2:Number = (299 * r2 + 587 * g2 + 114 * b2) / 1000.0;
			return Math.abs(br1 - br2);
		}
		
		
		/**
		 * Determines if white or black would be a better color for text labels
		 * given a background color.
		 *
		 * @param c the proposed background color
		 * @result a uint that is either white or black based on whichever
		 * has higher luminosity contrast to c
		 */
		public static function whiteOrBlack(c:uint):uint {
			const white:uint = 0xffffff;
			const black:uint = 0x000000;
			const whiteDiff:Number = luminosityDifference(c, white);
			const blackDiff:Number = luminosityDifference(c, black);
			return (whiteDiff > (blackDiff - 1)) ? white : black;
		}
		
		
		/**
		 * Get background color from a Flex object
		 */
		public static function getBackgroundColor(obj:*):uint {
			try {
				return obj.getStyle('backgroundColor') as uint;
			} catch (errorObj:Error) {
			}
			return NaN;
		}
		
		
		/**
		 * Convert a color to a hexadecimal representation.
		 */
		public static function toRRGGBB(c:uint):String {
			return Strings.format('{0:x6}', c);
		}
		
		
		/**
		 * A color transform matrix that desaturates colors to corresponding
		 * grayscale values. Can be used with the
		 * <code>flash.filters.ColorMatrixFilter</code> class.
		 */
		public static function get desaturationMatrix():Array {
			return [0.2125, 0.7154, 0.0721, 0, 0,
				0.2125, 0.7154, 0.0721, 0, 0,
				0.2125, 0.7154, 0.0721, 0, 0,
				0, 0, 0, 1, 0];
		}
		
	} // end of class Colors
}
