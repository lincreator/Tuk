package content 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * ...
	 * @author Linda
	 */
	public class MainContainer extends Sprite 
	{
		private var loader:Loader;
		private var img:Bitmap;
		private var normal:Bitmap;
		public function MainContainer() 
		{
			super();
			//createBG("resources/textures/myEarth_DIFFUSE.png");
			
			var li:Lightning = new Lightning("resources/textures/myEarth_DIFFUSE.png",
												"resources/textures/myEarth_NORMAL.png",
												"resources/textures/myEarth_DISP.png");
			addChild(li);
		}
		
		public function createBG(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
			loader.load(request);
		}
		
		public function createNormal(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, initNormalListener);
			loader.load(request);
		}
		
		private function initNormalListener(e:Event):void 
		{
			normal = new Bitmap();
			normal.bitmapData = Bitmap(loader.content).bitmapData.clone();			
			normal.scaleX = Main.stageW / normal.width;
			normal.scaleY = Main.stageH / normal.height;
			
			try 
			{
				var rect:Rectangle = new Rectangle(0, 0, img.width, img.height);
				var pt:Point = new Point(1, 1);
				var mult:uint = 0x10; // 50% 
				img.bitmapData.merge(normal.bitmapData, rect,pt,mult,mult,mult,0xff);
			}
			catch (err:Error)
			{
				
			}
			
			addChild(img);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, initNormalListener);
		}
		
		private function initListener(e:Event):void 
		{
			img = new Bitmap();
			img.bitmapData = Bitmap(loader.content).bitmapData.clone();			
			img.scaleX = Main.stageW / img.width;
			img.scaleY = Main.stageH / img.height;
			
			loader.contentLoaderInfo.removeEventListener(Event.INIT, initListener);
			createNormal("resources/textures/myEarth_NORMAL.png");
		}
		
	}

}