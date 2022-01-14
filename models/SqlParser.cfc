/***
 * A wrapper for the JSQLparser project at https://github.com/JSQLParser/JSqlParser
 **/
component singleton {

	property name="javaLoader" inject="loader@cbjavaloader";



	/**
	 * Constructor
	 */
	SqlParser function init() {
		return this;
	}

	/**
	 * On DI Complete load library
	 */
	function onDIComplete() {
		loadSQLParser();
	}

	/**
	 * Determines which method should parse a submitted class Name
	 * @className the name of the class of the about to rendered item.
	 **/
	private function obtainFunc( className ) {
		var typeStruct = {
			"net.sf.jsqlparser.statement.IfElseStatement"                      : parseIfElse,
			"net.sf.jsqlparser.statement.insert.Insert"                        : parseInsert,
			"net.sf.jsqlparser.schema.Table"                                   : parseTable,
			"net.sf.jsqlparser.schema.Column"                                  : parseColumn,
			"net.sf.jsqlparser.statement.update.Update"                        : parseUpdate,
			"net.sf.jsqlparser.expression.operators.relational.ExpressionList" : parseExpressionList,
			"net.sf.jsqlparser.expression.StringValue"                         : parseStringValue,
			"java.util.ArrayList"                                              : parseArrayList,
			"net.sf.jsqlparser.expression.operators.relational.EqualsTo"       : parseEqualsTo,
			"net.sf.jsqlparser.expression.JdbcNamedParameter"                  : parseNamedParameter,
			"net.sf.jsqlparser.statement.update.UpdateSet"                     : parseUpdateSet,
			"net.sf.jsqlparser.expression.operators.conditional.AndExpression" : parseAndExpression,
			"net.sf.jsqlparser.statement.select.Select"                        : parseSelect,
			"net.sf.jsqlparser.statement.select.PlainSelect"                   : parsePlainSelect,
			"net.sf.jsqlparser.statement.select.OrderByElement"                : parseOrderByElement,
			"net.sf.jsqlparser.statement.select.SelectExpressionItem"          : parseSelectExpressionItem,
			"net.sf.jsqlparser.expression.LongValue"                           : parseLongValue,
			"net.sf.jsqlparser.statement.select.AllColumns"                    : parseAllColumns,
			"net.sf.jsqlparser.statement.delete.Delete"                        : parseDelete
		};

		return !isNull( className ) && typeStruct.keyExists( className ) ? typeStruct[ className ] : "";
	}


	/**
	 * Parses multiple SQL statements by listToArray(";"). Submits each one separately to be parsed
	 * @sqlText The string SQL statements. Can be single is number of statements is unknown
	 */

	function parseStatements( required string sqlText ) {
		var all = arguments.sqlText
			.listtoarray( ";", false )
			.map( function( stmt ) {
				if ( trim( stmt ).len() > 0 ) {
					return parseStatement( stmt );
				}
			} );
		return all;
	}

	/**
	 * Parses a single SQL statement
	 * @sqlText The string SQL statements. Can be single is number of statements is unknown
	 */

	function parseStatement( required string sqlText ) {
		var parsed    = parseSql( sqlText );
		var className = parsed.getClass().getName();
		var result    = {};
		var runFunc   = obtainFunc( className );
		try {
			result = runFunc( parsed );
		} catch ( any err ) {
		}

		return isStruct( result ) && result.keyExists( "data" ) ? result.data : result;
	}

	/**
	 * Performs the initial parsing of a SQL string into classes
	 * @sqlText The string SQL statements. Can be single is number of statemtns is unknown
	 */
	function parseSql( required string sqlText ) {
		return variables.sqlparser.parse( sqlText );
	}

/**
 * Handles the recusion and point of focus for the process
 * @stmt The object which is being parsed at the moment
 */
	private function doParse( any stmt ) {
		if ( isNull( stmt ) ) {
			return;
		}

		var parsed = obtainParsingObject( stmt );

		if ( !isNull( parsed ) ) {
			if ( isStruct( parsed ) && parsed.keyExists( "terminal" ) && !parsed.terminal ) {
				return doparse( parsed.data );
			} else if ( isStruct( parsed ) && parsed.keyExists( "data" ) ) {
				return parsed.data;
			} else if ( isArray( parsed ) ) {
				return parsed.map( function( aritem ) {
					return aritem.data;
				} );
			}
		}
		return arguments.stmt;
	}

/**
* Determines the method which is going to parse the submitted object
* @stmt The object which is being parsed at the moment
*/
	private function obtainParsingObject( stmt ) {
		if ( isNull( stmt ) ) {
			return;
		}
		return (
			isSimpleValue( stmt )
			 ? arguments.stmt
			 : !isSimpleValue( obtainFunc( stmt.getClass().getName() ) )
				 ? obtainFunc( stmt.getClass().getName() )( stmt )
				 : isStruct( stmt )
					 ? parseStruct( stmt )
					 : isArray( stmt )
						 ? parseArray( stmt )
						 : arguments.stmt
		);
	}

	function parseArrayList( arrListObj ) {
		var newArr = [];
		newArr.addAll( arrListObj );
		var pro    = parseArray( newArr );
		var cessed = pro.map( function( item ) {
			return item.data;
		} );
		return { "data" : cessed, "terminal" : true };
	}

	function parseStringValue( strObj ) {
		return {
			"data"     : strObj.getValue(),
			"terminal" : true
		};
	}

	function parseExpressionList( expObj ) {
		return {
			"data" : {
				"string"      : doParse( expObj.toString() ),
				"expressions" : doParse( expObj.getExpressions() ),
				"nodeType"    : "Expression"
			},
			"terminal" : true
		};
	}

/**
 * Parses a struct by looping over its keys and sending each node to doParse
 * @arr The array being parsed
 */
	function parseStruct( item ) {
		var retme = {};
		item.keyArray()
			.each( function( key ) {
				if ( !isNull( item[ key ] ) ) {
					retme[ key ] = doParse( item[ key ] );
				}
			} );
		return {
			"data"     : retme,
			"terminal" : true,
			"nodeType" : "struct"
		};
	}

/**
 * Parses an array by mapping over it and sending each key to doParse
 * @arr The array being parsed
 */
	private function parseArray( arr ) {
		var retme = arr.map( function( item ) {
			return {
				"data"     : doParse( item ),
				"terminal" : false,
				"nodeType" : "Array"
			};
		} );
		return retme;
	}

	private function parseColumn( colObj ) {
		return {
			"data" : {
				"name"     : colObj.getColumnName(),
				"fullName" : colObj.getFullyQualifiedName(),
				"string"   : colObj.toString(),
				"table"    : colObj.getTable(),
				"nodeType" : "column"
			},
			"terminal" : true
		};
	}

	private function parseIfElse( ifElseObj ) {
		return {
			data : {
				"if"       : doParse( ifElseObj.getIfStatement() ),
				"else"     : doParse( ifElseObj.getElseStatement() ),
				"nodeType" : "ifElse"
			},
			terminal : false
		};
	}

	function parseInsert( instObj ) {
		return {
			"data" : {
				"columns"   : instObj.getColumns(),
				"string"    : instObj.toString(),
				"table"     : instObj.getTable(),
				"itemsList" : instObj.getItemsList(),
				"nodeType"  : "Insert"
			},
			"terminal" : false
		};
	}

	function parseTable( tableObj ) {
		return {
			"data" : {
				"name"     : tableObj.getName(),
				"fullName" : tableObj.getFullyQualifiedName(),
				"schema"   : tableObj.getSchemaName(),
				"nodeType" : "Table"
			},
			"terminal" : true
		};
	}

	function parseUpdate( updateObj ) {
		var retme = {
			"data" : {
				"table"        : doParse( updateObj.getTable() ),
				"where"        : doParse( updateObj.getWhere() ),
				"updateFields" : doParse( updateObj.getUpdateSets() ),
				"nodeType"     : "update"
			},
			"terminal" : true
		};
		return retme;
	}

	function parseUpdateSet( updateSetObj ) {
		return {
			"data" : {
				"column"     : doParse( updateSetObj.getColumns() )[ 1 ],
				"expression" : doParse( updateSetObj.getExpressions() )[ 1 ],
				"nodeType"   : "updateset"
			},
			"terminal" : true
		};
	}
	function parseAndExpression( andObj ) {
		var orig = splitAnd( andObj.getLeftExpression(), andObj.getRightExpression() );

		return {
			"data"     : doParse( orig ),
			"terminal" : false
		};
	}

	function splitAnd( left, right, full ) {
		var retme         = [];
		var leftclassName = left.getClass().getName();
		if ( leftclassName == "net.sf.jsqlparser.expression.operators.conditional.AndExpression" ) {
			var g = splitAnd(
				left.getLeftExpression(),
				left.getRightExpression(),
				false
			);
			g.each( function( item ) {
				if ( item.getClass().getName() == "net.sf.jsqlparser.expression.operators.relational.EqualsTo" ) {
					retme.append( item );
				} else {
					retme.addAll( g );
				}
			} );
		} else {
			retme.append( left );
		}

		if ( right.getClass().getName() == "net.sf.jsqlparser.expression.operators.relational.EqualsTo" ) {
			retme.append( right );
		}
		/*if(full){
			return {
				"data":retme,
				"terminal":"true"
			};
		}*/
		return retme;
	};

	function parseEqualsTo( eqObj ) {
		return {
			"data" : {
				"right"    : doParse( eqObj.getRightExpression() ),
				"left"     : doParse( eqObj.getLeftExpression() ),
				"string"   : eqObj.toString(),
				"symbol"   : "=",
				"nodeType" : "equalsto"
			},
			"terminal" : true,
			"nodeType" : "EqualsTo"
		};
	}

	function parseNamedParameter( parObj ) {
		return {
			"data" : {
				"string"   : parObj.toString(),
				"name"     : parObj.getName(),
				"nodeType" : "JdbcNamedParameter"
			},
			"terminal" : true
		};
	}



	function parseSelect( qSelObj ) {
		return {
			"data"     : doParse( qSelObj.getSelectBody() ),
			"terminal" : true,
			"nodeType" : "select"
		};
	}

	function parseOutField( qSel ) {
		var retme = {};
		qsel.each( function( item ) {
			retme[ item.toString() ] = {
				name  : item.toString(),
				alias : item.getAlias()
			};
		} );
		return retme;
	}

	function parseSelectExpressionItem( SeiObj ) {
		return {
			"data" : {
				"string" : SeiObj.toString(),
				"alias"  : doParse( SeiObj.getAlias() ),
				"field"  : doParse( SeiObj.getExpression() )
			},
			"terminal" : true
		};
	}


	function parseOrderByElement( sQsl ) {
		return {
			"data" : {
				"field" : doParse( sQsl.getExpression() ),
				"order" : sQsl.isAsc() ? "asc" : "desc"
			},
			"terminal" : true
		};
	}

	function parseSql( stmt ) {
		return createObject( "JAVA", "net.sf.jsqlparser.parser.CCJSqlParserUtil" ).parse( stmt )
	}

	function parseLongValue( lvObj ) {
		return {
			"data"     : lvObj.toString(),
			"terminal" : true
		};
	}



	function parsePlainSelect( qObj ) {
		return {
			"data" : {
				statement  : qObj.toString(),
				select     : doParse( qobj.getSelectItems() ),
				distinct   : doParse( qobj.getDistinct() ),
				top        : doParse( qObj.getTop() ),
				where      : doParse( qObj.getWhere() ),
				joins      : doParse( qObj.getJoins() ),
				groupBy    : doParse( qObj.getGroupBy() ),
				having     : doParse( qObj.getHaving() ),
				from       : doparse( qobj.getFromItem() ),
				order      : doParse( qobj.getOrderByElements() ),
				intoTables : doParse( qobj.getIntoTables() )
			},
			"terminal" : true
		};
	}

	function parseAllColumns( acObj ) {
		return {
			"data"     : acObj.toString(),
			"terminal" : true
		};
	}

	function orderDict( orderArr ) {
		var retme = {};
		orderArr.each( function( item, idx ) {
			retme[ item.field.name ] = {
				"name"     : item.field.name,
				"position" : idx,
				"order"    : item.order,
				"nodeTyle" : "orderDictionary"
			};
		} );
		return retme;
	}

	function parseDelete( delObj ) {
		return {
			"data" : {
				"table"            : doParse( delObj.getTable() ),
				"limit"            : doParse( delObj.getLimit() ),
				"tables"           : doParse( delObj.getTables() ),
				"modifierPriority" : doParse( delObj.getModifierPriority() ),
				"withItems"        : doParse( delObj.getWithItemslist() ),
				"using"            : doParse( delObj.getUsingList() ),
				"where"            : doParse( delObj.getWhere() ),
				"joins"            : doParse( delObj.getJoins() ),
				"nodeType"         : "Delete"
			},
			"terminal" : true
		};
	}


	/**
	 * Load the library
	 *
	 * @throws ClassNotFoundException - When bcrypt can't be classloaded
	 */
	private void function loadSQLParser() {
		tryToLoadSqlParserFromClassPath();

		if ( !isSqlParserLoaded() ) {
			tryToLoadSqlParserWithJavaLoader();
		}

		if ( !isSqlParserLoaded() ) {
			throw(
				type   : "ClassNotFoundException",
				message: "SqlParser not successfully loaded.  jsqlparser-4.3.jar must be present in the ColdFusion classpath or at the setting javaloader_libpath.  No operations are available."
			);
		}
	}

	public any function loadSQLParserElement( required string className ) {
		var retme = ""
		try {
			retme = createObject( "java", arguments.className );
		} catch ( any error ) {
			try {
				retme = variables.javaLoader.create( "net.sf.jsqlparser.parser.CCJSqlParserUtil" );
			} catch ( any err ) {
				throw(
					type   : "ClassNotFoundException",
					message: "#className# not successfully loaded.  jsqlparser-4.3.jar must be present in the ColdFusion classpath or at the setting javaloader_libpath.  No operations are available."
				);
			}
		}
		return retme;
	}

	/**
	 * Try to load if java lib in CF Path
	 */
	private void function tryToLoadSqlParserFromClassPath( className = "net.sf.jsqlparser.parser.CCJSqlParserUtil" ) {
		try {
			variables.sqlparser = createObject( "java", arguments.className );
		} catch ( any error ) {
		}
	}

	/**
	 * Load via module
	 */
	private void function tryToLoadSqlParserWithJavaLoader() {
		try {
			variables.sqlparser = variables.javaLoader.create( "net.sf.jsqlparser.parser.CCJSqlParserUtil" );
		} catch ( any error ) {
		}
	}

	/**
	 * Is Sqlparser loaded
	 */
	private boolean function isSqlParserLoaded() {
		return !isNull( variables.sqlparser );
	}

}
