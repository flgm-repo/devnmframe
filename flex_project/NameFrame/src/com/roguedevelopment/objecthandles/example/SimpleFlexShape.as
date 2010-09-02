package com.roguedevelopment.objecthandles.example
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.BitmapAsset;
	import mx.events.PropertyChangeEvent;


	/**
	 * This is an example and not part of the core ObjectHandles library.
	 **/

	public class SimpleFlexShape extends Canvas
	{
		public var backgroundImage:Image;
		public var largeFilenameID:String = "";
		public var isMaskStretchable:Boolean = false;
		public var backgroundImageName:String = "" 
		private var _backgroundImageSource:String = "";
		public var _hasBackgroundImage:Boolean = false;
		
		private var bgHeight:Number;
		private var bgWidth:Number;
        
		protected var _model:SimpleDataModel;

		public function SimpleFlexShape()
		{
			super();

			this.verticalScrollPolicy = 'off';
			this.horizontalScrollPolicy = 'off';
			backgroundImage = new Image();
			backgroundImage.addEventListener(Event.COMPLETE, handleImageComplete);
			backgroundImage.maintainAspectRatio = false;
			addChild(backgroundImage);
		}

		public function set model(model:SimpleDataModel):void
		{
			if (_model)
			{
				_model.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onModelChange);
			}
			_model = model;
			redraw();
			x = model.x;
			y = model.y;
			model.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onModelChange);
		}

		public function get model():SimpleDataModel
		{
			return _model;
		}

		public function get backgroundImageSource():String
		{
			return _backgroundImageSource;
		}

		private function handleImageComplete(event:Event):void
		{
			var bitmap:Bitmap = ((event.target as Image).content as Bitmap);
			if (bitmap != null)
			{
				bitmap.smoothing = true;
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			bgHeight = unscaledHeight;
			bgWidth = unscaledWidth;
			redraw();
		}

		protected function onModelChange(event:PropertyChangeEvent):void
		{
			switch (event.property)
			{
				case "x":
					x = event.newValue as Number;
					break;
				case "y":
					y = event.newValue as Number;
					break;
				case "rotation":
					rotation = event.newValue as Number;
					break;
				case "width":
					width = event.newValue as Number;
					break;
				case "height":
					height = event.newValue as Number;
					break;
				default:
					return;
			}
			redraw();
		}

		public function loadAsBackground(imageSource:String):void
		{
			_hasBackgroundImage = true;
			_backgroundImageSource = imageSource;
			invalidateDisplayList();
		}

		protected function redraw():void
		{
			if (!_model)
			{
				return;
			}

			if (_hasBackgroundImage == true)
			{
				backgroundImage.source = _backgroundImageSource;
				backgroundImage.width = _model.width;
				backgroundImage.height = _model.height;
				backgroundImage.validateProperties();
				backgroundImage.invalidateSize();
			}
			else
			{				
				graphics.clear();
				//graphics.lineStyle(1,0);
				graphics.beginFill(0xFFFFFF,0);
				graphics.drawRoundRect(0,0,_model.width,_model.height,0,0);
				graphics.endFill();
			}

		}
		
	}
}