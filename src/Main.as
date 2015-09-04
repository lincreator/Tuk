package
{
	import content.MainContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import utilites.ConvertStringNum;
	
	
	/**
	 * ...
	 * @author Linda
	 */
	public class Main extends Sprite 
	{
		private var mainContainer:MainContainer;
		public static var stageW:Number;
		public static var stageH:Number;
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// config stage
			stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.quality = StageQuality.LOW;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			mainContainer = new MainContainer();
			stage.addChild(mainContainer);
			
			
		}
		
	}
	
}