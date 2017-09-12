package be.PIH.MM3{
	
	public class Settings{
	
		public static var titleGame:String;
		public static var serverPath:String;
		
		public static function parseXMLFile(xmlFile:XML):void
		{
			Settings.titleGame = xmlFile.title;
			Settings.serverPath = xmlFile.serverpath;
		}
	}
}