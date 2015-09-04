package utilites 
{
	/**
	 * ...
	 * @author Linda
	 */
	public class ScalingPoint 
	{
		private var _xScaled:Number;
		private var _yScaled:Number;
		
		
		public function ScalingPoint() 
		{
			_xScaled = 1;
			_yScaled = 1;
		}
		
		public function calculateNewScaling(scaleByX:Number, scaleByY:Number):void 
		{
			this.xScaled = scaleByX;
			this.yScaled = scaleByY;
		}
		
		public function get xScaled():Number 
		{
			return _xScaled;
		}
		
		public function set xScaled(value:Number):void 
		{
			_xScaled = value;
		}
		
		public function get yScaled():Number 
		{
			return _yScaled;
		}
		
		public function set yScaled(value:Number):void 
		{
			_yScaled = value;
		}
		
	}

}