package 
{
  /**
  * Test suite for utility classes
   * [RunWith("org.flexunit.runners.Suite")]
  */
  [Suite]
  [RunWith("org.flexunit.runners.Suite")]
  public class UtilTestSuite
  {
    public var stringsFormatTests:StringsFormatTests;
    public var matrixTests:MatrixTests;
	public var sortTests:SortTests;
	public var colorTests:ColorTests;
	public var propertyTests:PropertyTests;
  }
}