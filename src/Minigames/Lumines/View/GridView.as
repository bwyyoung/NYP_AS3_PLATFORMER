package Minigames.Lumines.View 
{
	import flash.display.Shape;
	import Managers.GraphicsManager;
	/**
	* ...
	* @author $(DefaultUser)
	*/

	//this class draws out the background grid in the game
	public class GridView 
	{
		private var Lines:Array;
		public function GridView() 
		{
			Lines = new Array();
		}
		public function Cleanup():void
		{
			for each (var temp:Shape in Lines)
			{
				if (temp.parent != null)
				{
					temp.parent.removeChild(temp);
				}
			}
		}
		public function DrawLine(StartX:int, StartY:int, EndX:int, EndY:int):void
		{
			var Line:Shape = new Shape();
			Line.graphics.lineStyle(2,0xffffff,100);
			Line.graphics.moveTo(StartX, StartY);
			Line.graphics.lineTo(EndX, EndY);
			GraphicsManager.GetInstance().MapGround.addChildAt(Line, 0);
			Lines.push(Line);
		}
	}
	
}