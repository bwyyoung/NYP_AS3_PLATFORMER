package Minigames.Lumines.Observer 
{
	import Minigames.Lumines.View.CubeView;
	import Minigames.Lumines.View.TimeLineView;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.View.ClearQuadBlockView;
	import Managers.GUIManager;
	import GraphicalUserInterface.LuminesGUI;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class TimeLine 
	{
		public var PreviousArrayPos:int;
		public var CurrentArrayPos:int;
		public var CurrentX:Number;
		private var mMinX:int;
		private var mMaxX:int;
		private var mTimeline:TimeLineView;
		private var BlockSetsArray:Array = new Array();
		public function TimeLine(MinX:int, MaxX:int, TopY:int, Length:int) 
		{
			CurrentArrayPos = 0;
			PreviousArrayPos = -1;
			mTimeline = new TimeLineView();
			mTimeline.DrawLine(MinX, TopY, Length);
			mMinX = MinX;
			mMaxX = MaxX;
			CurrentX = mMinX;
		}
		public function Cleanup():void
		{
			mTimeline.Cleanup();
		}
		private function CheckMapFill(theMapArray:Array):Boolean
		{
			var NumOccupied:int = 0;
			for (var i:int = 0; i < theMapArray.length; i++)
			{
				for (var j:int = 0; j < theMapArray[i].length; j++)
				{
					if (theMapArray[i][j].Occupied)
					{
						NumOccupied++;
					}
				}
			}
			if (NumOccupied >= LuminesProperties.GetInstance().MapFillAlert)
				return true;
			return false;
		}
		public function Update(theMapArray:Array):Boolean
		{
			var IsClear:Boolean = false;
			var ReClear:Boolean = false;
			CurrentX += LuminesProperties.GetInstance().TimeLineSpeed;
			
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).SetComboBoxPosition(CurrentX, mTimeline.mY);
			
			if (CurrentX >= mMaxX)
			{
				CurrentX = mMinX;
				

			}
			CurrentArrayPos = (CurrentX - mMinX) / LuminesProperties.GetInstance().BlockSize;
			if (PreviousArrayPos != CurrentArrayPos)
			{
				if (CurrentArrayPos == 0)
				{
					for each (var theblk:ClearQuadBlockView  in BlockSetsArray)
					{
						theblk.ClearCubes(theMapArray);
					}
					while (BlockSetsArray.length > 0)
						BlockSetsArray.pop();
					ReClear = true;
				}
				IsClear = ScanColumn(theMapArray);
				PreviousArrayPos = CurrentArrayPos;
				if (ReClear)
					IsClear = true;
			}
			mTimeline.ReDrawLine(CurrentX);
			
			
			if (CurrentX == mMinX)
			{
				var theCurrentGUIState:String = (GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).mCurrentState;
				if (CheckMapFill(theMapArray))
				{
					if (theCurrentGUIState != LuminesGUI.LUMINES_ALERT)
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).SetAlertState(LuminesGUI.LUMINES_ALERT);
				}
				else
				{
					if (theCurrentGUIState != LuminesGUI.LUMINES_NORMAL)
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).SetAlertState(LuminesGUI.LUMINES_NORMAL);
				}
				
				(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).CheckCombo();
			}
			
			return IsClear;
		}
		//here, we scan the column for matching quads and clear them as necessary
		public function ScanColumn(theMapArray:Array):Boolean
		{
			var j:int;
			var i:int;
			var k:int;
			var Gravity:Boolean = false;
			var Clear:Boolean = true;
			var Empty:Boolean  = true;
			var BlockSetsArray2:Array = new Array(); //these are blocksets to be cleared
			var BlockSetsArray3:Array = new Array(); //these are the current blocksets in the column
			for (j = 0; j < LuminesProperties.GetInstance().MapHeight; j++)// Scan the current column
			{
				if (theMapArray[CurrentArrayPos][j].cubeview != null)
					if (theMapArray[CurrentArrayPos][j].cubeview.NodeObject != null)
					{
						Empty = false;
						var BlockSet:ClearQuadBlockView = theMapArray[CurrentArrayPos][j].cubeview.NodeObject;
						theMapArray[CurrentArrayPos][j].cubeview.MarkforRemoval();
						for (k = 0; k < BlockSetsArray.length; k++)
						{
							if (BlockSetsArray[k] === BlockSet)//this block already exists in the blockset, which means that it cannot be cleared yet
							{
								break;
							}
						}
						if (k == BlockSetsArray.length)//the block can be cleared, since it is not in the current column, but first we need to check if it is intersecting with 
						//with our current column's blocksets
						{
							BlockSetsArray.push(BlockSet);//the block is new
						}
					}
			}

			var HighY:int = -1;
			var HighX:int= -1;
			var LowY:int = -1;
			var LowX:int = -1;//these are for the current column blocksets

			var X:int = -1;
			var Y:int = -1;
			var X1:int = -1;
			var Y1:int = -1;//this is for blocksets that want to be cleared
			
			var RefArray:Array = new Array();
			for (j = 0; j < BlockSetsArray.length; j++)//now checking the blocks to be cleared
			{
				for (i = 0; i < BlockSetsArray[j].QuadNodes.length; i++)
				{
					if (X == -1)
					{
						X = BlockSetsArray[j].QuadNodes[i].ArrayX;
					}
					if (Y == -1)
					{
						Y = BlockSetsArray[j].QuadNodes[i].ArrayY;
					}
					if (BlockSetsArray[j].QuadNodes[i].ArrayX < X)
						X = BlockSetsArray[j].QuadNodes[i].ArrayX; 
					if (BlockSetsArray[j].QuadNodes[i].ArrayY < Y)
						Y = BlockSetsArray[j].QuadNodes[i].ArrayY; //lowest Y
					if (BlockSetsArray[j].QuadNodes[i].ArrayX > X1)
						X1 = BlockSetsArray[j].QuadNodes[i].ArrayX; 
					if (BlockSetsArray[j].QuadNodes[i].ArrayY > Y1)
						Y1 = BlockSetsArray[j].QuadNodes[i].ArrayY; //lowest Y
				}

				for (k = 0; k < BlockSetsArray.length; k++)//these are the blocksets in the current row
				{
					Clear = true; ///TODO: EXperimental
					if (BlockSetsArray[k] !== BlockSetsArray[j])
					{	
						for (i = 0; i < BlockSetsArray[k].QuadNodes.length; i++)//checking the nodes of the blocksets in the current row
						{
							if (LowX == -1)
							{
								LowX = BlockSetsArray[k].QuadNodes[i].ArrayX;
							}
							if (LowY == -1)
							{
								LowY = BlockSetsArray[k].QuadNodes[i].ArrayY;
							}
							if ( BlockSetsArray[k].QuadNodes[i].ArrayX > HighX)
							{
								HighX = BlockSetsArray[k].QuadNodes[i].ArrayX;
							}
							if ( BlockSetsArray[k].QuadNodes[i].ArrayY > HighY)
							{
								HighY = BlockSetsArray[k].QuadNodes[i].ArrayY;
							}
							if ( BlockSetsArray[k].QuadNodes[i].ArrayY < LowY)
							{
								LowY = BlockSetsArray[k].QuadNodes[i].ArrayY;
							}
							if ( BlockSetsArray[k].QuadNodes[i].ArrayX < LowX)
							{
								LowX = BlockSetsArray[k].QuadNodes[i].ArrayX;
							}
						}
						if (X1 >= LowX)
							if (X1<=HighX)
								Clear = false;	
						if (X >= LowX)
							if (X<=HighX)
								Clear = false;	
						LowX = -1;
						HighX = -1;
						HighY = -1;
						LowY = -1;
					}
				}
				if (X1 >= CurrentArrayPos)
					Clear = false;
				if (Clear)
				{
					RefArray.push(j);
				}
				X = -1;
				Y = -1;
				X1 = -1;
				Y1 = -1;
			}

			for each(var a:int in RefArray)
			{
				BlockSetsArray[a].ClearCubes(theMapArray);
				Gravity = true;
			}
			for each(var b:int in RefArray)
			{
				BlockSetsArray.splice(b, 1);
				for (i = 0; i < RefArray.length; i++ )
				{
					if (RefArray[i] > b)
						RefArray[i]--;
				}
			}
			if (Empty)
			{
				for (i = 0; i < BlockSetsArray.length; i++)
				{
					BlockSetsArray[i].ClearCubes(theMapArray);
				}
				while (BlockSetsArray.length > 0)
					BlockSetsArray.pop();
				Gravity = true;
			}
			return Gravity;
		}
		
	}
	
}