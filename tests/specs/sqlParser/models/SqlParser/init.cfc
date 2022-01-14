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
				} );
				it( "init should return the SQLParser", function() {
					testme = testobj.init();
					expect( testObj ).toBeInstanceOf( "SqlParser" );
				} );
				it( "It should have 1 property which is javaLoader", function() {
					testme = testobj.init();
					var meta=getMetadata(testme);
					meta.properties.filter(function(item){
						return item.name=='javaLoader';
					});
					expect( meta.properties.filter(function(item){
						return item.name=='javaLoader';
					}).len() ).tobe(1 );
				} );
			}
		);
	}

}
