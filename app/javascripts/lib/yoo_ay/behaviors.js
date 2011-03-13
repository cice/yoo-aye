yoo_ay.behaviors = yoo_ay.behaviors || {};

yoo_ay.behaviors.base = function(behavior) {
  function behavior_class(widget) {
    this.widget = widget;
    this.events = [];
    this.delegates = [];
    
    $(widget).data('_behavior', this);
    this.registerWidgetEvents();
    this.registerDelegatesAndMethods();
    this.setup();
  }

  var widget_events = behavior['this'] || {};
  delete behavior['this'];
  
  var setup = behavior['setup'] || (function(){});
  delete behavior['setup'];
  
  var teardown = behavior['teardown'] || (function(){});
  delete behavior['teardown'];

  $.extend(behavior_class.prototype, {
    setup: setup,
    teardown: teardown,
    remove: function() {
      this.teardown();
      this.unregisterWidgetEvents();
      this.unregisterDelegates();
      $(this.widget).data('_behavior', null);
      this.events = [];
      this.delegates = [];
      this.widget = null;
      
      return this;
    },
    unregisterWidgetEvents: function() {
      var t = this;
      $.each(this.events, function() {
        $(t.widget).unbind(this.event, this.handler);
      });
    },
    unregisterDelegates: function() {
      var t = this;
      $.each(this.delegates, function() {
        $(t.widget).undelegate(this.selector, this.event, this.handler);
      });
    },
    applyHandler: function(handler) {
      var t = this;
      return (function() {
        return handler.apply(t, arguments);
      });
    },
    registerWidgetEvents: function() {
      var t = this;
      $.each(widget_events, function(event, handler) {
        var applied_handler = t.applyHandler(handler);
        t.events.push({event: event, handler: applied_handler});
        $(t.widget).bind(event, applied_handler);
      });
    },
    registerDelegates: function(selector, handlers) {
      var t = this;
      $.each(handlers, function(event, handler) {
        var applied_handler = t.applyHandler(handler);
        t.delegates.push({selector: selector, event: event, handler: applied_handler});
        $(t.widget).delegate(selector, event, applied_handler);
      });
    },
    registerDelegatesAndMethods: function() {
      var t = this;
      $.each(behavior, function(selector_or_name, handlers_or_function) {
        if($.type(handlers_or_function) == 'function') {
          t[selector_or_name] = handlers_or_function;
          return;
        }
      
        t.registerDelegates(selector_or_name, handlers_or_function);
      });
    }
  });
  
  return behavior_class;
};

$.behavior = function(behavior) {
  return yoo_ay.behaviors.base(behavior);
};

$.fn.behavior = function(behavior, options) {
  var t = $(this);
  var return_value;
  
  switch($.type(behavior)) {
  case "function":
    return_value = new behavior(this);
    break;
  case "object":
    return_value = new ($.behavior(behavior))(this);
    break;
  case "string":
    return_value = t.behavior()[behavior](options);
    break;
  default:
    return_value = t.data('_behavior');
  }
  
  return return_value;
};

$b = function(selector, behavior) {
  return $(selector).behavior(behavior);
};