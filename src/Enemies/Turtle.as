package Enemies 
{
	import flash.display.Sprite;
	import Animations.AnimationSet;
	import fl.transitions.TransitionManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import Model.Entity;
	import Model.PlayerModel;
	import flash.utils.*;
	import Properties.GameProperties;
	import Managers.EntityManager;
	import Managers.StateManager;
	import Item.Shell;
	import States.GameState;
	import Managers.GraphicsManager;
	
	Item.Shell;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this is the entity class for the turtle
	public class Turtle extends Entity
	{
		public static var WALK:String = "Walk";
		public static var DEFAULT:String = "Stand";
		public static var TURN:String = "Turn";
		
		protected var mPower:Number;
		protected var mFriction:Number;
		private var mTimer:Timer;

		public function Turtle(theanimationset:AnimationSet)
		{
			super(theanimationset);
			
		}
		public override function Init():void 
		{
			super.Init();
			mFriction = 0.9;
			mXSpeed = 0;
			mYSpeed = 0;
			mPower = 0.3;
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			super.Render(theDisplayObjectContainer);
			SetState(WALK);
		}
		//when there is collision with an entity, do an action
		public override function DoAction(theEntity:Entity):void 
		{
			super.DoAction(theEntity);
			Right = theEntity.mX + theEntity.Width / 2;
			Left = theEntity.mX - theEntity.Width / 2;
			Up = theEntity.mY - theEntity.Height / 2;
			Down = theEntity.mY + theEntity.Height / 2;
			
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				if (CheckPoint(theEntity.mX, Down)&& theEntity.mDead == false)
				{
					SpawnShell();
					Die();
					theEntity.mYSpeed=-7;
				}
				else
				{			
					mAnimationSet.PlayAnimation(TURN, false);
					mCurrentState = TURN;
					mCurDirection = !mCurDirection;
					mXSpeed = 0;
						if (CheckPoint(Left, theEntity.mY) || CheckPoint(Left, Down)||CheckPoint(Left, Up))
						{
							mX =int(theEntity.mX) - (Width + theEntity.Width) / 2;
						}
						else if (CheckPoint(Right, theEntity.mY)|| CheckPoint(Right, Down)||CheckPoint(Right, Up) )
						{
							mX =int(theEntity.mX) + (Width + theEntity.Width) / 2;
						}
						SetPosition(mX, mY);
				}
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == Shell)
			{
				if (theEntity.mCurrentState == Shell.SPIN)
					Die();
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == Turtle)
			{
				if (CheckPoint(Left, theEntity.mY))
				{
					mCurDirection = false;
				}
				else if (CheckPoint(Right, theEntity.mY))
				{
					mCurDirection = true;
				}
				if (mCurrentState != TURN)
				{
					mAnimationSet.PlayAnimation(TURN);
					mCurrentState = TURN;
				}
				CheckEntityCollision(theEntity);
			}
		}
		public function Die():void
		{
			mDead = true;
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().RemoveEntity(this);
		}
		//when the turtle dies, it spawns a shell
		public function SpawnShell():void
		{
			var theShell:String =mAnimationSet.mName.substr(0, mAnimationSet.mName.search("Turtle"))+  "Shell";
			var mEntity:Class;
			var mObject:Object;
			mEntity = getDefinitionByName("Item::Shell") as Class;
			mObject = new mEntity(EntityManager.GetInstance().GetAnimationSet(theShell)) as Entity;
			mObject.SetPosition(mX, mY);
			
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().AddEntity(mObject as Entity);
			mObject.Render(mAnimationSet.mCurContainer);	
			mObject.Init();
			mObject.SetMapParams(MinX, MaxX);
		}
		//check for collisions with the surrounding environment
		public override function CheckCollision(theMap:Array, theEntities:Array):void 
		{
			if (mY-Height/2>GameProperties.SCREENHEIGHT)
				Die();
			//Check collision with the environment
			if (mCurDirection) 
			{
				mXSpeed += mPower;
			}
			else if (!mCurDirection)
			{
				mXSpeed -= mPower;
			}
			mXSpeed *= mFriction;
			//check collision with the map
			CheckMapCollision(theMap);
			if ((COLLIDEXLEFT || COLLIDEXRIGHT) && !COLLIDEYTOP)
			{
				if (mCurrentState != TURN)
				{
					mAnimationSet.PlayAnimation(TURN);
					mCurrentState = TURN;
				}
	
				mCurDirection = !mCurDirection;
			}
			else if (!COLLIDEXLEFT && !COLLIDEXRIGHT)
			{
				if (Math.abs(mXSpeed) > 0)
				{
					if (mCurrentState == TURN&& mCurrentState != WALK)
					{
						mCurrentState = WALK;
						SetDirection();
						mAnimationSet.PlayAnimation(WALK, true);
					}
					if (mCurrentState != WALK)
						SetState(WALK);
				}
				SetPosition(mX + mXSpeed, mY);
			}

			if (!COLLIDEYDOWN && !COLLIDEYTOP)
			{
				if (mYSpeed>0)
				SetPosition(mX, mY + mYSpeed);
				mYSpeed += 1;
				if (mYSpeed > 5)
					mYSpeed = 5;
			}
		}

		
	}
	
}