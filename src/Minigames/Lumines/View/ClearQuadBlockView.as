package Minigames.Lumines.View 
{
	import Minigames.Lumines.Observer.MapNode;
	import Managers.GraphicsManager;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.View.DrawQuadView;
	import flash.display.Sprite;
	import Managers.GUIManager;
	import GraphicalUserInterface.LuminesGUI;
	import GameSound.SoundData;
	import Managers.SoundManager;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	
	public class ClearQuadBlockView 
	{		
		private var mNewQuadSound:SoundData;

		private var HighX:int = 0;
		private var LowX:int = 0;
		private var mQuad:Array; // array of cubeviews
		private var mSquares:Array; // Array of detected cubeviews

		private var mMapProperties:LuminesProperties = LuminesProperties.GetInstance();
		public function ClearQuadBlockView(theQuad:Array) 
		{
			mNewQuadSound = SoundManager.GetInstance().GetSound("QuadBlock","FX");
			mSquares = new Array();
			mQuad = new Array();
			for each(var QuadNode:MapNode in theQuad)
			{
				AddNode(QuadNode.cubeview);			
			}
			DrawGraphics();
		}
		public function AddNode(theNode:CubeView):void
		{
			theNode.SetNodeObject(this);
			mQuad.push(theNode);
			var i:int;
			for (i = 0; i < mQuad.length; i++)
			{
				if (mQuad[i].X + mMapProperties.BlockSize > HighX)
					HighX = mQuad[i].ArrayX + mMapProperties.BlockSize;
				if (mQuad[i].X + mMapProperties.BlockSize < LowX)
					LowX = mQuad[i].ArrayX + mMapProperties.BlockSize;
			}
			mNewQuadSound.Play();
		}
		public function Cleanup():void
		{
			ClearGraphics();
		}
		public function DrawGraphics():void
		{
			ClearGraphics();
			MakeQuads();
			var i:int;
			for (i = 0; i < mQuad.length; i++)
			{
				if (mQuad[i].mQuadClear)
					if (mQuad[i].mXBlock)
						break;
			}
			if (i < mQuad.length)//cross blocks have been found
			{
				for (i = 0; i < mQuad.length; i++)
				{
					if (mQuad[i].mQuadClear)
					{
						mQuad[i].NodeObject = this;
						mQuad[i].mClear = true;
					}
				}
			}
			FilterQuads();
		}
		public function ClearGraphics():void
		{
			var i:int;
			for (i = 0 ; i < mSquares.length; i++)
				mSquares[i].RemoveQuad();
			while (mSquares.length>0)
				mSquares.pop();
		}
		public function RemoveNode(theCube:CubeView):void
		{
			var i:int;
			for (i = 0; i < mQuad.length; i++)
			{
				if (mQuad[i] === theCube)
				{
					mQuad[i].NodeObject = null;
					mQuad.splice(i, 1);
				}
			}
		
			ClearGraphics();
		}
		public function get QuadNodes():Array
		{
			return mQuad;
		}
		private function MakeQuads():void
		{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var X:int;
			var Y:int;
			var QuadArray:Array;
			for (i = 0; i <  mQuad.length; i++)
			{
				QuadArray = new Array();
				X = mQuad[i].ArrayX;
				Y = mQuad[i].ArrayY;
				for (j = 0; j <  mQuad.length; j++)
				{
					if (i != j)
					{
						for (k = 0; k < mMapProperties.MatchSize; k++)
							for (l = 0; l < mMapProperties.MatchSize; l++)
							{
								if (X + k == mQuad[j].ArrayX)
									if (Y + l == mQuad[j].ArrayY)
									{
										var m:int;
										for (m = 0; m < QuadArray.length; m++ )
										{
											if (QuadArray[m].ArrayX == mQuad[j].ArrayX)
												if (QuadArray[m].ArrayY == mQuad[j].ArrayY)
													break;
										}
										if (m == QuadArray.length)
										{
											QuadArray.push(mQuad[j]);
										}
									}
							}
						if (QuadArray.length == mMapProperties.MatchSize*mMapProperties.MatchSize - 1)
						{
							QuadArray.push(mQuad[i]);
							for each (var cube:CubeView in QuadArray)
							{
								cube.NodeObject = this;
								cube.mQuadClear = true;
							}
							mSquares.push(new DrawQuadView(QuadArray));
							while (QuadArray.length > 0)
								QuadArray.pop();
						}
					}
				}
			}
		}
		//filter extra quads that have been seen as not part of a matching square group
		private function FilterQuads():void
		{
			var i:int;
			var ReferenceArray:Array = new Array();
			for (i = 0; i <  mQuad.length; i++)
			{
				if ((mQuad[i].mQuadClear == false)&&(mQuad[i].mClear == false))
				{
					ReferenceArray.push(i);
				}
				else if ((mQuad[i].mClear == true)&&(mQuad[i].mQuadClear == false))
				{
					var temp:Array = new Array();
					temp.push(mQuad[i]);
					mSquares.push(new DrawQuadView(temp));
				}
			}
			for each (var a:int in ReferenceArray)
			{
				mQuad[a].NodeObject = null;
				mQuad[a].SetDefaultParams();
				mQuad[a].RemoveMask();
				mQuad.splice(a, 1);
				//RemoveNode(mQuad[a]);
				for (i = 0; i < ReferenceArray.length; i++)
				{
					if (ReferenceArray[i] > a)
						ReferenceArray[i]--;
				}
			//	mQuad.splice(a, 1);
			}
			while (ReferenceArray.length > 0)
				ReferenceArray.pop();

			var IsClear:Boolean = false;
			var j:int;
		}
		public function ClearCubes(theMapArray:Array):void
		{
			var i:int;
			var j:int;
			var RemovedCubesIndex:Array = new Array();
			
			if (mQuad.length > 0)
			{
				for (i = 0; i < mQuad.length; i++)
				{
					if (mQuad[i].mCollide)
					{
						RemovedCubesIndex.push(i);
					}
					mQuad[i].NodeObject = null;
					mQuad[i].SetDefaultParams();
				}
				if (RemovedCubesIndex.length > 0)
				{
					for each (var a:int in RemovedCubesIndex)
					{
						//this clears away the cube from the map. add score here
						var curview:CubeView = theMapArray[mQuad[a].ArrayX][mQuad[a].ArrayY].cubeview;
						var curscore:int = (GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).GetScore(curview.mBlockType);
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).SetScore(curview.mBlockType, curscore + 1);
						
						theMapArray[mQuad[a].ArrayX][mQuad[a].ArrayY].ClearCube();
					}
					for each (var b:int in RemovedCubesIndex)
					{
						mQuad.splice(b, 1);
						for (j = 0; j < RemovedCubesIndex.length; j++)
							if (RemovedCubesIndex[j] > b)
								RemovedCubesIndex[j]--;
					}
				}
				//Check for matching quads and make them form squares which make them mquadclear
				DrawGraphics();
			}
		}
		public function valueOf():Object
		{
			return 1;
		}

	}
	
}