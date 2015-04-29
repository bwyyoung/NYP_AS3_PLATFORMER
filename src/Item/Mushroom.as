package Item 
{
	import Model.Entity;
	import Animations.AnimationSet;
	import flash.display.DisplayObjectContainer;
	import Item.Shell;
	import Model.PlayerModel;
	import flash.utils.*;
	import Managers.EntityManager;
	import Managers.GUIManager;
	import Properties.GameProperties;
	import Enemies.Turtle;
	import Managers.StateManager;
	import States.GameState;
	import GraphicalUserInterface.StandardGUI;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this is the entity class for mushroom
	public class Mushroom extends Entity
	{
		public static var DEFAULT:String = "Stand";
		private var mPower:Number;
		private var mFriction:Number;
		private var Dead:Boolean;
		public function Mushroom(theanimationset:AnimationSet) 
		{
			super(theanimationset);
		}
		public override function Init():void 
		{
			Dead = false;
			super.Init();
			mFriction = 0.7;
			mXSpeed = 0;
			mYSpeed = 0;
			mPower = 1;
			SetState(DEFAULT);
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			super.Render(theDisplayObjectContainer);
		}
		//do an action whenever there is a collision with an entity
		public override function DoAction(theEntity:Entity):void 
		{
			
			super.DoAction(theEntity);
			Right = theEntity.mX + theEntity.Width / 2;
			Left = theEntity.mX - theEntity.Width / 2;
			Up = theEntity.mY - theEntity.Height / 2;
			Down = theEntity.mY + theEntity.Height / 2;
			//if the mushroom hits another mushroom or shell, it will bounce off
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == Shell ||
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
				theEntity.mXSpeed = mXSpeed = 0;
			}
			//if the mushroom touches the player, kill the mushroom
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(500);
				Die();
			}
			else if (getDefinitionByName(getQualifiedClassName(theEntity)) == ItemBox)
			{
				CheckEntityCollision(theEntity);
			}

		}
		protected override function SetDirection():void 
		{
			
		}
		public function Die():void
		{
			mDead = true;
			CleanUp();
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().RemoveEntity(this);
		}
		//check collision with the surrounding environment
		public override function CheckCollision(theMap:Array, theEntities:Array):void 
		{
			if (mX -Width/2> GameProperties.SCREENWIDTH || mX + Width/2< 0||mY-Height/2>GameProperties.SCREENHEIGHT)
				Die();
				
			if (mCurDirection) 
			{
				mXSpeed += mPower;
			}
			else if (!mCurDirection) 
			{
				mXSpeed -= mPower;
			}
			
			mXSpeed *= mFriction;
			
			CheckMapCollision(theMap);
			
			if (COLLIDEXLEFT && !COLLIDEXRIGHT)
				mCurDirection = true;
			else if (!COLLIDEXLEFT && COLLIDEXRIGHT)
				mCurDirection = false;
			else if (!COLLIDEXLEFT && !COLLIDEXRIGHT)
			{
				if (Math.abs(mXSpeed) > 0)
				{
					SetDirection();
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