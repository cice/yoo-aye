yoo_ay.routes = yoo_ay.routes || {};

$(function() {
  var callback = function(data, status, xhr) {
    $.each(data, function() {
      var t = this;
      
      yoo_ay.routes[t.name] = function() {
        var url = "", 
            a = arguments,
            al = a.length, 
            sl = t.segments.length;
            
        $.each(t.segments, function(index, segment) {
          var param = a[index];
          url += segment;
          
          if(param != null) {
            if($.type(param) == 'object')
              param = param.id;
            url += param;
          }
        });
        
        for(sl = sl; sl < al; sl++) {
          url += a[sl];
        }
        
        return url;
      };
    });
  };
  
  $.ajax({
    url: '/routes.json',
    data: { where: {verb: 'GET'}},
    dataType: 'json',
    async: false,
    success: callback
  });
  
  $.extend($.fn, {
    route: function(format) {
      var t = $(this),
          id = t.attr("data-resource-id"),
          name = t.attr("data-resource-type"),
          url = t.attr("data-resource-location");
      
      if(url != null)
        return url + format;
        
      if(name != null) {
        if(id != null) {
          return yoo_ay.routes[name](id, format); 
        }
        
        return yoo_ay.routes[name](format); 
      }
        
      
      return null;
    }
  });
});
