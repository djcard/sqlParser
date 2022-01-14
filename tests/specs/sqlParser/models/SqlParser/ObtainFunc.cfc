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
				it( "if nothing is passed in, return an empty sting", function() {
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainFunc","obtainFuncPublic");
					var testme = testobj.obtainFuncPublic();
					expect( testme.len() ).tobe( 0 );
				} );
				it( "if a className is passed in, which is mapped to a function, return that function", function() {
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainFunc","obtainFuncPublic");
					var testme = testobj.obtainFuncPublic("net.sf.jsqlparser.statement.IfElseStatement");
					expect( getMetadata(testme) ).toHaveKey( "position" );
				} );
				it( "if a string is passed in, which is not mapped to a function, return an empty string", function() {
					var testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					makePublic(testobj,"obtainFunc","obtainFuncPublic");
					var testme = testobj.obtainFuncPublic(mockData($num=1,$type="words:5")[1]);
					expect( testme.len() ).tobe( 0 );
				} );

			}
		);
	}

}
