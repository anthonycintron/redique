package
{

	public class AbstractJob implements IJob
	{
		public var queue:String;
		
		public function perform(... args):void
		{
			throw new Error("This method should be overridden");
		}
	}
}