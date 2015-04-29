package Item 
{
	import Animations.AnimationSet;
	import Model.Entity;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//-----WORK IN PROGRESS-----//
	public class Coin extends Entity
	{
		public static var DEFAULT:String = "Spin";
		public function Coin(theanimationset:AnimationSet) 
		{
			super(theanimationset);
		}
	}
}