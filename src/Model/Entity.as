package Model 
{
	import Animations.AnimationSet;
	import flash.display.AVM1Movie;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import Menus.MapSize;
	import Properties.GameProperties;
	import Managers.GraphicsManager;
	import View.MapNode;
	
	import flash.utils.*;
	import Item.ItemBox;
	import Item.Shell;
	Item.ItemBox;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class is the base class for all entities in the game
	public class Entity 
	{
		public var mX:Number; //the entity's x and y coordinates
		public var mY:Number;
		
		protected var MinX:int;
		protected var MaxX:int;
		protected var mAnimationSet:AnimationSet;//these are the animations that my entity has. it only has one set of animations
		public var mCurrentState:String; // the entity's current state
		public var mCurDirection:Boolean;//the entity's current direction
		public var mControl:Boolean; //can the entity be controlled? like by the player for example?
		public var mDead:Boolean; //is the entity dead
		public var mXSpeed:Number; //the entity's speed
		public var mYSpeed:Number;
		
		protected var Right:Number; //the direction in which a colliding entity may have collided, basically, its extreme x and y coordinates
		protected var Left:Number;
		protected var Up:Number;
		protected var Down:Number;		
	
		public var COLLIDEXLEFT:Boolean; //did the entity have a recent collision
		public var COLLIDEXRIGHT:Boolean;
		public var COLLIDEYTOP:Boolean;
		public var COLLIDEYDOWN:Boolean;
		
		protected var square:Sprite=new Sprite();

		public function Entity(theAnimations:AnimationSet) 
		{
			MaxX = MinX = 0;
			GraphicsManager.GetInstance().MapGround.addChild(square);
			mControl = true;
			mAnimationSet = theAnimations;
		}
		public function Init():void
		{
			mControl = true;
		}
	
		public function CleanUp():void
		{
			//remove the entity from the map
			if (GraphicsManager.GetInstance().MapGround.contains(square))
				GraphicsManager.GetInstance().MapGround.removeChild(square);
			mAnimationSet.Stop();
			mAnimationSet.UnRender();
		}
		//set the entity's state, and make it animate
		public function SetState(theState:String):void
		{
			mCurrentState = theState;
			mAnimationSet.Stop();
			mAnimationSet.PlayAnimation(theState);	
		}
		public function DoAction(theEntity:Entity):void
		{
		
		}
		//check if a point in space is within this entity. for example, another entity's extreme coordinates?
		public function CheckPoint(X1:Number, Y1:Number):Boolean
		{
			if (X1 >= mX - Width / 2)
				if (X1 <= mX + Width / 2)
					if (Y1 >= mY - Height / 2)
						if (Y1 <= mY + Height / 2)
						{
							return true;
						}
			return false;
		}
		public function SetPosition(x:Number, y:Number):void
		{
			mX = x;
			mY = y;
			mAnimationSet.SetPosition(x, y);
			Update();
		}
		public function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			mAnimationSet.UnRender();
			mAnimationSet.Render(theDisplayObjectContainer);
			if (mCurrentState != null)
				SetState(mCurrentState);
		}
		public function UnRender():void
		{
			mAnimationSet.UnRender();
		}

		//check if an entity has collided with this entity
		//if it has, reposition this entity outside the entity's extreme coordinates
		
		public function CheckCollision(theMap:Array, theEntity:Array):void
		{
		
		}
		private function ResetCollision():void
		{
			COLLIDEXLEFT = COLLIDEXRIGHT = COLLIDEYDOWN = COLLIDEYTOP = false;
		}
		public function SetMapParams(theMinX:int, theMaxX:int ):void
		{
			MinX = theMinX;
			MaxX = theMaxX;
		}
		protected function CheckEntityCollision(theEntity:Entity):void
		{
			var NewX:Number = mX;
			var NewY:Number = mY;
			
			ResetCollision();

			if (Math.abs(int(theEntity.mY - (mY + mYSpeed))) < Math.abs(int(theEntity.mX  - (mX + mXSpeed))))
			{
				mXSpeed = 0;
				if (theEntity.mX>mX)
				{
					COLLIDEXRIGHT = true;
					//collision on the left
					NewX = theEntity.mX - (mAnimationSet.Width + theEntity.Width) / 2;
				}
				else
				{
					COLLIDEXLEFT = true;
					//collision on the left.
					NewX = theEntity.mX + (mAnimationSet.Width + theEntity.Width) / 2;
				}
				
				if (COLLIDEXLEFT == true && COLLIDEXRIGHT == true)
				{
					//do nothing
				}
				else if(COLLIDEXLEFT||COLLIDEXRIGHT)
					SetPosition(NewX, mY);
			}

			else if ((Math.abs(int(theEntity.mY  - (mY + mYSpeed)))> Math.abs(int(theEntity.mX - (mX + mXSpeed)))))
			{
				mYSpeed= 0;
				if (theEntity.mY > mY)
				{
					COLLIDEYDOWN = true;
					//collision above
					NewY = theEntity.mY  - (mAnimationSet.Height + theEntity.Height) / 2 ;
				}
				else
				{				
					COLLIDEYTOP = true;
					//collision below
					NewY = theEntity.mY + (mAnimationSet.Height + theEntity.Height) / 2 ;
				}
			}
			if (COLLIDEYTOP == true && COLLIDEYDOWN == true)
			{
				//do nothing
			}
			else if (COLLIDEYDOWN||COLLIDEYTOP)
				SetPosition(mX, NewY);
			
		}

		//check if a map tile has collided with this entity
		//if it has, reposition this entity outside the map tile's extreme coordinates
		protected function CheckMapCollision(theMap:Array):void
		{
			ResetCollision();
			var NewX:int = mX;
			var NewY:int = mY;
			for (var j:int = 0; j < theMap[MinX].length; j++ )
			{
				if (theMap[MinX][j].mCollide)
				{
					if (Math.abs(theMap[MinX][j].X - theMap[MinX][j].Width/2  - (mX + mXSpeed))
						<(mAnimationSet.Width + theMap[MinX][j].Width) / 2)
					{
						COLLIDEXLEFT = true;
						mXSpeed = 0;
						//left map boundary checking, collision on left
						NewX =theMap[MinX][j].X - theMap[MinX][j].Width/2  + (mAnimationSet.Width + theMap[MinX][j].Width) / 2;
					}
				}
			}
			if (COLLIDEXLEFT == true && COLLIDEXRIGHT == true)
			{
				//do nothing
			}
			else if(COLLIDEXLEFT||COLLIDEXRIGHT)
				SetPosition(NewX, mY);
			for (j = 0; j < theMap[MaxX].length; j++ )
			{
				if (theMap[MaxX][j].mCollide)
				{
					if (Math.abs(theMap[MaxX][j].X + theMap[MaxX][j].Width + theMap[MaxX][j].Width / 2 - (mX + mXSpeed))
					<(mAnimationSet.Width + theMap[MaxX][j].Width) / 2)
					{
						COLLIDEXRIGHT = true;
						mXSpeed = 0;
						//right map boundary checking, collision on right
						NewX = theMap[MaxX][j].X + theMap[MaxX][j].Width + theMap[MaxX][j].Width/2 - (mAnimationSet.Width + theMap[MaxX][j].Width) / 2;
					}
				}
			}
			if (COLLIDEXLEFT == true && COLLIDEXRIGHT == true)
			{
				//do nothing
			}
			else if(COLLIDEXLEFT||COLLIDEXRIGHT)
				SetPosition(NewX, mY);
			for (var i:int = 0; i < theMap.length; i++)
			for each(var m:MapNode in theMap[i])
			{
				if (m.mCollide)
				{
					if ( Math.abs(m.Y  + m.Height/2 - (mY + mYSpeed)) < (mAnimationSet.Height + m.Height) / 2)
						if ( Math.abs(m.X + m.Width/2 - (mX + mXSpeed)) < (mAnimationSet.Width + m.Width) / 2)
						{	
							if (Math.abs(int(m.Y + m.Height/2/*Center*/ - (mY + mYSpeed))) < Math.abs(int(m.X + m.Width/2 /*Center*/- (mX + mXSpeed))))
							{
								mXSpeed = 0;
								if (m.X + m.Width/2/*Center*/ > mX )
								{
									COLLIDEXRIGHT= true;
									//collision on the right
									NewX = m.X + m.Width/2- (mAnimationSet.Width + m.Width) / 2;
								}
								else
								{
									COLLIDEXLEFT = true;
									//collision on the left.
									NewX = m.X + m.Width/2 + (mAnimationSet.Width + m.Width) / 2;
								}
							}
						}
				}
			}
			if (COLLIDEXLEFT == true && COLLIDEXRIGHT == true)
			{
				//do nothing
			}
			else if(COLLIDEXLEFT||COLLIDEXRIGHT)
				SetPosition(NewX, mY);
				
			for (i = 0; i < theMap.length; i++)
			for each( m in theMap[i])
			{
				if (m.mCollide)
				{
					if ( Math.abs(m.Y  + m.Height/2 - (mY + mYSpeed)) < (mAnimationSet.Height + m.Height) / 2)
						if ( Math.abs(m.X + m.Width/2 - (mX + mXSpeed)) < (mAnimationSet.Width + m.Width) / 2)
						{	
							if ((Math.abs(int(m.Y + m.Height/2 /*Center*/- (mY + mYSpeed)))> Math.abs(int(m.X + m.Width/2/*Center*/ - (mX + mXSpeed)))))
							{
								mYSpeed = 0;
								if (m.Y + m.Height/2/*Center*/> mY)
								{
									COLLIDEYDOWN = true;
									//collision below
									NewY = m.Y  + m.Height/2 /*Center*/- (mAnimationSet.Height + m.Height) / 2 ;
								}
								else
								{
									COLLIDEYTOP = true;
									//collision above
									NewY = m.Y  + m.Height/2 /*Center*/+ (mAnimationSet.Height + m.Height) / 2 ;
								}
							}
						}
				}
			}

			if (COLLIDEYTOP == true && COLLIDEYDOWN == true)
			{
				//do nothing
			}
			else if (COLLIDEYDOWN||COLLIDEYTOP)
				SetPosition(mX, NewY);
		}
		//get width of the entity sprite
		public function get Width():int
		{
			return mAnimationSet.Width;
		}
		//get the height of the entity sprite
		public function get Height():int
		{
			return mAnimationSet.Height;
		}
		//set the direction of the entity
		protected function SetDirection():void
		{
			if (mCurDirection)
				mAnimationSet.SetXScale(-1);
			else
				mAnimationSet.SetXScale(1);
		}
		
		//pause the current animation of the entity
		public function Pause():void
		{
			if (GameProperties.GetInstance().GetProperty(GameProperties.PAUSE))
			{
				mAnimationSet.Stop();
			}
			else
			{
				SetState(mCurrentState);
			}
		}
		public function Stop():void
		{
			mAnimationSet.Stop();
		}
		//play the current animation
		public function Play():void
		{
			mAnimationSet.Play();
		}
		public function Update():void
		{
			//draw collision box, if the game is on debug mode
			if (GameProperties.DEBUG)
			{
				square.graphics.clear();
				square.graphics.beginFill(0xFF);
				square.graphics.drawRoundRect(mX - Width/2, mY - Height/2, Width, Height, 0, 0);
				square.graphics.endFill();
			}
		}
	}
	
}