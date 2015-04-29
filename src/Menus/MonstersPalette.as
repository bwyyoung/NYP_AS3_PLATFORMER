package Menus 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//------WORK IN PROGRESS--------------//
	public class MonstersPalette extends Menu
	{
		
		public function MonstersPalette() 
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