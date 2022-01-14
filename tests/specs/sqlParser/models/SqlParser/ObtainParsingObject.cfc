/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll() {
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe(
			title  = "The obtainParsingObject Function should",
			labels = "automated",
			body   = function() {
				beforeEach( function() {
					testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");

				} );
				it( "if nothing is passed in, return null", function() {
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic();
					expect( isNull(testme) ).tobeTrue( );
				} );
				it( "if a simple variable is submitted it should return that item", function() {
					var testdata = mockData($num=1,$type="words:5")[1];
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testme ).tobe( testData );
				} );
				it( "if a simple variable is submitted it should run obtainFunc 0x", function() {
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					testObj.$(method="obtainFunc",returns="");
					var testdata = mockData($num=1,$type="words:5")[1];
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testObj.$count("obtainFunc") ).tobe( 0 );
				} );

				it( "if an item is submitted whose class is mapped to a function, it should return that function", function() {
					var testdata = testObj.loadSQLParserElement("net.sf.jsqlparser.statement.select.Select");
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					testObj.$(method="obtainFunc",returns="");
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testme.getClass().getName() ).tobe( testData.getClass().getName() );
				} );
				it( "if a structure is submitted", function() {
					var testdata = { };
					var mockReturn=mockData($num=1,$type="words:1")[1];
					var testobj = createMock( object = createObject( "sqlparser.models.sqlparser" ) );
					testObj.$(method="parseStruct",returns=mockreturn);
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testObj.$count("parseStruct") ).tobe( 1 );
				} );
				it( "if an Array is submitted", function() {
					var testdata = [];
					var mockReturn=mockData($num=1,$type="words:1")[1];
					var testobj = createMock( object = createObject( "sqlparser.models.sqlparser" ) );
					testObj.$(method="parseArray",returns=mockreturn);
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testObj.$count("parseArray") ).tobe( 1 );
				} );
				it( "if all else fails, return the object which was submitted", function() {
					var testdata = querynew("hi");
					var mockReturn=mockData($num=1,$type="words:1")[1];
					var testobj = createMock( object = createObject( "sqlparser.models.sqlparser" ) );
					testObj.$(method="parseArray",returns=mockreturn);
					makePublic(testobj,"obtainParsingObject","obtainParsingObjectPublic");
					var testme = testobj.obtainParsingObjectPublic(testData);
					expect( testme ).toBeTypeOf( "query" );
				} );
			}
		);
	}

}
