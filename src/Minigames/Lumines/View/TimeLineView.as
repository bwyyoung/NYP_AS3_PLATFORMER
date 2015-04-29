package Minigames.Lumines.View 
{
	import flash.display.Shape;
	import Managers.GraphicsManager;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	
	//this class draws the timeline for the map
	public class TimeLineView 
	{
		private var Line:Shape;
		public var mY:int;
		private var mLength:int;
		public function TimeLineView() 
		{

		}
		public function ReDrawLine(TopX:int):void
		{
			Line.graphics.clear();				
			Line.graphics.lineStyle(3, 0xFF0000,100);
			Line.graphics.beginFill(0xFF7777);
			Line.graphics.moveTo(TopX, mY);
			Line.graphics.lineTo(TopX, mY + mLength);
			Line.graphics.endFill();
		}
		public function Cleanup():void
		{
			if (Line != null)
			{
				if (Line.parent != null)
					Line.parent.removeChild(Line);
			}
		}
		public function DrawLine(TopX:int,TopY:int, Length:int):void
		{
			Line = new Shape();
			mY = TopY;
			mLength = Length;
			Line.graphics.lineStyle(1, 0xFF0000);
			Line.graphics.beginFill(0xFF7777);
			Line.graphics.moveTo(TopX, TopY);
			Line.graphics.lineTo(TopX, TopY + Length);
			Line.graphics.endFill();
			GraphicsManager.GetInstance().ForeGround.addChild(Line);
		}
		
	}
	
}