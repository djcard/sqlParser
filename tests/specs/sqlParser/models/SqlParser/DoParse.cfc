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
			title  = "The Do Parse Function should",
			labels = "automated",
			body   = function() {
				beforeEach( function() {
					testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testObj, "doParse", "doParsePublic");
				} );
				it( "if nothing is passed in, return null", function() {
					testme = testobj.doParsePublic();
					expect( isNull(testme) ).tobeTrue( );
				} );
				it( "if a simple variable is submitted it should return that item", function() {
					var testdata = mockData($num=1,$type="words:5")[1];
					testme = testobj.doParsePublic(testData);
					expect( testme ).tobe( testData );
				} );
				it( "if a simple variable is submitted it should return that item", function() {
					var testdata = mockData($num=1,$type="words:5")[1];
					testme = testobj.doParsePublic(testData);
					expect( testme ).tobe( testData );
				} );
			}
		);
	}

}
