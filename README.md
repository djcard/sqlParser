# sqlParser
A CFML wrapper to the JSQLParser project at https://github.com/JSQLParser/JSqlParser

This is a work in progress both from a functional and a testing
point of view. I estimate it is about 60% complete with additional
components of the underlying project being wrapped as needed. PRs welcome.

Uses: Primarily for automated testing. I've been using it as part of a testbox suite which, at its simplest, 
checks to the see if the SQL statment can be parsed at all. This doesn't compare against a database but is a quick way to 
ensure no typos, punctuation, etc has been altered. Additionally, it allows automated tests to be done on a more granular level.

To Install:

install with CommandBox `box install sqlParser`


Usage (TestBox Example)

`it("The sql should be parsable",function(){`

`var parsedSql = getInstance("SqlParser@SqlParser").parseStatements(oneOrMoreSqlStatements);
    expect(parsedSql).tobetypeof("array");
});`


`it(title  = "The sql should call from blah table ", labels = "", body   = function() {
expect(parsedSql.from.name).tobe("blah");
});`


The result is an array with each index being one statemnt. 

Notes: 
1. If a nodeType has not been implemented yet, it will be in place but as a Java Class. If you do a writeDump() of your parsed statement, you'll see it.
   
2. The jsqlpparser-4.3.jar is included in the lib folder. If nothing else, cbJavaLoader will attempt to load the parser at run time but you can also place the jar file in the "jars" folder of your Coldbox install and restart your server (if using CommandBox).

For more information about using additional jars in your CommandBox sites see https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/adding-custom-libs
   

