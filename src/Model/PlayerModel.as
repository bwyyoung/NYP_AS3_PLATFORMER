package Model 
{

	import Animations.AnimationSet;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import Model.Entity;
	import flash.utils.*;
	import flash.events.TimerEvent;
	import Properties.ConditionProperties;
	import Properties.GameProperties;
	import Managers.StateManager;
	import Managers.EntityManager;
	import Managers.GraphicsManager;
	import Managers.GUIManager;
	import GraphicalUserInterface.StandardGUI;
	import View.MapNode;
	import Enemies.*;
	import Item.*;
	import Managers.SoundManager;
	import GameSound.SoundData;
	import States.GameState;

	/**
	* ...
	* @author $(DefaultUser)
	*/
	
	//this class holds all the information about the player
	public class PlayerModel extends Entity
	{
		public static var PLAYER_STAND:String = "Stand";
		public static var PLAYER_WALK:String = "Walk";
		public static var PLAYER_JUMP_UP:String = "Jump Up";
		public static var PLAYER_JUMP_DOWN:String = "Jump Down";
		public static var PLAYER_CROUCH:String = "Crouch";
		public static var PLAYER_LOOKUP:String = "Look Up";
		public static var PLAYER_TRANSFORM:String = "Transform";
		public static var PLAYER_DIE:String = "Die";
		public static var PLAYER_SPIN:String = "Spin";
		public static var PLAYER_WIN:String = "Victory";
		public static var PLAYER_SLIDE:String = "Slide";
		
		protected var mPower:Number;
		protected var mFriction:Number;
		protected var RIGHT:Boolean;
		protected var LEFT:Boolean;
		protected var UP:Boolean;
		protected var DOWN:Boolean;
		protected var JUMP:Boolean;
		protected var CROUCH:Boolean;

		public var mHitInvincible:Boolean;
		private var mPreviousState:String;
		public var mIsBig:Boolean; //is mario bigmario?
		public var mMorphing:Boolean;
		private var mJumpSpeed:Number;
		private var Jumping:ConditionProperties;
		private var StillAction:ConditionProperties;
		private var mMario:AnimationSet;
		private var mBigMario:AnimationSet;
		private var mTimer:Timer;
		
		private var mDeathSound:SoundData;
		private var mSmallJumpSound:SoundData;
		private var mBigJumpSound:SoundData;
		
		//this is to store the player information, such as the various mario sprites. it is controlled by the controller class, through commands such as walk, jump and crouch
		public function PlayerModel(mario:AnimationSet, bigmario:AnimationSet)
		{
			mMario = mario;
			mBigMario = bigmario;
			super(mMario);
			Jumping = new ConditionProperties();
			Jumping.AddCondition(PLAYER_JUMP_UP);
			Jumping.AddCondition(PLAYER_JUMP_DOWN);
			
			StillAction = new ConditionProperties();
			StillAction.AddCondition(PLAYER_CROUCH);
			StillAction.AddCondition(PLAYER_LOOKUP);
			
			mDeathSound = SoundManager.GetInstance().GetSound("Die","Music");
			mSmallJumpSound = SoundManager.GetInstance().GetSound("jump_small","FX");
			mBigJumpSound = SoundManager.GetInstance().GetSound("jump_big","FX");
		}
		//initialise the player class
		public override function Init():void
		{
			super.Init();
			mDead = false;

			GraphicsManager.GetInstance().MapGround.addChild(square);
			//these are booleans for each movement. these are enabled by keypresses.
			RIGHT = false;
			LEFT  = false;
			UP = false;
			DOWN  = false;
			JUMP = false;
			SetPosition(0, 0);
			
			mFriction = 0.9;
			mXSpeed = 0;
			mYSpeed = 0;
			mPower = 0.9;	
			mJumpSpeed = -23;
		}
		public function ResetMario():void
		{
			mIsBig = false;
			mAnimationSet = mMario;
		}
		//walk right when key is pressed
		public function WalkRight(evt:KeyboardEvent):void
		{
			if (mControl)
			{
				//walking right, when the key goes up, the character stops moving
				if (evt.type == KeyboardEvent.KEY_UP)
				{
					RIGHT = false;
				}
				else if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					if (!RIGHT)
					{
						RIGHT = true;
						if (Jumping.CheckCondition(mCurrentState))
						SetState(PLAYER_WALK);
					}
				}
				if (LEFT && !RIGHT)
					mCurDirection = false;
				if (RIGHT && !LEFT)
					mCurDirection = true;
				SetDirection();					
			}
		}
		//whenever there is a collision with an entity, do something
		public override function DoAction(theEntity:Entity):void 
		{
			Right = theEntity.mX + theEntity.Width / 2;
			Left = theEntity.mX - theEntity.Width / 2;
			Up = theEntity.mY - theEntity.Height / 2;
			Down = theEntity.mY + theEntity.Height / 2;
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == Turtle)
			{
				if (mControl)
				{
					//based on where the entity was it, either kill the player, or just bounce off the entity
					if ((CheckPoint(Left, theEntity.mY) || CheckPoint(Right, theEntity.mY) || CheckPoint(Down, theEntity.mY) || CheckPoint(Left, Up) || CheckPoint(Right, Up)) && (!CheckPoint(theEntity.mX,Up)))
					{
						mXSpeed = 0;
						if (mIsBig)
						{
							mControl = false;
							Morph(false);
						}
						else
						{
							if (!mHitInvincible)
								Die();
						}
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
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == Shell)//if the player hits a shell
			{
				//check if the shell is currently spinning
				if (theEntity.mCurrentState == Shell.SPIN)
				{
					if ((CheckPoint(Left, theEntity.mY) && theEntity.mCurDirection == false) ||
					(CheckPoint(Right, theEntity.mY) &&  theEntity.mCurDirection == true)
					||CheckPoint(theEntity.mX,Down))
					{
						mXSpeed = 0;
						if (mIsBig)
						{
							mControl = false;
							Morph(false);
						}
						else
						{
							if (!mHitInvincible)
								Die(); //kill the player
						}
						// or just move it out of the way
						if (CheckPoint(Left, theEntity.mY) || CheckPoint(Left, Down))//||CheckPoint(Left, Up))
						{
							mX =int(theEntity.mX) - (Width + theEntity.Width) / 2;
						}
						else if (CheckPoint(Right, theEntity.mY)|| CheckPoint(Right, Down))//||CheckPoint(Right, Up) )
						{
							mX =int(theEntity.mX) + (Width + theEntity.Width) / 2;
						}
						SetPosition(mX, mY);
					}
					else
					{
						if (CheckPoint(Left, theEntity.mY) && theEntity.mCurDirection ==true)
						{
							mX =int(theEntity.mX) - (Width + theEntity.Width) / 2;
						}
						else if (CheckPoint(Right, theEntity.mY) &&  theEntity.mCurDirection == false)
						{
							mX =int(theEntity.mX) + (Width + theEntity.Width) / 2;
						}
						SetPosition(mX, mY);
					}
				}
			}

			//a mushroom will cause the player to morph into big mario
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == Mushroom)
			{
				if (!mIsBig)
				{
					mControl = false;
					Morph(true);
				}
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == ItemBox)
			{
				CheckEntityCollision(theEntity);
			}
			super.DoAction(theEntity);
		}
		//make the player fall to his death
		private function PlayerDeath(theEvent:TimerEvent):void
		{
			mYSpeed += 0.5;
			if (mYSpeed > 0.5)
				mYSpeed = 0.5;
			SetPosition(mX, mY + mYSpeed);
			if (mY - Height > GameProperties.SCREENWIDTH)
			{
				NewGame();
				mTimer.stop();
			}
		}
		//start a new game, and reset everything
		private function NewGame():void
		{
			GameProperties.GetInstance().ToggleProperty(GameProperties.PAUSE, false);
			StateManager.GetInstance().ToggleState(StateManager.GAMESTATE);
		}
		//walk left if the left key is pressed
		public function WalkLeft(evt:KeyboardEvent):void
		{
			if (mControl)
			{
				//walking left, when the key goes up, the character stops moving
				if (evt.type == KeyboardEvent.KEY_UP)
				{
					LEFT = false;
				}
				else if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					if (!LEFT)
					{
						LEFT = true;
						if (Jumping.CheckCondition(mCurrentState))
						SetState(PLAYER_WALK);
					}
				}
				if (LEFT && !RIGHT)
					mCurDirection = false;
				if (RIGHT && !LEFT)
					mCurDirection = true;
				SetDirection();
			}
		}
		//make the player stand up
		public function Stand():void
		{
			if (Jumping.CheckCondition(mCurrentState))
			{
				RIGHT = LEFT = false;
				SetState(PLAYER_STAND);
			}
		}
		//when the key is pressed, make the player jump
		public function Jump(evt:KeyboardEvent):void
		{
			if (mControl)
			{
				//jumping, when the key is repeatedly pressed, the character will not repeatedly jump
				if (evt.type == KeyboardEvent.KEY_UP)
					JUMP =  false;
				if (evt.type == KeyboardEvent.KEY_DOWN)	
					if (Jumping.CheckCondition(mCurrentState)&& !JUMP)
					{
						JUMP = true;
						mYSpeed = mJumpSpeed;
						if (mIsBig)
							mBigJumpSound.Play();
						else
							mSmallJumpSound.Play();
						SetState(PLAYER_JUMP_UP);
					}
			}
		}
		//make the player crouch
		public function Crouch(evt:KeyboardEvent):void
		{
			if (mControl)
			{
				if (Jumping.CheckCondition(mCurrentState))
				{
					if (mCurrentState != PLAYER_CROUCH)
						mPreviousState = mCurrentState;
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						CROUCH = true;
						RIGHT = LEFT = false;
						SetState(PLAYER_CROUCH);
					}
					else
					{
						CROUCH = false;
						if (mCurrentState != mPreviousState)
							SetState(mPreviousState);
					}
				}
			}
		}
		//make the player lookup
		public function LookUp(evt:KeyboardEvent):void
		{
			if (mControl)
			{
				if (Jumping.CheckCondition(mCurrentState))
				{
					if (mXSpeed == 0)
						SetState(PLAYER_LOOKUP);
				}
				if (evt.type == KeyboardEvent.KEY_UP)
				{
					UP = false;
					Stand();
				}
				else if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					UP = true;
				}
			}
		}
		// the player can morph in and out of being big mario
		public function Morph(IsBig:Boolean = true):void
		{
			//this is to morph into big mario, or small mario.
			mMorphing = true;
			mIsBig = IsBig;
			if (mIsBig)
			{
				mAnimationSet.Stop();
				mAnimationSet.UnRender();
				mAnimationSet = mBigMario;
				Render(mMario.mCurContainer);
				SetPosition(mX, mY -(mBigMario.Height/2-mMario.Height/2));
				SetDirection();
			}
			SetState(PLAYER_TRANSFORM);
			GameProperties.GetInstance().ToggleProperty(GameProperties.PAUSE, true);
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().Pause();
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, ChangeSprite);
			timer.start();
		}
		//change the sprite, from either bigmario or small mario
		private function ChangeSprite(event:TimerEvent):void
		{
			
			mMorphing = false;
			if (mIsBig)
			{
				
			}
			else
			{
				mHitInvincible = true;
				var timer:Timer = new Timer(100, 20);
				timer.addEventListener(TimerEvent.TIMER, Blink);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, Blink);
				timer.start();
				
				mAnimationSet.Stop();
				mAnimationSet.UnRender();
				mAnimationSet = mMario;
				SetPosition(mX, mY);
				SetDirection();
				mAnimationSet.Render();
			}
			mXSpeed = mYSpeed = 0;
			mControl = true; // re enable control on the player, after a full morph
			Stand();
			GameProperties.GetInstance().ToggleProperty(GameProperties.PAUSE, false);
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().Play();
		}
		private function Blink(event:TimerEvent):void
		{
			if (event.type == TimerEvent.TIMER)
			{
				mAnimationSet.Blink();
			}
			else if (event.type == TimerEvent.TIMER_COMPLETE)
			{
				mAnimationSet.Render();
				mHitInvincible = false;
			}
		}
		public function Die():void
		{
			mDead = true;
			mControl = false;
			mTimer = new Timer(5,0);
			mTimer.addEventListener(TimerEvent.TIMER, PlayerDeath);
			mDeathSound.Play();
			SetState(PlayerModel.PLAYER_DIE);
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddLives( -1);
			GameProperties.GetInstance().ToggleProperty(GameProperties.PAUSE, true);
		    (StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().Stop();
			mTimer.start();
			mYSpeed=-7;
		}
		//check for collisions with entities and the map
		public override function CheckCollision(theMap:Array, theEntities:Array):void
		{
			if (mY - Height > GameProperties.SCREENHEIGHT)
			{
				mXSpeed = 0;
				if (mIsBig)
				{
					mControl = false;
					Morph(false);
				}
				else
				{
					Die();
				}
			}
			if (mControl)
			{
				CheckMapCollision(theMap);
				for each (var ent:Entity in theEntities)
				{
					if ( Math.abs(ent.mY  - ( mY + mYSpeed ) )   < (mAnimationSet.Height + ent.Height) / 2)
						if ( Math.abs(ent.mX - ( mX + mXSpeed ) )  < (mAnimationSet.Width + ent.Width) / 2)
						{
							DoAction(ent);
							ent.DoAction(this);
							
						}
				}
			}
			
			if (mControl)//if the player can be controlled now, do actions
			{
				if (RIGHT && !LEFT && !DOWN) 
				{
					mXSpeed += mPower;
				}
				else if (LEFT && !RIGHT && !DOWN) 
				{
					mXSpeed -= mPower;
				}
				else if (Math.abs(mXSpeed) <= 0.3)
				{
					mXSpeed = 0;
					if (StillAction.CheckCondition(mCurrentState))
						Stand();
				}
				mXSpeed *= mFriction;
				if (COLLIDEXLEFT || COLLIDEXRIGHT)
				{
					//Stand();
					if(!JUMP && !CROUCH && !UP)
						SetState(PLAYER_STAND);
					if (JUMP)
					{
						mAnimationSet.PlayAnimation(PLAYER_JUMP_UP);
					}					
				}
				else if (!COLLIDEXLEFT && !COLLIDEXRIGHT)
				{
					SetPosition(mX + mXSpeed, mY);
				}
				SetPosition(mX, mY + mYSpeed);
				if (COLLIDEYDOWN)
				{
					if (!Jumping.CheckCondition(mCurrentState))
					{
						JUMP = false;
						SetState(PLAYER_WALK);
					}
					if (!JUMP)
					{
						mYSpeed = 1;
					}
					
					if (mXSpeed == 0 && !JUMP && !CROUCH && !UP)
					{
						SetState(PLAYER_STAND);
					}
					else
						if (mCurrentState != PLAYER_WALK && mCurrentState != PLAYER_JUMP_DOWN && !JUMP && !CROUCH && !UP)
						{
							SetState(PLAYER_WALK);
						}
				}
				else if (!COLLIDEYDOWN && !COLLIDEYTOP)
				{
					mYSpeed += 1.5;
					if (mYSpeed > 12)
						mYSpeed = 12;
					if (mYSpeed > 0)
						if (mCurrentState != PLAYER_JUMP_DOWN)
							SetState(PLAYER_JUMP_DOWN);
				}
				//Checking for collisions between the entities in the map, and the player
			}
		}
		
	}
}



