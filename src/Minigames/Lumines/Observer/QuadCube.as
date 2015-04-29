package Minigames.Lumines.Observer  
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import flash.events.Event;
	import Minigames.Lumines.Observer.Cube;
	import Minigames.Lumines.Observer.MapNode;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.View.CubeView;
	import flash.events.EventDispatcher;
	public class QuadCube
	{
		public static var RIGHT:Boolean = true;
		public static var LEFT:Boolean = false;
		//private var temp:Array = { 1, 2, 1, 2 };
		private var mNodes:Array = new Array();// this stores mapnodes that have cubeviews
		public function QuadCube() 
		{
			
		}
		public function Cleanup():void
		{
			Reset();
		}
		public function Reset():void
		{
			var i:int;
			for (i = 0; i < mNodes.length; i++ )
			{
				mNodes[i].cubeview.RemoveFromQuad();
			}
			while (mNodes.length>0)
				mNodes.pop();
		}
		public function get Nodes():Array
		{
			return mNodes;
		}
		public function AddNode(theNode:MapNode):void
		{
			if (mNodes.length<(Math.pow(LuminesProperties.GetInstance().QuadSize,2)))
				mNodes.push(theNode);
			else
				throw new Error("QuadCube Container Exceeded");
		}
		public function MoveQuad(X:int, Y:int, Grid:Array):Boolean // Move cubes from one mapnode to another mapnode
		{
			// X and Y are relative array positions
			var i:int = 0;
			var OffsetX:int;
			var OffsetY:int;
			var CubeBuffer:CubeView;
			
			//Checking for left and right if there are occupied cubes
			for (i = 0; i < LuminesProperties.GetInstance().QuadSize; i++)
			{
				//trace(mNodes[i * LuminesProperties.GetInstance().QuadSize + LuminesProperties.GetInstance().QuadSize - 1].ArrayX + X);
				if (X < 0)
				{
					if (mNodes[i * LuminesProperties.GetInstance().QuadSize].ArrayX + X < 0 )
						return true;
					if (Grid[mNodes[i * LuminesProperties.GetInstance().QuadSize].ArrayX + X]
							[mNodes[i * LuminesProperties.GetInstance().QuadSize].ArrayY].Occupied)
						return true;
				}
				else if (X > 0)
				{
					if (mNodes[i * LuminesProperties.GetInstance().QuadSize + LuminesProperties.GetInstance().QuadSize - 1].ArrayX + X 
					>= LuminesProperties.GetInstance().MapWidth)
						return true;
					if (Grid[mNodes[i * LuminesProperties.GetInstance().QuadSize + LuminesProperties.GetInstance().QuadSize - 1].ArrayX + X]
							[mNodes[i * LuminesProperties.GetInstance().QuadSize].ArrayY].Occupied)
						return true;
				}
				if (Y > 0)
				{
					if (mNodes[(LuminesProperties.GetInstance().QuadSize - 1) *
					LuminesProperties.GetInstance().QuadSize + i].ArrayY + Y 
					>= LuminesProperties.GetInstance().MapHeight)
					{
						//Release this QuadCube, and make it go back to a new one
						return false;
					}
					if (Grid[mNodes[(LuminesProperties.GetInstance().QuadSize - 1) * LuminesProperties.GetInstance().QuadSize + i].ArrayX]
							[mNodes[(LuminesProperties.GetInstance().QuadSize - 1) * LuminesProperties.GetInstance().QuadSize + i].ArrayY + Y].Occupied)
					{
						//TODO: Release this QuadCube, and make it go back to a new one
						return false;
					}
				}
			}
			if (X < 0)
				for (i = 0; i < mNodes.length; i++)
				{
					CubeBuffer = mNodes[i].cubeview; // Store CubeView into buffer
					
					mNodes[i].DeAllocateCube(); // Clear Nodes of CubeViews
					mNodes[i] = Grid[mNodes[i].ArrayX + X][mNodes[i].ArrayY + Y]; //Set New Node for Node Array
					mNodes[i].AttachCube(CubeBuffer,true); // restore Cube in node array
				}
			if ((X > 0)||(Y > 0 ))
				for (i = mNodes.length - 1; i >= 0; i--)
				{
					//trace(mNodes[i].ArrayX + X+ " " + mNodes[i].ArrayY + Y);
					CubeBuffer = mNodes[i].cubeview; // Store CubeView into buffer
					mNodes[i].DeAllocateCube(); // Clear Nodes of CubeViews
					mNodes[i] = Grid[mNodes[i].ArrayX + X][mNodes[i].ArrayY + Y]; //Set New Node for Node Array
					mNodes[i].AttachCube(CubeBuffer,true); // restore Cube in node array
				}
			return true;
		}
		public function RotateQuad(Direction:Boolean):void
		{
			RotateSubQuad(Direction,mNodes,LuminesProperties.GetInstance().QuadSize);
		}
		private function RotateSubQuad(Direction:Boolean,SubNodes:Array, QuadSize:int):void
		{
			var SubNodeBuffer:Array =  new Array();
			var CubeBuffer:Array = new Array();
			var i:int;
			var j:int;
			var Deduction:int;
			var Step1:int;
			var Step2:int;
			var CurrentPos:int;
			var Move:int;
			var OldCube:CubeView;
						
			for (i = 0; i < SubNodes.length; i++)
			{
				CubeBuffer.push(SubNodes[i].cubeview);
				SubNodes[i].DeAllocateCube();
			}
			//Rotate the outer quad
			for (i = 1; i < QuadSize; i++)
			{
				CurrentPos = i - 1; // The current position in array 
				Deduction = (i - 1) * 2;
				if (Direction == LEFT)
				{
					Step1 =  i * (QuadSize - 1);
					Step2 = (SubNodes.length - 1 - Deduction) - Step1;
				}
				else
				{
					Step2 =  i * (QuadSize - 1);
					Step1 = (SubNodes.length - 1 - Deduction) - Step2;
				}
				for (j = 1; j <= 4; j++)
				{
					//trace(CurrentPos);
					if (j == 1)//get old cube
					{
						OldCube = CubeBuffer[CurrentPos];
					}
					if (j<=2)
						Move = 1;
					else
						Move = -1;
					if (j % 2 != 0)//odd
					{
						CubeBuffer[CurrentPos] = CubeBuffer[CurrentPos + Move * Step1];
						CurrentPos += Move*Step1;
					}
					else if (j % 2 == 0)//even
					{
						if (j == 4)//For last move, set node back to starting node position
						{
							CubeBuffer[CurrentPos] = OldCube;
						}
						else
						{
							CubeBuffer[CurrentPos] = CubeBuffer[CurrentPos + Move * Step2];
						}
						CurrentPos += Move*Step2;
					}
				}
			}
			for (i = 0; i < SubNodes.length; i++)
			{
				SubNodes[i].AttachCube(CubeBuffer[i],true);
			}
			
			//Now to rotate the smaller quads in this quad
			var NumQuads:int = QuadSize / 2;
			
			//trace("QuadSize NumQuads " + QuadSize + " " + NumQuads);
			if (NumQuads < 2)
				return;
			
			for (i = 1; i < QuadSize - 1; i++)// The Row
			{
				for (j = 1; j < QuadSize - 1; j++)// The Quads to collect
				{
					CurrentPos = i * QuadSize + j;
					SubNodeBuffer.push(SubNodes[CurrentPos]);
				}
			}
			RotateSubQuad(Direction,SubNodeBuffer, QuadSize - 2);
		}
	}
}