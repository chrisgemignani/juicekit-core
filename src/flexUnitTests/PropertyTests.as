package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import org.juicekit.util.Property;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	
	public class PropertyTests
	{		
		[Before]
		public function setUp():void
		{
			o = {'a': 1, 
				'b': [1,2,{'c': 4} ] }
			o2 = {'a': 1, 
				  'b': { 'c': 2, 'd': 3 }}
			bc = new BorderContainer();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		private var o:Object;
		private var o2:Object;
		private var bc:BorderContainer;

		[Test]
		public function testGetValue():void {
			Assert.assertEquals(Property.$('a').getValue(o), 1)
		}

		[Test]
		public function testGetValueWithArray():void {
			Assert.assertEquals(Property.$('b.0').getValue(o), 1)
		}
		
		[Test]
		public function testGetValueWithArray2():void {
			Assert.assertEquals(Property.$('b.2.c').getValue(o), 4)
		}
		
		[Test]
		public function testSetValue():void {
			Property.$('a').setValue(o, 2);
			Assert.assertEquals(o['a'], 2);
		}
		
		[Test]
		public function testSetNestedValue():void {
			Property.$('b.c').setValue(o2, 3);
			Assert.assertEquals(o2['b']['c'], 3);
			//  o2.a is unchanged
			Assert.assertEquals(o2['a'], 1);
			Assert.assertEquals(Property.$('b.c').getValue(o2), 3);
			var p:Property = new Property('b.c');
			Assert.assertEquals(p.getValue(o2), 3);
		}
		
		[Test]
		public function testSetNestedValueWithArray():void {
			Property.$('b.2.c').setValue(o, 5);
			Assert.assertEquals(o['b'][2]['c'], 5);
			Assert.assertEquals(Property.$('b.2.c').getValue(o), 5);
		}

		[Test]
		public function testDeleteValue():void {
			Property.$('b.2.c').deleteValue(o);
			Assert.assertUndefined(o['b'][2]['c']);
		}
		
		[Test]
		public function testSetBorderContainerProperty():void {
			Property.$('width').setValue(bc, 221);
			Assert.assertEquals(bc.width, 221);
		}
		
		[Test]
		public function testSetBorderContainerStyle():void {
			// starts as null
			Assert.assertNull(bc.getStyle('backgroundColor'));
			Property.$('backgroundColor').setValue(bc, 0xff0000);
			
			Assert.assertEquals(bc.getStyle('backgroundColor'), 0xff0000);
			// we can also fetch the value with Property
			Assert.assertEquals(Property.$('backgroundColor').getValue(bc), 0xff0000);
		}
		
		
	}
}




