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
			title  = "The Parse Array Function should",
			labels = "automated",
			body   = function() {

				it( "run doParse 1x for each index in the array", function() {
					var testdata = [querynew("hi"),"hello",{},[]];
					var testobj = createMock( object = createObject( "sqlparser.models.sqlparser" ) );
					testObj.$(method="doParse",returns="");
					makePublic(testobj,"parseArray","parseArrayPublic");
					var testme = testobj.parseArrayPublic(testData);
					expect( testObj.$count("doparse") ).toBe( testData.len() );
				} );
			}
		);
	}

}
