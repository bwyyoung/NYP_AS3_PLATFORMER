package Minigames.Lumines.Observer 
{
	import fl.motion.CustomEase;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.Observer.MapNode;
	import Minigames.Lumines.Observer.Cube;
	import Minigames.Lumines.View.CubeView;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class Stack 
	{
		private var mCube:Cube;
		private var mStackArray:Array;
		private var mMovingCubesArray:Array;
		private var mMapProperties:LuminesProperties = LuminesProperties.GetInstance();
		public function Stack() 
		{

		}
		public function PauseCubes():void
		{
			mCube.PauseCubeAnimation();
		}
		public function ResumeCubes():void
		{
			for each(var temp:MapNode in mStackArray)
			{
				if (temp.cubeview != null)
					temp.cubeview.AddToMap();
			}
		}
		public function Init():void
		{
			mCube = new Cube(mMapProperties.MapWidth,mMapProperties.MapHeight);
			var i:int;
			var j:int;
			mMovingCubesArray = new Array();
			mStackArray = new Array(mMapProperties.StackSize*mMapProperties.QuadSize);
			for (i = 0; i < mMapProperties.QuadSize; i++)//Acting as X Axis
			{
				mStackArray[i] = new Array(mMapProperties.QuadSize*mMapProperties.StackSize);
				for (j = 0; j < mMapProperties.QuadSize*mMapProperties.StackSize; j++ )//Acting as Y Axis
				{
					var l:int = j/mMapProperties.QuadSize;
					mStackArray[i][j] = new MapNode(mMapProperties.StackOffsetX + mMapProperties.BlockSize * i, 
					mMapProperties.StackOffsetY + mMapProperties.BlockSize * j + mMapProperties.StackSpace * l,i, j);
					mStackArray[i][j].AttachCube(mCube.GetFreeCube());
				}
			}
		}
		public function Cleanup():void
		{
			for (var j:int = mMapProperties.QuadSize; j < mMapProperties.QuadSize*mMapProperties.StackSize; j++)//Y
			{
				for (var i:int = 0;  i < mMapProperties.QuadSize; i++)//X
				{
					mStackArray[i][j].ClearCube();
				}
			}
			while (mStackArray.length > 0)
			{
				mStackArray.pop();
			}
			mCube.Cleanup();
		}
		public function GetTopStack():Array
		{
			var i:int;
			var j:int;
			var CubeViewBuffer:Array = new Array();
			
			//Take the top quad from the array
			for (j = 0;  j < mMapProperties.QuadSize; j++)//Y
			{
				for (i = 0;  i < mMapProperties.QuadSize; i++)//X
				{
					CubeViewBuffer.push(mStackArray[i][j].cubeview);
				}
			}
			//shift the bottum quads up
			for (j = mMapProperties.QuadSize; j < mMapProperties.QuadSize*mMapProperties.StackSize; j++)//Y
			{
				for (i = 0;  i < mMapProperties.QuadSize; i++)//X
				{
					var CubeViewBuffer2:CubeView = mStackArray[i][j].cubeview;
					//mStackArray[i][j].ClearCube();
					mStackArray[i][j].SetCubeToNewNode(mStackArray[i][j - mMapProperties.QuadSize]);
					//mStackArray[i][j - mMapProperties.QuadSize].AttachCube(CubeViewBuffer2);
					mMovingCubesArray.push(mStackArray[i][j - mMapProperties.QuadSize]);
				}
			}

			return CubeViewBuffer;
		}
		public function Update():void
		{
			var i:int;
			var j:int;
			var Increment:Number;
			if (mMovingCubesArray.length > 0)
			{
				for (i = 0; i < mMovingCubesArray.length; i++ )
				{
					Increment = (mMovingCubesArray[i].Y - mMovingCubesArray[i].cubeview.Y) * mMapProperties.AnimSpeed;
					if (Increment > -1)
						Increment =  -1;
					mMovingCubesArray[i].cubeview.SetPosition( mMovingCubesArray[i].cubeview.X,
					mMovingCubesArray[i].cubeview.Y + Increment); 
					if (mMovingCubesArray[i].Y >= mMovingCubesArray[i].cubeview.Y  )//- mMapProperties.BlockSize)
					{
						mMovingCubesArray[i].cubeview.SetPosition(mMovingCubesArray[i].X,mMovingCubesArray[i].Y);
						mMovingCubesArray.splice(i, 1);
					}
				}
			}
			else
			{
				i = 0;
				j = mMapProperties.QuadSize * mMapProperties.StackSize - mMapProperties.QuadSize;
				//Generate new quad of cubes
				if (mStackArray[i][j].Occupied == false)
					for (j =  mMapProperties.QuadSize * mMapProperties.StackSize - mMapProperties.QuadSize; 
						j < mMapProperties.QuadSize*mMapProperties.StackSize; j++)//Y
					{	
						for (i = 0;  i < mMapProperties.QuadSize; i++)//X
						{
							var CubeViewBuffer3:CubeView = mCube.GetFreeCube();
								mStackArray[i][j].AttachCube(CubeViewBuffer3);
						}
					}
			}
		}
	}
	
}