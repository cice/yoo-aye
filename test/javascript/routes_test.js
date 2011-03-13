$(document).ready(function(){
  
  module('Routes');  
  
  test("load", function(){
    equal($.type(yoo_ay.routes.javascript_tests), "function")
  });
  
  test("generate simple route", function() {
    equal(yoo_ay.routes.javascript_tests(".json"), "/javascript_tests.json");
  });

  test("generate route with js format", function() {
    equal(yoo_ay.routes.javascript_tests(".js"), "/javascript_tests.js");
  });
  
  test("generate route with param", function() {
    equal(yoo_ay.routes.javascript_test("whatever", ".json"), "/javascript_tests/whatever.json");
  });
  
  test("generate route with object param", function() {
    var obj = {id: "whatever"};
    
    equal(yoo_ay.routes.javascript_test(obj, ".json"), "/javascript_tests/whatever.json");
  });
  
  test("jQuery integration", function() {
    var sandbox = $('#sandbox');
    
    sandbox.html("<div id='test-widget' data-resource-type='javascript_tests'></div>");    
    equal($('#test-widget').route(".json"), "/javascript_tests.json");
    
    sandbox.html("<div id='test-widget2' data-resource-type='javascript_test' data-resource-id='whatever'></div>");    
    equal($('#test-widget2').route(".json"), "/javascript_tests/whatever.json");
    
    sandbox.html("<div id='test-widget2' data-resource-location='/javascript_tests/whatever' data-resource-type='javascript_test' data-resource-id='whatever'></div>");    
    equal($('#test-widget2').route(".json"), "/javascript_tests/whatever.json");
  });
});