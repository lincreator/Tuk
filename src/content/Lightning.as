package content 
{
	/**
	 * ...
	 * @author Linda
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import utilites.ScalingPoint;
	 
	public class Lightning extends Sprite
	{
		
		
		private var normalMap:BitmapData;
		private var lightMap:BitmapData;
		private var dat:BitmapData;
		
		// ---------------------
		
		private const WIDTH:int = Main.stageW;
		private const HEIGHT:int = Main.stageH;
		
		private var light:Vector3D;
		private var lightDst:int = 96;
		private var norm:Vector.<Vector3D>;
		private var Nm:Vector3D = new Vector3D();
		private var Nl:Vector3D = new Vector3D();
		
		private const LIMIT:int = 128;
		private var power:int = 10000;
		private var diffuseImg:Bitmap;
		private var normalImg:Bitmap;
		private var lumImg:Bitmap;
		
		private var loader:Loader;
		private var tempImg:Bitmap;
		
		private var loaderCount:int = 0;
		
		
		
		public function Lightning(urlDiff:String, urlNorm:String,urlLum:String) 
		{
			
			loadImg(urlDiff);
			loadImg(urlNorm);
			loadImg(urlLum);
			
		}
		
		private function loadImg(imgUrl:String):void 
		{
			loader = new Loader();
			var request:URLRequest = new URLRequest(imgUrl);
			loader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
			loader.load(request);
		}
		
		private function initListener(e:Event):void 
		{
			loaderCount++;
			tempImg = new Bitmap();
			tempImg.bitmapData = e.currentTarget.content.bitmapData;
			//var scaling:ScalingPoint = this.defineScale_X_Y(tempImg);
			//scaleImage(scaling, tempImg);
			switch (loaderCount) 
			{
				case 1:
					diffuseImg = tempImg;
					this.addChild(diffuseImg);
				break;
				case 2:
					normalImg = tempImg;
				break;
				case 3:
					lumImg = tempImg;
					continueActions();
				break;
				default:
			}
			
		}
		
		private function continueActions():void 
		{
			
			
			light = new Vector3D(0, 0, lightDst);
			norm = new Vector.<Vector3D>(WIDTH * HEIGHT, true);
			
			normalMap = normalImg.bitmapData;
			lightMap = lumImg.bitmapData;
			
			// my lightning
			dat = new BitmapData(normalMap.width, normalMap.height, false, 0x0);
			var bmp:Bitmap = new Bitmap(dat);
			bmp.blendMode = BlendMode.MULTIPLY;
			this.addChild(bmp);
			
			
			// filling my vector
			var xx:int = 0;
			var yy:int = 0;
			var coul:Number;
			var idx:int = 0;
			while (xx < WIDTH)
			{
				yy = 0;
				while (yy < HEIGHT)
				{
					coul = normalMap.getPixel(xx, yy);
					idx = (xx + (yy * WIDTH));
					norm[idx] = new Vector3D(( -128 + ((coul >> 16) & 0xFF)),
												( -128 + ((coul >> 8) & 0xFF)), 
												(-128 + (coul & 0xFF)));
					norm[idx].normalize();
					++yy;
				}
				;
				++xx;
			}
			
			//Mouse.hide();
			
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, _onClickFullScreen);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
			stage.addEventListener(KeyboardEvent.KEY_UP, _onSpaceBar);
		}//end continueActions()
		
		private function _onSpaceBar(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				diffuseImg.visible = !diffuseImg.visible;
			}
		}
		
		private function update(e:MouseEvent):void 
		{
			e.updateAfterEvent();
			e.stopImmediatePropagation();
			
			// --
			light.x = mouseX;
			light.y = mouseY;
			
			// --
			var xxMin:int = mouseX - LIMIT;
			if (xxMin < 0)
			{
				xxMin = 0;
			}
			var yyMin:int = 0;
			yyMin = mouseY - LIMIT;
			// --
			var xxMax:int = mouseX + LIMIT;
			if (xxMax > WIDTH)
			{
				xxMax = WIDTH;
			}
			var yyMax:int = mouseY + LIMIT;
			if (yyMax > HEIGHT)
			{
				yyMax = HEIGHT;
			}
			// --
			var len:Number;
			var c:uint;
			
			// --
			dat.fillRect(dat.rect, 0x444444);
			Nl = new Vector3D();
			while (xxMin < xxMax)
			{
				yyMin = mouseY - LIMIT;
				if (yyMin < 0)
				{
					yyMin = 0;
				}
				while (yyMin < yyMax)
				{
					Nm = norm[(xxMin + (yyMin * WIDTH))];
					Nl.x = (xxMin - light.x);Nl.y = (yyMin - light.y);Nl.z = -(light.z);				len = Nl.length;
					Nl.normalize();
					c = ((power * (1 - Nm.dotProduct(Nl))) / len);
					if (c > 0xFF)
						c = 0xFF;
					dat.setPixel(xxMin, yyMin, (((c << 16) | (c << 8)) | c));
					++yyMin;
				}
				++xxMin;
			}
			
			// self illum
			dat.draw(lightMap, null, null, BlendMode.ADD);
		}
		
		private function _onClickFullScreen(e:MouseEvent):void 
		{
			stage.fullScreenSourceRect = new Rectangle(0, 0, Main.stageW, Main.stageH);
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		//create a new object and return it
		private function defineScale_X_Y(img:Bitmap):ScalingPoint
		{
			var sPoint:ScalingPoint = new ScalingPoint();
			sPoint.calculateNewScaling(Main.stageW / img.width, Main.stageH / img.height);
			return sPoint;
		}
		
		private function scaleImage(scalePoint:ScalingPoint, img:Bitmap):void
		{
			
			try 
			{
				
				img.scaleX = scalePoint.xScaled;
				img.scaleY = scalePoint.yScaled;
			}
			catch (err:Error)
			{
				trace("In Lightning.scaleImage()", err.message);
				
			}
			
		}
	}

}
