$(function(){
  var sandbox = $('#sandbox');
  $(" <div id='test_widget'>\
        <ul class='a-list'>\
          <li class='a-list-item'></li>\
        </ul>\
        <div class='some-div'></div>\
      </div>").appendTo(sandbox);
  
  var test_behavior = {
    setup: function(wdgt) {
      this.fooBar = 'baz';
    },
    
    ".a-list-item": { click: function() {
      this.widget.data('foo', 'bar');
      this.fooBar = 'foobar';
    }},
    
    'this': {'custom:event': function() {
      this.widget.data('baz', 'buz');
    }}
  };
  
  var tw = $('#test_widget');
  tw.behavior(test_behavior);
  
  module('Behaviors');  
  
  test("apply", function(){
    equals(tw.behavior().fooBar, 'baz');
    
    $('.a-list-item:first').trigger('click');
    
    equals(tw.data('foo'), 'bar');
    equals(tw.behavior().fooBar, 'foobar');
    
    tw.trigger('custom:event');
    
    equals(tw.data('baz'), 'buz');
  });

  test("remove", function(){
    tw.behavior('remove');
    equals(tw.behavior(), null);
  });
});