package Minigames.Lumines.Observer  
{

	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.View.ClearQuadBlockView;
	import Minigames.Lumines.View.CubeView;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class ClearQuadBlock 
	{
		private var mClearQuadBlockViewArray:Array;
		private var mCrossBlocks:Array;
		private var mbgColor3:uint		 = 0xaba9ac; //grey
		private var mMapProperties:LuminesProperties = LuminesProperties.GetInstance();

		public function ClearQuadBlock():void
		{
			mCrossBlocks = new Array();
			mClearQuadBlockViewArray = new Array();
		}
		public function Cleanup():void
		{
			for each (var temp:ClearQuadBlockView in mClearQuadBlockViewArray)
			{
				temp.Cleanup();
			}
			while (mClearQuadBlockViewArray.length > 0)
			{
				mClearQuadBlockViewArray.pop();
			}
			while (mCrossBlocks.length > 0)
			{
				mCrossBlocks.pop();
			}
		}
		public function AddQuadBlock(ReferenceNodes:Array):void
		{
			mClearQuadBlockViewArray.push(new ClearQuadBlockView(ReferenceNodes));
		}
		
		public function CheckMatches(theMapArray:Array, theFallenNodes:Array):void
		{
			var i:int;
			if (theFallenNodes.length > 0)
			{
				for (i = 0; i < theFallenNodes.length; i++)
				{
					if (theFallenNodes[i].cubeview.mBlockType % 2 == 0)
					{
						theFallenNodes[i].cubeview.mBlockType -= 1;
						mCrossBlocks.push(theFallenNodes[i].cubeview);
					}
				}
			}
			var RefArray:Array = new Array();

			if (mClearQuadBlockViewArray.length > 0)// if there are already existing quad blocks, do checking 
			{
				for (i = 0; i < mClearQuadBlockViewArray.length; i++ )
				{
					if (mClearQuadBlockViewArray[i].QuadNodes.length == 0)
						RefArray.push(i);
				}
				for each (var RefNum:int in RefArray)
				{
					mClearQuadBlockViewArray.splice(RefNum, 1);
					for (i = 0; i < RefArray.length; i++ )
					{
						if (RefArray[i] > RefNum)
							RefArray[i]--;
					}
				}	
				for (i = 0; i < mClearQuadBlockViewArray.length; i++)
				{
					//trace("----------------------------------------------------------------")
					CheckNodesInBlockSet(theMapArray, mClearQuadBlockViewArray[i]);
					//trace("Length " + mClearQuadBlockViewArray[i].QuadNodes.length);
					//trace("----------------------------------------------------------------")
				}
			}
			
			//Now Check theFallenNodes for possible blocksets
			var j:int;
			var k:int;
			var l:int;
			var TestNodes:Array;
			var FallenNodeQuad:Boolean = true;
			var MatchingFallenNodesIndex:Array;
			var FoundQuad:Boolean = false;
			while (FallenNodeQuad)
			{
			///	trace("FallenNodeLength  " + theFallenNodes.length)
				if (theFallenNodes.length > 0)
				{
					for (i = 0; i < theFallenNodes.length; i++)
					{
						var ArrayX:int =  theFallenNodes[i].ArrayX;
						var ArrayY:int =  theFallenNodes[i].ArrayY;
						//scan leftdown
						if (theFallenNodes[i].ArrayX - mMapProperties.MatchSize + 1>= 0){
							if (theFallenNodes[i].ArrayY + mMapProperties.MatchSize - 1 < mMapProperties.MapHeight)
							{
								///trace("scan leftdown")
								TestNodes = new Array();
								for (j = 0; j > -mMapProperties.MatchSize; j--)
									for (k = 0; k < mMapProperties.MatchSize; k++)
									{
										///trace((ArrayX + j) + " " + (ArrayY + k))
										TestNodes.push(theMapArray[ArrayX + j][ArrayY + k]);
									}
								if (MatchCheck(TestNodes))
								{
									FoundQuad = true;
									break;
								}
							}
						//scan leftup
							if (theFallenNodes[i].ArrayY - mMapProperties.MatchSize + 1> mMapProperties.BlockSize)
							{
								///trace("scan leftup")
								TestNodes = new Array();
								for (j = 0; j > -mMapProperties.MatchSize; j--)
									for (k = 0; k > -mMapProperties.MatchSize; k--)
									{
										///trace((ArrayX + j) + " " + (ArrayY + k))
										TestNodes.push(theMapArray[ArrayX + j][ArrayY + k]);
									}
								if (MatchCheck(TestNodes))
								{
									FoundQuad = true;
									break;
								}
							}
						}
						//scan rightdown
						if (theFallenNodes[i].ArrayX + mMapProperties.MatchSize -1< mMapProperties.MapWidth){
							if (theFallenNodes[i].ArrayY + mMapProperties.MatchSize - 1 < mMapProperties.MapHeight)
							{
															///	trace("scan rightdown")
								TestNodes = new Array();
								for (j = 0; j < mMapProperties.MatchSize; j++)
									for (k = 0; k < mMapProperties.MatchSize; k++)
									{
									///	trace((ArrayX + j) + " " + (ArrayY + k))
										TestNodes.push(theMapArray[ArrayX + j][ArrayY + k]);
									}
								if (MatchCheck(TestNodes))
								{
									FoundQuad = true;
									break;
								}
							}
						//scan rightup
							if (theFallenNodes[i].ArrayY - mMapProperties.MatchSize + 1 >= mMapProperties.BlockSize)
							{
								///trace("scan rightup")
								TestNodes = new Array();
								for (j = 0; j < mMapProperties.MatchSize; j++)
									for (k = 0; k > -mMapProperties.MatchSize; k--)
									{
										///trace((ArrayX + j) + " " + (ArrayY + k))
										TestNodes.push(theMapArray[ArrayX + j][ArrayY + k]);
									}
								if (MatchCheck(TestNodes))
								{
									FoundQuad = true;
									break;
								}
							}
						}
						if (FoundQuad)
							break;
					}
					if (FoundQuad)
					{
						//for each (var a:MapNode in TestNodes)
						//{
							//trace("Matchset " + a.cubeview.ArrayX + " " + a.cubeview.ArrayY);
						//}
						MatchingFallenNodesIndex = new Array();
						FoundQuad = false;
						for (i = 0; i < TestNodes.length; i++)
							for (j = 0; j < theFallenNodes.length; j++)
							{
								if (theFallenNodes[j].ArrayX == TestNodes[i].ArrayX)
									if (theFallenNodes[j].ArrayY == TestNodes[i].ArrayY)
										MatchingFallenNodesIndex.push(j);
							}
						for each (var Index:int in MatchingFallenNodesIndex)
							theFallenNodes.splice(Index, 1);
						AddQuadBlock(TestNodes);
						CheckNodesInBlockSet(theMapArray,mClearQuadBlockViewArray[mClearQuadBlockViewArray.length - 1]);
					}
					else
						FallenNodeQuad = false;
				}
				else
					FallenNodeQuad = false;
			}
			
			var OtherBlockSetBlocks:Array;
			var CurrentObject:Object;
			var OtherObject:Object;
			
			// Now it is time to check for the Cross Blocks and their Blockset owners. 
			for (i = 0; i < mCrossBlocks.length; i++)
			{
				//trace("Crossblocks found " + mCrossBlocks[i].ArrayX + " " + mCrossBlocks[i].ArrayY);
				if (mCrossBlocks[i].mXBlock == false )
				{
					mCrossBlocks.splice(i, 1);
					i--;
				}
				else
					if (mCrossBlocks[i].NodeObject != null)//Do the crossblocks belong to a quad
					{
						var BlockSet:ClearQuadBlockView = mCrossBlocks[i].NodeObject;
						CheckNodesInBlockSet(theMapArray, BlockSet);
					}
			}
			//trace("Final Crossblocks length " + mCrossBlocks.length)
			while (theFallenNodes.length > 0)
				theFallenNodes.pop();
		//	trace("mClearQuadBlockViewArray        " + mClearQuadBlockViewArray.length)
		}
		
		private function MatchCheck(theNodes:Array):Boolean
		{
			var i:int;
			var j:int;
			var Fill:Boolean = false;
			if (theNodes.length != mMapProperties.MatchSize * mMapProperties.MatchSize)
			{
				return false;
			}
			if (theNodes[0].cubeview == null)
			{
				//Empty Cube!
				return false;
			}
			if (theNodes[0].cubeview.Active)
			{
				//Active cube
				return false;
			}
			
			var RefType:int = theNodes[0].cubeview.BlockType;
			
			//checking fallennodes
			for (i = 0; i < theNodes.length; i++)
			{
				if (theNodes[i].cubeview != null)
				{
					if (theNodes[i].cubeview.NodeObject != null)
					{
						//This already belongs to a node!
						return false;
					}
					if (theNodes[i].cubeview.BlockType == RefType) // blocktype is of reftype color and both are not cross clear
					{
						
					}
					else //blocktype is of a completely different color
					{
						//not a match!
						return false;
					}
				}
				else 
				{	
					//Empty Cube!
					return false;
				}
			}
			//Match in fallennodes
		///	for (i = 0; i < theNodes.length; i++)
		///	{
		///		trace(theNodes[i].ArrayX + " " +theNodes[i].ArrayY )
		///	}
			return true;
		}
		private function CheckNodesInBlockSet(theMapArray:Array, BlockSet:ClearQuadBlockView):void
		{
			var theNode:MapNode;
			var theNode2:MapNode;
			var Ref:int; // Reference to matching fallingnodes
			var RefCount:int;
			var NodeCount:int;
			var Match:Array;///if this equals to the MatchSize, there is a neighbouring match
			var MatchCount:int;
			var OtherBlockSetBlocks:Array;
			var OtherBlockSet:Object;
			var CurrentObject:Object;
			var OtherObject:Object;
			var Reference:Array; //reference to all the fallennode indexes
			Match = new Array();///if this equals to the MatchSize, there is a neighbouring match
			OtherBlockSetBlocks = new Array();
			Reference = new Array(); //reference to all the fallennode indexes
			var MatchQuad:Boolean = true;
			var j:int;
			var k:int;
			var l:int;
			//Check if new fallen block affects the QuadBlockView, and see if it can be absorbed inside it
			//Like water droplet
			
				for (j = 0; j < BlockSet.QuadNodes.length; j++)
				{
					if (BlockSet.QuadNodes[j] == null)
					{
						BlockSet.QuadNodes.splice(j, 1);
						j--;
					}
				}

				for (j = 0; j < BlockSet.QuadNodes.length; j++)
				{
					var ArrayX:int = BlockSet.QuadNodes[j].ArrayX;
					var ArrayY:int = BlockSet.QuadNodes[j].ArrayY;
					OtherBlockSetBlocks = new Array();
					CurrentObject = BlockSet.QuadNodes[j].NodeObject;
					
					if (BlockSet.QuadNodes[j].ArrayX + mMapProperties.MatchSize - 1 <mMapProperties.MapWidth)
						BlockSetSubFunction(BlockSet.QuadNodes[j], theMapArray[BlockSet.QuadNodes[j].ArrayX + 1][BlockSet.QuadNodes[j].ArrayY].cubeview,BlockSet,OtherBlockSetBlocks);
					if (BlockSet.QuadNodes[j].ArrayX -  mMapProperties.MatchSize + 1>= 0)
						BlockSetSubFunction(BlockSet.QuadNodes[j], theMapArray[BlockSet.QuadNodes[j].ArrayX - 1][BlockSet.QuadNodes[j].ArrayY].cubeview,BlockSet,OtherBlockSetBlocks);
					if (BlockSet.QuadNodes[j].ArrayY + mMapProperties.MatchSize - 1<mMapProperties.MapHeight)
						BlockSetSubFunction(BlockSet.QuadNodes[j], theMapArray[BlockSet.QuadNodes[j].ArrayX][BlockSet.QuadNodes[j].ArrayY + 1].cubeview,BlockSet,OtherBlockSetBlocks);
					if (BlockSet.QuadNodes[j].ArrayY -  mMapProperties.MatchSize + 1 >= mMapProperties.MatchSize)
						BlockSetSubFunction(BlockSet.QuadNodes[j], theMapArray[BlockSet.QuadNodes[j].ArrayX][BlockSet.QuadNodes[j].ArrayY - 1].cubeview,BlockSet,OtherBlockSetBlocks);

					for (k = 0; k < OtherBlockSetBlocks.length; k++)
					{
						OtherObject = OtherBlockSetBlocks[k].NodeObject;
						OtherObject.ClearGraphics();
						for (l = 0; l < OtherObject.QuadNodes.length; l++)
						{
							OtherObject.QuadNodes[l].SetNodeObject(CurrentObject); //This is the new owner of the blocksets
							BlockSet.AddNode(OtherObject.QuadNodes[l]);
						}
						while (OtherObject.QuadNodes.length > 0)
							OtherObject.QuadNodes.pop();
					}
			}
			BlockSet.DrawGraphics();

		}
		private function BlockSetSubFunction(BlockSetNode:CubeView, BlockSetNode2:CubeView, BlockSet:ClearQuadBlockView,OtherBlockSetBlocks:Array):void
		{
			var k:int;
			if (BlockSetNode2 == null)
				return;
			if (BlockSetNode == null)
				return;
				if (BlockSetNode2.Active)
					return;
				if (BlockSetNode2.BlockType == BlockSetNode.BlockType){
				if (BlockSetNode2.NodeObject == null)
				{
					BlockSetNode2.mClear = BlockSetNode.mClear; // if BlockSetNode2 is not part of a quad, Set it to be a clear blocktype
					//if (BlockSetNode2.mClear )
					
						//trace("Added to clear " + BlockSetNode2.ArrayX + " " + BlockSetNode2.ArrayY + " " + BlockSetNode2.mClear);
					BlockSet.AddNode(BlockSetNode2); 
					
				}	
				else
				{
					try
					{
						if (BlockSetNode2.NodeObject.valueOf() 
							== BlockSetNode.NodeObject.valueOf())
							{
								///trace(BlockSetNode.ArrayX +" " + BlockSetNode.ArrayY);
								///trace(BlockSetNode2.ArrayX +" "+ BlockSetNode2.ArrayY);	
							}
					}
					catch(errObject:Error)
					{
							///trace("Error " + BlockSetNode.ArrayX +" " + BlockSetNode.ArrayY);
							///trace("Error2 "+BlockSetNode2.ArrayX +" "+ BlockSetNode2.ArrayY);
					}
					if (BlockSetNode.NodeObject == null)
					{
						trace("NULL BLocksetnode " + BlockSetNode.ArrayX + " " + BlockSetNode.ArrayY)
					}
					if (BlockSetNode2.NodeObject.valueOf() 
						== BlockSetNode.NodeObject.valueOf())
						if (BlockSetNode2.NodeObject !== BlockSetNode.NodeObject)
						{
							///trace(BlockSetNode.ArrayX +" " + BlockSetNode.ArrayY);
							///trace(BlockSetNode2.ArrayX +" " + BlockSetNode2.ArrayY);
							if (OtherBlockSetBlocks.length > 0)
							{
								for (k = 0; k < OtherBlockSetBlocks.length; k++)
								{
									if (OtherBlockSetBlocks[k].NodeObject === BlockSetNode2.NodeObject)
										break;
								}
								if (k == OtherBlockSetBlocks.length)
								{
									///trace("Added OtherBlock "+BlockSetNode2.ArrayX +" "+ BlockSetNode2.ArrayY);
									OtherBlockSetBlocks.push(BlockSetNode2);
								}
							}
							else
							{
								///trace("Added First OtherBlock "+BlockSetNode2.ArrayX +" "+ BlockSetNode2.ArrayY);
								OtherBlockSetBlocks.push(BlockSetNode2);
							}
						}
						else
						{
							///trace("Non matching Node Object")
							///trace(BlockSetNode.ArrayX + " " + BlockSetNode.ArrayY);
							///trace(BlockSetNode2.ArrayX + " " + BlockSetNode2.ArrayY);	
							///trace("-----------------------")
						}
					}
				}
				else
				{
					//trace("Non matching block")
					//trace(BlockSetNode.ArrayX +" " + BlockSetNode.ArrayY);
					//trace(BlockSetNode2.ArrayX +" " + BlockSetNode2.ArrayY);	
					//trace("-----------------------")
				}
			
		}
		public function get QuadBlockViews():Array
		{
			return mClearQuadBlockViewArray;
		}
		public function Reset():void
		{
			var i:int;
			var j:int;
			if (mClearQuadBlockViewArray.length > 0)
				for (i = 0; i < mClearQuadBlockViewArray.length; i++ )
				{
					mClearQuadBlockViewArray[i].RemoveClearBlock(false);
				}
		}
		public function valueOf(): Object
		{
			return 1;
		}
	}
	
}