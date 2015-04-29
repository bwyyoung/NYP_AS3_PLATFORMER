package Minigames.Lumines.Observer
{

	/**
	* ...
	* @author $(DefaultUser)
	*/
	import Minigames.Lumines.View.CubeView;
	import Managers.GraphicsManager;
	import Minigames.Lumines.Observer.MapNode;
	import Minigames.Lumines.Properties.LuminesProperties;
	public class Cube 
	{
		private var mCubeViews:Array;
		private var mCount:int = 0;
		private var mOrder:Array;
		//TODO: Find way of dynamically changing the blocktype to other movieclip classes
		public function Cube(MapWidth:int, MapHeight:int) 
		{
			mOrder = new Array();
			mOrder.push(LuminesProperties.RED);
			mOrder.push(LuminesProperties.GREEN);
			mOrder.push(LuminesProperties.BLUE);
			mOrder.push(LuminesProperties.YELLOW);
			mOrder.push(LuminesProperties.XYELLOW);
			mOrder.push(LuminesProperties.XBLUE);
			mOrder.push(LuminesProperties.XGREEN);
			mOrder.push(LuminesProperties.XRED);
			var i:int;
			mCubeViews = new Array(MapWidth * MapHeight);
			for (i = 0; i < mCubeViews.length; i++ )
			{
				mCubeViews[i] = new CubeView(0);
			}
		}
		public function Init():void
		{

		}
		public function PauseCubeAnimation():void
		{
			for each( var temp:CubeView in mCubeViews)
			{
				temp.StopAnimation();
			}
		}
		public function Cleanup():void
		{
			for each (var temp:CubeView  in mCubeViews)
			{
				temp.RemoveFromMap();
			}
		}
		public function GetFreeCube():CubeView
		{
			var FreeCube:CubeView;
			var Chance:int = Math.random() * 100;
			var BlockType:int;
			if (Chance <= 65)
			{
				var Divide:int =  Math.random() * 100 ;
				var Quarter:int;
				var QuarterLimit:int;
				for (i= 0; i < LuminesProperties.NUMVARIETIES; i++)
				{
					Quarter = i * 100 / LuminesProperties.NUMVARIETIES;
					QuarterLimit = i * 100 / LuminesProperties.NUMVARIETIES + 100 / LuminesProperties.NUMVARIETIES;
					if (Divide >= Quarter && Divide < QuarterLimit)
					{
						break;
					}
				}
				BlockType = mOrder[i];
			}
			else
			{
				Divide =  Math.random() * 100 ;
				
				if (mCount > 3)
				{
					for (i= 0; i <LuminesProperties.NUMXVARIETIES; i++)
					{
						Quarter = i * 100 / LuminesProperties.NUMXVARIETIES;
						QuarterLimit = i * 100 / LuminesProperties.NUMXVARIETIES + 100 / LuminesProperties.NUMXVARIETIES;
						if (Divide >= Quarter && Divide < QuarterLimit)
						{
							break;
						}
					}
					BlockType = mOrder[i + LuminesProperties.NUMVARIETIES];
					mCount = 0;
				}
				else
				{
					for (i= 0; i < LuminesProperties.NUMVARIETIES; i++)
					{
						Quarter = i * 100 / LuminesProperties.NUMVARIETIES;
						QuarterLimit = i * 100 / LuminesProperties.NUMVARIETIES + 100 / LuminesProperties.NUMVARIETIES;
						if (Divide >= Quarter && Divide < QuarterLimit)
						{
							break;
						}
					}
					BlockType = mOrder[i];
					mCount++;
				}
				
			}
			var i:int;
			for (i = 0; i < mCubeViews.length; i++)
			{
				if (!mCubeViews[i].IsRendering)
				{
					mCubeViews[i].SetBlockType(BlockType);
					if (BlockType % 2 == 0)
						mCubeViews[i].mXBlock = true;
					else
						mCubeViews[i].mXBlock = false;
					FreeCube = mCubeViews[i];
					break;
				}
			}
			return FreeCube;
		}
		
	}
	
}