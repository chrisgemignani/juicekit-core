package flexUnitTests
{
  import flexunit.framework.Assert;

  public class StringsTest
  {		
    [Before]
    public function setUp():void
    {
    }
    
    [After]
    public function tearDown():void
    {
    }
    
    [Test]
    public function testIt():void {
      Assert.assertEquals(1,1);
    }
    
    public function StringTest():void {
      
    }
    
    [BeforeClass]
    public static function setUpBeforeClass():void
    {
    }
    
    [AfterClass]
    public static function tearDownAfterClass():void
    {
    }
    
    
  }
}