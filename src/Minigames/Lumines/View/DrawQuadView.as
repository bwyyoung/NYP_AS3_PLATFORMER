package Minigames.Lumines.View 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import Managers.GraphicsManager;
	import Minigames.Lumines.Observer.MapNode;
	import flash.display.Sprite;
	import Minigames.Lumines.Properties.LuminesProperties;
	
	
	//this class draws a colored curved rectangle to highlight a matching quad
	public class DrawQuadView 
	{
		private var mBlockMask:Sprite;
		private var mborderColor:uint  = 0xffffff;
		private var mbgColor1:uint       = 0x3a9eff; //blue
		private var mbgColor2:uint		 = 0xe94133; //red
		private var mbgColor3:uint		 = 0xaba9ac; //grey
		private var mborderSize2:uint   = 2;
		
		private var mMapProperties:LuminesProperties = LuminesProperties.GetInstance();
		
		private var HighX:int = -1; 
		private var HighY:int = -1;
		private var LowX:int = -1;
		private var LowY:int = -1;
		private var HighLightedQuads:Array; //These are cubeviews, not MapNodes
		//for matching squares, this stores the top left and bottom right
		//for singles, it stores one.
		public function DrawQuadView(TheCubeViews:Array)
		{
			HighLightedQuads = new Array();
			var i:int;
			for (i = 0; i < TheCubeViews.length; i++)
			{
				if (LowX == -1)
				{
					LowX = TheCubeViews[i].X;
				}
				if (LowY == -1)
				{
					LowY = TheCubeViews[i].Y;
				}
				if (TheCubeViews[i].X + mMapProperties.BlockSize> HighX)
				{
					HighX = TheCubeViews[i].X + mMapProperties.BlockSize;
				}
				if (TheCubeViews[i].Y + mMapProperties.BlockSize> HighY)
				{
					HighY = TheCubeViews[i].Y + mMapProperties.BlockSize;
				}
				if (TheCubeViews[i].X < LowX)
				{
					LowX = TheCubeViews[i].X;
				}
				if (TheCubeViews[i].Y < LowY)
				{
					LowY = TheCubeViews[i].Y;
				}
				HighLightedQuads.push(TheCubeViews[i]);
			}
			mBlockMask = new Sprite();
			DrawQuad();
		}
		public function DrawQuad():void
		{
			mBlockMask.graphics.beginFill(HighLightedQuads[0].Color);
			mBlockMask.graphics.lineStyle(mborderSize2, mborderColor);
			
			mBlockMask.graphics.drawRoundRect(LowX, LowY, HighX - LowX , HighY - LowY, (HighX - LowX )/2, (HighY - LowY)/2);
			mBlockMask.graphics.endFill();
			if (GraphicsManager.GetInstance().MapGround.contains(mBlockMask) == false) 
				GraphicsManager.GetInstance().MapGround.addChild(mBlockMask);
		}
		public function ReDrawQuad(TimeLineX:int = -1):void
		{
			var i:int;
			for (i = 0; i < HighLightedQuads.length; i++)
			{
				if (HighLightedQuads[i].X > HighX)
				{
					HighX = HighLightedQuads[i].X;
				}
				if (HighLightedQuads[i].Y > HighY)
				{
					HighY = HighLightedQuads[i].Y;
				}
				if (HighLightedQuads[i].X < HighX)
				{
					LowX = HighLightedQuads[i].X;
				}
				if (HighLightedQuads[i].Y < HighY)
				{
					LowY = HighLightedQuads[i].Y;
				}
			}
			if ((TimeLineX != -1)&&(TimeLineX < HighX))
				LowX = TimeLineX;
			DrawQuad();
		}
		public function Cleanup():void
		{
			RemoveQuad();
		}
		public function RemoveQuad():void
		{
			if (GraphicsManager.GetInstance().MapGround.contains(mBlockMask) == true) 
				GraphicsManager.GetInstance().MapGround.removeChild(mBlockMask);
		}	
	}
	
}