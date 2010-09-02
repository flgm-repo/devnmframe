// FishEye, by Genaro Phu Pinson, geniephupinson@yahoo.com
// Copyright 2009 Genaro Phu Pinson

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

package com.pag.fisheye
{	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import gs.TweenMax;
	import gs.easing.Elastic;
	import gs.easing.Expo;
	
	import mx.containers.HBox;
	import mx.core.UIComponent;
	import mx.effects.Zoom;
	import mx.effects.easing.Exponential;
			
	public class FishEye extends HBox
	{
		/**
		* The defined properties for this class
		**/
		[Inspectable]
		public var rolloverScale:Number = 3;
		[Inspectable]
		public var itemHeight:Number = 25;
		[Inspectable]
		public var itemWidth:Number = 25;	
		[Inspectable]
		public var effectShowDuration:Number = 0.1;
		[Inspectable]
		public var effectShowEasingFunction:Function = Exponential.easeOut;	
		[Inspectable]
		public var effectHideDuration:Number = 250;
		[Inspectable]
		public var effectHideEasingFunction:Function = Elastic.easeOut;			
		//public var effectHideEasingFunction:Function = 	Exponential.easeOut;			
		[Inspectable]
		public var itemsToBeScaledOnMouseMove:int = 5;			
		
		private var selectedChildIndex:int;
				
		//attributes needed to implement the logic for turning on/off the fish eye effect when it is totally necessary
		public var fishEyeEffectSwitch:Number = 1;
		public var fishEyeEffectSwitchChanged:Boolean = false ;
		public static const OFF_FISHEYE_EFFECT:Number = 0;
		public static const ON_FISHEYE_EFFECT:Number = 1;

		//----------------------------------------------------------------------
		//
		//  Constructor
		//
		//----------------------------------------------------------------------
		public function FishEye()
		{
			super();
			//direction="horizontal"; this sets the actuall fish eye listeners
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.ROLL_OUT,restoreIconSize);				
		}
		
		//----------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//----------------------------------------------------------------------			
		override protected function createChildren():void
		{
			super.createChildren();
						
			for each (var child:UIComponent in this.getChildren()) 
			{	
				child.width = this.itemWidth;
				child.height = this.itemHeight;
				//this enables the children to be clickable
				child.mouseChildren = true;
				child.useHandCursor = true;
				child.buttonMode = true;
			}
		}
		
		//----------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Handler methods
		//
		//----------------------------------------------------------------------			
		/**
		 * Restore child component sizes to its original size.
		*/
		private function restoreIconSize (event:MouseEvent):void 
		{
			proceedRestoreIconsSize();		
		}
		
		/**
		 * @private
		 * On each mouse move, evaluate the mouse cursor position to find the nearest child and
		 * enlarges the nearest child and its neighboring child items based on scaleUpIcons logic. 
		 */
		private function onMouseMove(event:MouseEvent):void
		{		
			if ( fishEyeEffectSwitch == ON_FISHEYE_EFFECT )
			{				
				proceedResizingIcons(getclosestChildFromPointer(event.stageX, event.stageY));
			}
		}
		
		/**
		 * @private
		 * On each mouse move, evaluate the mouse cursor position to find the nearest child and
		 * enlarges the nearest child and its neighboring child items based on scaleUpIcons logic. 
		 */
		private function onChildMouseOver(event:MouseEvent):void
		{		
			trace('GeeniiFishEye:: onMouseMoveClosest:: UIComponent(getclosestChildFromPointer(event.stageX, event.stageY)).id::' + UIComponent(getclosestChildFromPointer(event.stageX, event.stageY)).id);
			proceedResizingIcons(event.target as UIComponent);
		}
		
		/**
		 * @private
		 * On each mouse move, evaluate the mouse cursor position to find the nearest child and
		 * enlarges the nearest child and its neighboring child items based on scaleUpIcons logic. 
		 */
		private function onChildMouseOut(event:MouseEvent):void
		{		
			trace('GeeniiFishEye:: onMouseMoveClosest:: UIComponent(getclosestChildFromPointer(event.stageX, event.stageY)).id::' + UIComponent(getclosestChildFromPointer(event.stageX, event.stageY)).id);
			proceedResizingIcons(event.target as UIComponent);
		}
		
		
		//----------------------------------------------------------------------
		//
		//  Helper methods
		//
		//----------------------------------------------------------------------
		/**
		* Resizes the selected item/child under the mouse pointer including the 2 items/childs before and
		* after it. 
		*/
		private function proceedResizingIcons(closestChildFromPointer:UIComponent):void
		{
			//ensures the previously selected icon returns back to their original size
			proceedRestoreIconsSize();

			var item:UIComponent = closestChildFromPointer;
		 	var index:int = this.getChildIndex(item);
		 	selectedChildIndex = index;
		 	
		 	//public function GlowFilter(
		 	//color:uint = 0xFF0000  =>  (default = 0xFF0000) — The color of the glow, in the hexadecimal format 0xRRGGBB. The default value is 0xFF0000. 
		 	//alpha:Number = 1.0, => (default = 1.0) —The alpha transparency value for the color. Valid values are 0 to 1. For example, .25 sets a transparency value of 25%. 
		 	//blurX:Number = 6.0,  => (default = 6.0) — The amount of horizontal blur. Valid values are 0 to 255 (floating point). Values that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized to render more quickly than other values.
		 	//blurY:Number = 6.0,  (default = 6.0) — The amount of vertical blur. Valid values are 0 to 255 (floating point). Values that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized to render more quickly than other values. 
		 	//strength:Number = 2,  (default = 2) — The strength of the imprint or spread. The higher the value, the more color is imprinted and the stronger the contrast between the glow and the background. Valid values are 0 to 255. 
		 	//quality:int = 1, (default = 1) — The number of times to apply the filter. Use the BitmapFilterQuality constants: 
		 	//inner:Boolean = false, (default = false) — Specifies whether the glow is an inner glow. The value true specifies an inner glow. The value false specifies an outer glow (a glow around the outer edges of the object). 
		 	//knockout:Boolean = false) (default = false) — Specifies whether the object has a knockout effect. The value true makes the object's fill transparent and reveals the background color of the document.
		 	item.filters = [new GlowFilter(0x000000, 0.5, 6, 6, 2, 1, false, false)];
		 	
		 	scaleUpIcons (item,0);
		 			 	
 		 	for (var i:int = 1; i < 5; i ++) 
		 	{
		 		if (i + index < this.numChildren) 
		 		{
		 			scaleUpIcons (this.getChildAt(index+i) as UIComponent, i);
		 		}
		 		
 		 		if (index - i >= 0)
		 		{ 
		 			scaleUpIcons (this.getChildAt(index-i) as UIComponent, i);
		 		} 
		 	} 			
		}
		
		private function proceedRestoreIconsSize():void
		{	
			var item:DisplayObject = this.getChildAt(selectedChildIndex) as DisplayObject;
		 	
		 	var index:int = selectedChildIndex;
		 	selectedChildIndex = 0;
		 	
		 	item.filters = null;
		 	
		 	scaleDownIcons (item,0);
		 			 	
 		 	for (var i:int = 1; i < 5; i ++) 
		 	{
		 		if (i + index < this.numChildren) 
		 		{
		 			scaleDownIcons (this.getChildAt(index+i) as UIComponent, i);
		 		}
		 		
 		 		if (index - i >= 0)
		 		{ 
		 			scaleDownIcons (this.getChildAt(index-i) as UIComponent, i);
		 		} 
		 	} 	 
		}
		
		/**
		 * Increases the size if a given child component
		*/
		private function scaleUpIcons (target:UIComponent, index:int):void 
		{
			var mm:Zoom;
			var buffer:Number = this.rolloverScale - 1;
			var scale:Number = 1 + buffer * (itemsToBeScaledOnMouseMove - index) / 2;
						
			TweenMax.to(target, 1, {scaleX:scale, scaleY:scale, ease: Expo.easeOut });		
		}	
		
		/**
		 * Returns the size if a given child component to its original size.
		*/		
		private function scaleDownIcons (target:DisplayObject, index:int):void 
		{
			var mm:Zoom;
			var buffer:Number = this.rolloverScale - 1 ;
			var scale:Number = 1 - buffer / (itemsToBeScaledOnMouseMove + index)* 1/2;
			
			trace ("index = " + index + " scale = " + scale);
		
			TweenMax.to(target, 1, {scaleX:scale, scaleY:scale, ease: Expo.easeOut });			
		}	
		
		/**
		 * Gets the child component nearest to the mouse pointer.
		*/			
		private function getclosestChildFromPointer(xPosition:int, yPosition:int):UIComponent
		{
			var closestDistance:Number;
			var closestChild:UIComponent;
			
			// Loop through children and find the child closest to the mouse cursor.
			for each (var child:UIComponent in getChildren())
			{
				var distance:Number = getDistanceFromRect( xPosition, yPosition, child.getBounds(stage));
 
				if (isNaN(closestDistance) || distance < closestDistance)
				{
					closestDistance = distance;
					closestChild = child;
				}
			}
			return closestChild;
		}
 
		/**
		 * @private
		 * Gets the distance between a point from a rectangle.  This doesn't evaluate the distance of
		 * the point from the center of the rectangle, but instead the distance of the point
		 * from the closest edge of the rectangle.
		 * 
		 * @param x The X coordinate of the point to be evaluated.
		 * @param y The Y coordinate of the point to be evaluated.
		 * @param rect The rectangle from which the distance will be measured to the point.
		 * 
		 * @return The distance in pixels between the point and the rectangle or the container.
		 */
		private function getDistanceFromRect(x:Number, y:Number, rect:Rectangle):Number
		{
			// If the rectange contains the point we are evaluating, then there is
			// no distance between the point and the rectangle.
			if (rect.contains(x, y))
			{
				return 0;
			}
			else
			{
				// Retrieve distances to the closest edge.
				var xDist:Number = 0;
				var yDist:Number = 0;
 
				if (x < rect.left)
				{
					xDist = rect.left - x;
				}
				else if (x > rect.right)
				{
					xDist = x - rect.right;
				}
 
				if (y < rect.top)
				{
					yDist = rect.top - y;
				}
				else if (y > rect.bottom)
				{
					yDist = y - rect.bottom;
				}
				// Return the distance between the point and the nearest  edge using the Pythagorean theorem.
				return Math.sqrt(Math.pow(xDist, 2) + Math.pow(yDist, 2));
			}
		}	
	
	}
}