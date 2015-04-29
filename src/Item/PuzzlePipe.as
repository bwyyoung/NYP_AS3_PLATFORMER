package Item {
	import flash.display.DisplayObjectContainer;
	import Model.Entity;
	import Model.PlayerModel;
	/**
	* ...
	* @author Default
	*/
	//this is a puzzlepipe for minigames
	public class PuzzlePipe extends Entity
	{
		public static const PUZZLE_LUMINES:String = "Minigames.Lumines.Model.Lumines";
		
		private var CurrentPuzzle:String;
		public function PuzzlePipe(theanimationset:AnimationSet) 
		{
			super(theanimationset);
		}
		public override function SetPosition(x:Number, y:Number):void 
		{
			super.SetPosition(x, y);
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void 
		{
			super.Render(theDisplayObjectContainer);
		}
		public override function CleanUp():void 
		{
			super.CleanUp();
		}
		public override function DoAction(theEntity:Entity):void
		{
			super.DoAction(theEntity);
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				CheckEntityCollision(theEntity);
			}
		}
	}
	
}