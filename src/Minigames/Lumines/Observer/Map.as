package Minigames.Lumines.Observer  
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import Minigames.Lumines.Observer.MapNode;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.View.ClearQuadBlockView;
	import Minigames.Lumines.View.GridView;
	import Minigames.Lumines.Observer.TimeLine;
	import Minigames.Lumines.Observer.ClearQuadBlock;
	import Managers.StateManager;
	import States.MinigameState;
	
	public class Map 
	{
		private var mMapArray:Array; // Array of map nodes
		private var mMovingCubesArray:Array; // Array of moving cubes affected by gravity on the map
		private var mMovingNewCubesArray:Array; // Array of new cubes that are to be moved
		private var mMapProperties:LuminesProperties = LuminesProperties.GetInstance(); //Properties of the map to be affected
		private var mQuadCube:QuadCube; // The QuadCube with quads to move
		private var mGridView:GridView; // the grid background
		private var mTimeLine:TimeLine;
		private var mClearQuadBlock:ClearQuadBlock;
		private var mFallenNodes:Array; // This is my X number of new nodes that have come into the game
		private var DoMatchScan:Boolean  = false;
		
		public function Map() 
		{

		}
		public function Cleanup():void
		{
			mGridView.Cleanup();
			mTimeLine.Cleanup();
			mClearQuadBlock.Cleanup();
			mQuadCube.Cleanup();

			for (var j:int = mMapProperties.MapHeight - 1; j >= 0 ; j--)
				for (var i:int = mMapProperties.MapWidth - 1; i >= 0 ; i--)
				{
					mMapArray[i][j].ClearCube();
				}
			for each (var node:MapNode in mFallenNodes)
			{
				node.ClearCube();
			}
			for each (node in mMovingCubesArray)
			{
				node.ClearCube();
			}
			for each (node in mMovingNewCubesArray)
			{
				node.ClearCube();
			}
			
			while (mMovingCubesArray.length > 0)
			{
				mMovingCubesArray.pop();
			}
			while (mMovingNewCubesArray.length > 0)
			{
				mMovingNewCubesArray.pop();
			}
		}
		public function ResumeCubes():void
		{
			for each(var temp:MapNode in mMapArray)
			{
				if (temp.cubeview != null)
					temp.cubeview.AddToMap();
			}
		}
		public function Init():void
		{
			var i:int;
			var j:int;
			mFallenNodes = new Array();
			mTimeLine = new TimeLine(mMapProperties.MapOffsetX,
			mMapProperties.MapOffsetX + mMapProperties.BlockSize * mMapProperties.MapWidth,
			mMapProperties.MapOffsetY + mMapProperties.BlockSize * mMapProperties.QuadSize, 
			mMapProperties.BlockSize * mMapProperties.MapHeight
			-mMapProperties.BlockSize*mMapProperties.QuadSize);
			mMovingCubesArray =  new Array();
			mMovingNewCubesArray = new Array();
			mMapArray =  new Array(mMapProperties.MapWidth);
			mGridView = new GridView();
			mClearQuadBlock = new ClearQuadBlock();
			for (i = 0; i < mMapProperties.MapWidth; i++)
			{
				//Draw vertical line
				mGridView.DrawLine(mMapProperties.MapOffsetX + mMapProperties.BlockSize * (i), 
				mMapProperties.MapOffsetY+ mMapProperties.BlockSize * mMapProperties.QuadSize,
				mMapProperties.MapOffsetX + mMapProperties.BlockSize * (i), 
				mMapProperties.MapOffsetY +  mMapProperties.BlockSize * mMapProperties.MapHeight);
									
				mMapArray[i] = new Array(mMapProperties.MapHeight);
				for (j = 0 ; j < mMapProperties.MapHeight; j++)
				{
					// Draw Horizontal line
					if (j > mMapProperties.StartY + mMapProperties.QuadSize -1)
						mGridView.DrawLine(mMapProperties.MapOffsetX , 
						mMapProperties.MapOffsetY + mMapProperties.BlockSize * (j + 1),
						mMapProperties.MapOffsetX + mMapProperties.BlockSize * mMapProperties.MapWidth,
						mMapProperties.MapOffsetY + mMapProperties.BlockSize * (j + 1));
						mMapArray[i][j] = new MapNode(mMapProperties.MapOffsetX + mMapProperties.BlockSize * i, 
						mMapProperties.MapOffsetY + mMapProperties.BlockSize * j,	
						i, j);
				}
			}
			mGridView.DrawLine(mMapProperties.MapOffsetX+ mMapProperties.BlockSize *  mMapProperties.MapWidth, mMapProperties.MapOffsetY + mMapProperties.BlockSize*mMapProperties.QuadSize,
							mMapProperties.MapOffsetX + mMapProperties.BlockSize *  mMapProperties.MapWidth, mMapProperties.MapOffsetY + mMapProperties.BlockSize * mMapProperties.MapHeight);
			mQuadCube = new QuadCube();
		}

		
		public function GravityScan():void
		{
			var i:int;
			var j:int;
			var k:int;
			var FinalNode:MapNode;
			var BlockSetReferenceArray:Array = new Array();
			for (j = mMapProperties.MapHeight - 1; j >= 0 ; j--)
				for (i = mMapProperties.MapWidth - 1; i >= 0 ; i--)
				{
					if (j + 1 < mMapProperties.MapHeight)
					{
						if (mMapArray[i][j].cubeview != null)
							if (mMapArray[i][j].cubeview.Active == false)
								if (mMapArray[i][j].Occupied)
									if (mMapArray[i][j + 1].Occupied == false)//check if space below is empty
									{
										mMapArray[i][j].cubeview.SetDefaultParams();
										mMapArray[i][j].cubeview.RemoveMask();
										if (mMapArray[i][j].cubeview.NodeObject != null)
										{
											var theObject:Object = mMapArray[i][j].cubeview.NodeObject;
											mMapArray[i][j].cubeview.NodeObject.RemoveNode(mMapArray[i][j].cubeview);
											mMapArray[i][j].cubeview.NodeObject = null;
											theObject.ClearGraphics();
										}
										FinalNode = LowestNode(mMapArray[i][j + 1]);
										mMapArray[i][j].SetCubeToNewNode(FinalNode);
										mMovingCubesArray.push(FinalNode);
										FinalNode.cubeview.mActive = true;
										for (k = 0; k < mFallenNodes.length; k++)
										{
											if (mFallenNodes[k].ArrayX == mMapArray[i][j].ArrayX)
												if (mFallenNodes[k].ArrayY == mMapArray[i][j].ArrayY)
												{
													mFallenNodes.splice(k, 1, FinalNode);
													break; //NOTE: WHY am i breaking here??? I think it is because if i already found the matching node, i should move on to the next one
												}
										}
										if (k == mFallenNodes.length)//no match has been found for the fallennode, so add it in!
											if (FinalNode.cubeview.NodeObject == null)
												mFallenNodes.push(FinalNode);
									}
					}
				}
				if (mFallenNodes.length>0)
					DoMatchScan = true;
		}

		public function AttachNewQuad(TheQuads:Array):void
		{
			var i:int;
			var j:int;
			var k:int;
			var Count:int = 0;			
			var temp:Array = new Array();
			

			for (i = 0; i < mQuadCube.Nodes.length; i++ )
			{
				mFallenNodes.push(mQuadCube.Nodes[i]);	
				temp.push(mQuadCube.Nodes[i]);
			}
			mQuadCube.Reset();
			GravityScan();
			
			//this clears away any overflowing blocks in the grid
			var Overflowers:Array = new Array();
			for (i = 0; i < mMapProperties.MapWidth; i++)
				for (j = 0 ; j < mMapProperties.QuadSize; j++)
				{
					if (mMapArray[i][j].cubeview != null)
					{
						//checking for cubes that have overflowed
						for (k = 0; k < mFallenNodes.length; k++)
						{
							if (mFallenNodes[k].cubeview === mMapArray[i][j].cubeview)
							{
								mFallenNodes.splice(k, 1);
								break;
							}
						}
						for (k = 0; k < mMovingCubesArray.length; k++)
						{
							if (mMovingCubesArray[k].cubeview === mMapArray[i][j].cubeview)
							{
								mMovingCubesArray.splice(k, 1);
								break;
							}
						}
						Overflowers.push(mMapArray[i][j]);
					}
				}
			for each (var tempnode:MapNode in Overflowers)
			{
				tempnode.ClearCube();
			}
			//here, if there is too much overflow, its game over...
			if (Overflowers.length > (LuminesProperties.GetInstance().QuadSize * LuminesProperties.GetInstance().QuadSize)/2)
			{
				(StateManager.GetInstance().GetState(StateManager.MINIGAMESTATE) as MinigameState).EndMiniGame();
			}
			for ( j = mMapProperties.StartY; j < mMapProperties.StartY + mMapProperties.QuadSize; j++ )
				for ( i = mMapProperties.StartX; i < mMapProperties.StartX + mMapProperties.QuadSize; i++ )
				{//shift new cubes to the map
					mMapArray[i][j].ShiftCube(TheQuads[Count], true);
					mMovingNewCubesArray.push(mMapArray[i][j]);
					mQuadCube.AddNode(mMapArray[i][j]);
					Count++;
				}		


		}
		public function Move(X:int, Y:int):Boolean
		{
			if (mMovingNewCubesArray.length > 0 || mQuadCube.Nodes.length!=LuminesProperties.GetInstance().QuadSize*LuminesProperties.GetInstance().QuadSize)
			{
				return true;
			}
			else
			{
				return mQuadCube.MoveQuad(X, Y, mMapArray);
			}
		}
		public function Rotate(Direction:Boolean):void
		{
			mQuadCube.RotateQuad(Direction);
		}
		private function LowestNode(CurrentNode:MapNode):MapNode
		{
			if (CurrentNode.ArrayY + 1< mMapProperties.MapHeight)
			{
				if (mMapArray[CurrentNode.ArrayX][CurrentNode.ArrayY + 1].Occupied == false)
				{
					return LowestNode(mMapArray[CurrentNode.ArrayX][CurrentNode.ArrayY + 1]);
				}
				else
				{
					return mMapArray[CurrentNode.ArrayX][CurrentNode.ArrayY];
				}
			}
			return mMapArray[CurrentNode.ArrayX][CurrentNode.ArrayY];
		}
		public function Update():void
		{	
			var i:int;
			var Increment:Number;
			// Here, gravity is applied to the blocks that are floating in the air on the map
			if (mMovingCubesArray.length > 0)
			{
				for (i = 0; i < mMovingCubesArray.length; i++ )
				{
					Increment = (mMovingCubesArray[i].Y - 
					mMovingCubesArray[i].cubeview.Y) * mMapProperties.AnimSpeed;
					if (Increment < 1)
						Increment = 1;
					mMovingCubesArray[i].cubeview.SetPosition( mMovingCubesArray[i].cubeview.X,
					mMovingCubesArray[i].cubeview.Y + Increment); 
					if (mMovingCubesArray[i].Y <= mMovingCubesArray[i].cubeview.Y  )//- mMapProperties.BlockSize)
					{
						mMovingCubesArray[i].cubeview.SetPosition(mMovingCubesArray[i].X, mMovingCubesArray[i].Y,
						mMovingCubesArray[i].ArrayX, mMovingCubesArray[i].ArrayY);
						mMovingCubesArray[i].cubeview.mActive = false;
						mMovingCubesArray.splice(i,1);
					}
				}
			}
			else
			{
				if (DoMatchScan)
				{
					mClearQuadBlock.CheckMatches(mMapArray, mFallenNodes);
					DoMatchScan = false;
					GravityScan();
					while (mFallenNodes.length > 0)
						mFallenNodes.pop();
				}
			}
			// Here the shifting animation between the stack and the map is applied
			if (mMovingNewCubesArray.length > 0)
			{
				for (i = 0; i < mMovingNewCubesArray.length; i++ )
				{
					Increment = (mMovingNewCubesArray[i].X - 
					mMovingNewCubesArray[i].cubeview.X) * mMapProperties.AnimSpeed;
					if (Increment < 1)
						Increment = 1;
					mMovingNewCubesArray[i].cubeview.SetPosition( mMovingNewCubesArray[i].cubeview.X + Increment,
					mMovingNewCubesArray[i].cubeview.Y); 
					if (mMovingNewCubesArray[i].X <= mMovingNewCubesArray[i].cubeview.X)
					{
						mMovingNewCubesArray[i].cubeview.SetPosition(mMovingNewCubesArray[i].X, mMovingNewCubesArray[i].Y,
						mMovingNewCubesArray[i].ArrayX,mMovingNewCubesArray[i].ArrayY);
						mMovingNewCubesArray.splice(i,1);
					}
				}
			}
			if (mTimeLine.Update(mMapArray))
			{
				GravityScan();
			}
			//mClearQuadBlock.Update(mTimeLine.CurrentX);
		}
	}
	
}