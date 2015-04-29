package Enemies 
{
	import Animations.AnimationSet;
	import Model.Entity;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	/////--------------WORK IN PROGRESS--------------////
	public class SmallTurtle extends Entity
	{
		public static var WALK:String = "Walk";
		public static var DEFAULT:String = "Stand";
		public static var DIE:String = "Die";
		public function SmallTurtle(theanimationset:AnimationSet) 
		{
			super(theanimationset);
		}
		
	}
	
}