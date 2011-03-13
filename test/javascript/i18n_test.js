$(function(){
  $.i18n.de = {
    strings: {
      foo: "FOO",
      bar: {
        baz: "BAZ",
        buz: {
          fup: "FUP"
        }
      }
    }
  };
  
  $.i18n.setLocale('de');
  
  module("Internationalization");
  test("String lookup", function() {
    equals($._('foo'), 'FOO');
    equals($._('bar.baz'), 'BAZ');
    equals($._('bar.buz.fup'), 'FUP');    
  });
});