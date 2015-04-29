package Menus 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//------WORK IN PROGRESS--------------//
	public class MapSize 
	{
		
		public function MapSize() 
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
				trace(ID);
				mButtonManager.UnRenderButton(ID);
			}
		}
		
	}
	
}