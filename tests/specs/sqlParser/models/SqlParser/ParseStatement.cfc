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
					testClassName="net.sf.jsqlparser.statement.select.Select";
					testObj.$(method="parseSelect", returns="");
					testIf=testObj.loadSQLParserElement(testClassName);
					testObj.$(method="parseSql",returns=testIf);


				} );
				it( "Should run parseSQl 1x", function() {
					var testText="select * from table";
					testme = testobj.parseStatement(testText);
					expect( testObj.$count("parseSql") ).tobe( 1 );
				} );
				it( "If the className of the objet returned from parseSQl is in the typeStruct, run the corresponding function", function() {
					var testText="select * from table";
					testme = testobj.parseStatement(testText);
					expect( testObj.$count("parseSelect") ).tobe( 1 );
				} );
				it( "If the result from teh function has a data key, return the data key", function() {
					var testText="select * from table";
					var testStruct={data:mockData($num=1,$type="words:1")[1]};
					testObj.$(method="parseSelect", returns=testStruct);
					testme = testobj.parseStatement(testText);
					expect( testme ).toBeTypeOf( "string" );
					expect( testme ).tobe( testStruct.data );
				} );
				it( "If the result from the function doe not have a data key, return the whole structure", function() {
					var testText="select * from table";
					var testStruct={yo:mockData($num=1,$type="words:1")[1]};
					testObj.$(method="parseSelect", returns=testStruct);
					testme = testobj.parseStatement(testText);
						expect( testme ).toBeTypeOf( "struct" );
						expect( testme ).toHaveKey( "yo" );
				} );
			}
		);
	}

}
