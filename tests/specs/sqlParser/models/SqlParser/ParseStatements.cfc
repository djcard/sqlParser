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
			title  = "The ParseStatements Function should",
			labels = "automated",
			body   = function() {
				beforeEach( function() {
					testobj = createMock( object = getInstance( "Sqlparser@sqlparser" ) );
					testObj.$(method="parseStatement");
				} );
				it( "run parseStatement 1x for each sql statement submitted: simple no ending ;", function() {
					var testText="select * from table";
					testme = testobj.parseStatements(testText);
					expect( testObj.$count("parseStatement") ).tobe( 1 );
				} );
				it( "run parseStatement 1x for each sql statement submitted: simple with ending ;", function() {
					var testText="select * from table;";
					testme = testobj.parseStatements(testText);
						expect( testObj.$count("parseStatement") ).tobe( 1 );
				} );
				it( "run parseStatement 1x for each sql statement submitted: 2 simple with 1 ending ; and no ; at end", function() {
					var testText="select * from table; update table set field=5 where field=7";
					testme = testobj.parseStatements(testText);
						expect( testObj.$count("parseStatement") ).tobe( 2 );
				} );
				it( "run parseStatement 1x for each sql statement submitted: 2 simple with 1 ending ; and ; at end", function() {
					var testText="select * from table; update table set field=5 where field=7;";
					testme = testobj.parseStatements(testText);
						expect( testObj.$count("parseStatement") ).tobe( 2 );
				} );
				it( "run parseStatement 1x for each sql statement submitted: multiple statements", function() {
					var testText="select * from table; update table set field=5 where field=7; delete from table; hello; dhghg;";
					testme = testobj.parseStatements(testText);
						expect( testObj.$count("parseStatement") ).tobe( 5 );
				} );
			}
		);
	}

}
