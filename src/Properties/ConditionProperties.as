package Properties 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class ConditionProperties 
	{
		private var mConditions:Array;
		public function ConditionProperties() 
		{
			mConditions = new Array();
		}
		public function AddCondition(theCondition:String):void
		{
			var i:int;
			for ( i = 0; i < mConditions.length; i++)
			{
				if (mConditions[i] == theCondition)
					break;
			}
			if (i == mConditions.length)
				mConditions.push(theCondition);
		}
		public function CheckCondition(theCondition:String):Boolean
		{
			var i:int;
			for ( i = 0; i < mConditions.length; i++)
			{
				if (mConditions[i] == theCondition)
				{
					return false;
					break;
				}
			}
			return true; 
		}
		
	}
	
}