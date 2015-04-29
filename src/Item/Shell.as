package Item 
{
	import Model.Entity;
	import Animations.AnimationSet;
	import fl.transitions.TransitionManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import Model.PlayerModel;
	import flash.utils.*;
	import Properties.GameProperties;
	import Managers.EntityManager;
	import Managers.StateManager;
	import Managers.GUIManager;
	import GraphicalUserInterface.StandardGUI;
	import States.GameState;
	import View.MapNode;
	import Item.Shell;
	import GameSound.SoundData;
	import Managers.SoundManager;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this is the entity class for shells
	public class Shell extends Entity
	{
		public static var DEFAULT:String = "Stand";
		public static var SPIN:String = "Spin";
		private var mPower:Number;
		private var mFriction:Number;
		private var Dead:Boolean;
		private var mTimer:Timer;
		
		private var mHit:SoundData;
		
		public function Shell(theanimationset:AnimationSet)  
		{
			super(theanimationset);
			mHit = SoundManager.GetInstance().GetSound("shell","FX");
		}
		public override function Init():void 
		{
			Dead = false;
			super.Init();
			mFriction = 0.9;
			mXSpeed = 0;
			mYSpeed = 0;
			mPower =1.5;
			mCurrentState = DEFAULT;
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			super.Render(theDisplayObjectContainer);
		}

		public override function DoAction(theEntity:Entity):void 
		{
			super.DoAction(theEntity);
			Right = theEntity.mX + theEntity.Width / 2;
			Left = theEntity.mX - theEntity.Width / 2;
			Up = theEntity.mY - theEntity.Height / 2;
			Down = theEntity.mY + theEntity.Height / 2;
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				if (mCurrentState == SPIN)
				{
					if ((CheckPoint(theEntity.mX, Down)||CheckPoint(Right, Down))&& !CheckPoint(Right,theEntity.mY))
					{
						mCurDirection = false;
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(50);
						theEntity.mYSpeed = -15;
					}
					else if (CheckPoint(Left, Down)&& !CheckPoint(Left,theEntity.mY))
					{
						mCurDirection = true;
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(50);
						theEntity.mYSpeed = -15;
					}
					else
					{
						mCurDirection = !mCurDirection;
						mXSpeed = 0;
					}

				}
				else if (mCurrentState == DEFAULT) // let the shell be moved by the player
				{
					mHit.Play();
					if (CheckPoint(Right, theEntity.mY)||CheckPoint(Right, Down)||(CheckPoint(theEntity.mX, Down)))
					{
						mCurDirection = true;
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(10);
						SetState(SPIN);
						mXSpeed = 2;
					}
					else if (CheckPoint(Left, theEntity.mY)||CheckPoint(Left, Down)||(CheckPoint(theEntity.mX, Down)))
					{
						mCurDirection = false;
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(10);
						SetState(SPIN);
						mXSpeed = -2;
					}
					if ((!CheckPoint(Right, theEntity.mY)&&CheckPoint(Right, Down))|| (!CheckPoint(Left, theEntity.mY)&&CheckPoint(Left, Down))||(CheckPoint(theEntity.mX, Down)))
					{
						theEntity.mYSpeed = -15;
					}
				}
				
			}
			//if the shell hits another shell, it will bounce off that shell
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == Shell ||
			getDefinitionByName(getQualifiedClassName(theEntity)) == Mushroom)
			{
				if (CheckPoint(Left, theEntity.mY))
				{
					mCurDirection = false;
				}
				else if (CheckPoint(Right, theEntity.mY))
				{
					mCurDirection = true;
				}
				theEntity.mCurDirection = !mCurDirection;
				theEntity.mXSpeed = mXSpeed = 0;
				SetState(SPIN);
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == ItemBox)
				CheckEntityCollision(theEntity);
		}
		public function Die():void
		{
			mDead = true;
			CleanUp();
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().RemoveEntity(this);
		}
		public override function CheckCollision(theMap:Array, theEntities:Array):void //check collision with the environment
		{
			if (mX -Width/2> GameProperties.SCREENWIDTH || mX + Width/2< 0||mY-Height/2>GameProperties.SCREENHEIGHT)
				Die();
			if (mCurrentState == SPIN)
			{
				if (mCurDirection) 
				{
					mXSpeed += mPower;
				}
				else if (!mCurDirection) 
				{
					mXSpeed -= mPower;
				}
			}
			mXSpeed *= mFriction;
			
			CheckMapCollision(theMap);
			
			//if (COLLIDEXLEFT && !COLLIDEXRIGHT)
				//mCurDirection = true;
		//	else if (!COLLIDEXLEFT && COLLIDEXRIGHT)
				//mCurDirection = false;
			
			if ( COLLIDEXRIGHT)
				mCurDirection = false;
			else if (COLLIDEXLEFT)
				mCurDirection = true;
			else if (!COLLIDEXLEFT && !COLLIDEXRIGHT)
			{
				if (Math.abs(mXSpeed) > 0)
				{
					SetDirection();
				}
				SetPosition(mX + mXSpeed, mY);
			}
			else if (COLLIDEXLEFT && COLLIDEXRIGHT)
			{
				SetState(DEFAULT);
				mXSpeed = 0;
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