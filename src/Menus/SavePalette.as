package Menus 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//------WORK IN PROGRESS--------------//
	public class SavePalette extends Menu
	{
		
		public function SavePalette() 
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