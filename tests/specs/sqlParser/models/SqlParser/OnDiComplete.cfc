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
			title  = "The Init Function should",
			labels = "automated",
			body   = function() {
				beforeEach( function() {
					testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					testObj.$(method="loadSQLParser");
				} );
				it( "Should run loadSQLParser 1x", function() {
					testme = testobj.onDiComplete();
					expect( testObj.$count("loadSQLParser") ).tobe( 1 );
				} );
			}
		);
	}

}
