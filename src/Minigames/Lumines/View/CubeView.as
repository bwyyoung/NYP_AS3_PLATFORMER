package Minigames.Lumines.View 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Managers.GraphicsManager;
	import Managers.EntityManager;
	import Animations.AnimationSet;
	
	//this class draws each individual cube in the game
	public class CubeView 
	{
		private var mBlockAnimationSet:AnimationSet;
		
		private var mBlockMask:Sprite;
		private var mborderColor:uint  = 0xffffff;
		private var mbgColor3:uint		 = 0xaba9ac; //grey
		private var mborderSize2:uint   = 2;
		public var IsRendering:Boolean = false;
		public var mBlockType:int = 0;
		private var mArrayX:int; // Array Index X
		private var mArrayY:int; // Array Index Y
		
		public var mActive:Boolean = false;
		public var mXBlock:Boolean = false;
		public var mQuadClear:Boolean = false; // Blocks that are to be cleared because of a matching quad
		public var mClear:Boolean = false; //Blocks that are to be cleared because of a cross clear block
		public var mCollide:Boolean = false; // has the timeline collided with the cube?
		public var NodeObject:Object = null; // The Object that this cube belongs to

		
		public function CubeView(BlockType:int = 0) 
		{
			mBlockAnimationSet = null;
			NodeObject = null;
			mBlockType = BlockType;
			SetBlockType(BlockType);
			mBlockMask = new Sprite();
		}

		public function SetNodeObject(theObject:Object):void
		{
			NodeObject = theObject;
		}
		public function UnsetNodeObject():void
		{
			NodeObject = null;
		}
		public function RemoveFromQuad():void
		{
			mActive = false;
		}
		public function SetBlockType(BlockType:int):void
		{
			var rOffset:Number;
            var bOffset:Number;
			mBlockType = BlockType;
			switch (BlockType)
			{
				case LuminesProperties.RED:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("RedBlock");
				break;
				case LuminesProperties.GREEN:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("GreenBlock");
				break;
				case LuminesProperties.BLUE:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("BlueBlock");
				break;
				case LuminesProperties.YELLOW:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("YellowBlock");
				break;
				case LuminesProperties.XRED:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("RedXBlock");
				break;
				case LuminesProperties.XGREEN:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("GreenXBlock");
				break;
				case LuminesProperties.XBLUE:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("BlueXBlock");
				break;
				case LuminesProperties.XYELLOW:
					mBlockAnimationSet = EntityManager.GetInstance().GetAnimationSet("YellowXBlock");
				break;
				default:
				break;
			}
		}
		public function SetPosition(X:int, Y:int, ArrayX:int = -1, ArrayY:int = -1):void
		{
			if (X != mBlockAnimationSet.mX)
			{
				X += mBlockAnimationSet.Width / 2;
			}
			if (Y != mBlockAnimationSet.mY)
			{
				Y += mBlockAnimationSet.Height / 2;
			}
			mBlockAnimationSet.SetPosition(X, Y);
			if (ArrayX != -1 && ArrayY != -1)
			{
				mArrayX = ArrayX;
				mArrayY = ArrayY;
			}
		}
		public function get ArrayX():int
		{
			return mArrayX;
		}
		public function get ArrayY():int
		{
			return mArrayY;
		}
		public function get X():int
		{
			return mBlockAnimationSet.mX - mBlockAnimationSet.Width / 2;
		}
		public function get Y():int
		{
			return mBlockAnimationSet.mY - mBlockAnimationSet.Height/2;
		}
		public function get BlockType():int
		{
			return mBlockType;
		}
		public function get Color():uint
		{
			return mBlockAnimationSet.mHighlightColor;
		}
		public function get Active():Boolean
		{
			return mActive;
		}
		public function RemoveFromMap():void
		{
			mArrayX = 0;
			mArrayY = 0;
			NodeObject = null;
			SetDefaultParams();
			RemoveMask();
			UnRender();
		}
		public function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			IsRendering = true;
			if (mBlockAnimationSet != null)
				mBlockAnimationSet.Render(theDisplayObjectContainer);
		}
		public function StopAnimation():void
		{
			if (mBlockAnimationSet != null)
				mBlockAnimationSet.Stop();
		}
		
		public function UnRender():void
		{
			IsRendering = false;
			if (mBlockAnimationSet != null)
				mBlockAnimationSet.UnRender();
		}
		public function SetDefaultParams():void
		{
			mActive = false;
			mQuadClear = false;
			mClear = false;
			mCollide = false;
		}
		public function RemoveMask():void
		{
			if (GraphicsManager.GetInstance().ForeGround.contains(mBlockMask))
				GraphicsManager.GetInstance().ForeGround.removeChild(mBlockMask);
		}
		public function AddToMap():void
		{
			Render(GraphicsManager.GetInstance().MapGround);
		}
		//mark the cube for removal
		public function MarkforRemoval():void
		{
			GraphicsManager.GetInstance().ForeGround.addChildAt(mBlockMask,0);
			mCollide = true;
			mBlockMask.graphics.clear();
			mBlockMask.graphics.beginFill(mbgColor3);
			mBlockMask.graphics.lineStyle(mborderSize2, mborderColor);
			mBlockMask.graphics.drawRoundRect(X, Y, 
			LuminesProperties.GetInstance().BlockSize , LuminesProperties.GetInstance().BlockSize,
			LuminesProperties.GetInstance().BlockSize/2,LuminesProperties.GetInstance().BlockSize/2);
			mBlockMask.graphics.endFill();
		}
		
	}
	
}