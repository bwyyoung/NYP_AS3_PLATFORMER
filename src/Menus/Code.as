package Menus 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class Code 
	{
	//------WORK IN PROGRESS--------------//
		public function Code() 
		{
			
		}
		public override function Init():void
		{
			for each(var ID:uint in ButtonArray)
			{
				mButtonManager.RenderButton(ID, mGraphicsManager.ForeGround);
			}
		}
		public override function CleanUp():void
		{
			for each(var ID:int in ButtonArray)
			{
				mButtonManager.UnRenderButton(ID);
			}
		}
	}
	
}