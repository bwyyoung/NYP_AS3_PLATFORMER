package Item 
{
	import flash.display.InterpolationMethod;
	import GraphicalUserInterface.StandardGUI;
	import Model.Entity;
	import Animations.AnimationSet;
	import flash.display.DisplayObjectContainer;
	import Model.PlayerModel;
	import flash.utils.*;
	import Managers.EntityManager;
	import Item.Mushroom;
	import Managers.GUIManager;
	import States.GameState;
	import Managers.StateManager;
	Item.Mushroom;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this is the entity class for itembox
	public class ItemBox extends Entity
	{
		public static var Points:int = 100;
		public static var STAND:String = "Stand";
		public static var DEFAULT:String = "Spin";
		public static var DIE:String= "Die";
		public var Spawned:Boolean;
		public function ItemBox(theanimationset:AnimationSet) 
		{
			super(theanimationset);
		}
		public override function Init():void 
		{
			super.Init();
			Spawned = false;
			
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			super.Render(theDisplayObjectContainer);
			mAnimationSet.PlayAnimation(DEFAULT);
		}
		//the item box does actions to entities, and acts as a part of the terrain, so naturally, there is collision detection when entities
		//collide with it
		public override function DoAction(theEntity:Entity):void 
		{
			super.DoAction(theEntity);
			Right = theEntity.mX + theEntity.Width / 2;
			Left = theEntity.mX - theEntity.Width / 2;
			Up = theEntity.mY - theEntity.Height / 2;
			Down = theEntity.mY + theEntity.Height / 2;
			
			//do collision detection with player
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				if (CheckPoint(theEntity.mX, Up))//if the itembox is hit from the bottom, spawn a mushroom and kill it
				{
					if (!mDead)
					{
						SpawnMushroom();
						mDead = true;
						SetState(DIE);
						(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).AddScore(100);
					}
				}
			}
			
		}
		//spawn a mushroom
		private function SpawnMushroom():void
		{
			var theShroom:String = "GreenMushroom";
			var mEntity:Class;
			var mObject:Object;
			mEntity = getDefinitionByName("Item::Mushroom") as Class;
			mObject = new mEntity(EntityManager.GetInstance().GetAnimationSet(theShroom)) as Entity;
			mObject.SetPosition(mX, mY- Height/2 - mObject.Height/2);
			if ((int(Math.random()*10))%2==0)//move the mushroom in a random direction
				mObject.mCurDirection = true;
			else
				mObject.mCurDirection = false;
			(StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().AddEntity(mObject as Entity);
			mObject.Render(mAnimationSet.mCurContainer);
			mObject.Init();
			mObject.SetMapParams(MinX, MaxX);
		}
		//check collision with the map
		public override function CheckCollision(theMap:Array, theEntities:Array):void 
		{
			CheckMapCollision(theMap);
		}
	}
	
}