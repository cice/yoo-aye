yoo_ay = {};

yoo_ay.util = yoo_ay.util || {};

$.extend(yoo_ay.util, {
  // Prepend an element to an arguments pseudo-array
  prependArg: function(args, arg_to_prepend) {
    var new_args = [arg_to_append];
    $.each(args, function() {
      new_args.push(this);
    });
    
    return new_args;
  }
});