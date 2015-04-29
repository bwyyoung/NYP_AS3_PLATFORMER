package Minigames.Lumines.Observer  
{

	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import Managers.GraphicsManager;
	import Minigames.Lumines.View.CubeView;
	
	public class MapNode 
	{
		private var mArrayX:int; // Array Index X
		private var mArrayY:int; // Array Index Y
		private var mX:int; // Global X position 
		private var mY:int; // Global X position
		private var mCubeView:CubeView = null;
		private var mOccupied:Boolean = false;
		
		public function MapNode(X:int,Y:int, ArrayX:int,ArrayY:int)
		{
			mX = X;
			mY = Y;
			mArrayX = ArrayX;
			mArrayY = ArrayY;
		}
		public function AttachCube(theCube:CubeView, IsQuadCube:Boolean = false):void
		{
			
			mCubeView = theCube;
			try
			{
				mCubeView.SetPosition(mX, mY, mArrayX, mArrayY);
			}
			catch (errObject:Error)
			{
				trace(errObject.name + " " + errObject.message + " " + errObject.errorID);
				trace(mArrayX + " " + mArrayY);
			}
			if (!mCubeView.IsRendering)
				mCubeView.AddToMap();
			mOccupied = true;
			mCubeView.mActive = IsQuadCube;
		}
		public function ShiftCube(theCube:CubeView, IsQuadCube:Boolean = false):void
		{
			mCubeView = theCube;
			if (!mCubeView.IsRendering)
				mCubeView.AddToMap();
			mOccupied = true;
			mCubeView.mActive = IsQuadCube;
		}

		public function SetCubeToNewNode(FinalNode:MapNode,IsQuadCube:Boolean = false):void
		{
			mOccupied = false;
			FinalNode.SetCube(mCubeView);
			mCubeView = null;
		}
		private function SetCube(theCube:CubeView):void
		{
			mCubeView = theCube;
			mOccupied = true;
		}
		public function ClearCube():void
		{
			if (mCubeView != null)
				if (mCubeView.IsRendering)
				{
					mCubeView.RemoveFromMap();
					mOccupied = false;
					mCubeView = null;
				}
		}
		public function DeAllocateCube():void
		{
			mOccupied = false;
			mCubeView = null;
		}
		public function get cubeview():CubeView
		{
			return mCubeView;
		}
		public function get Occupied():Boolean
		{
			return mOccupied;
		}
		public function get X():int
		{
			return mX;
		}
		public function get Y():int
		{
			return mY;
		}
		public function get ArrayX():int
		{
			return mArrayX;
		}
		public function get ArrayY():int
		{
			return mArrayY;
		}


	}
	
	
}