KuduUI
=========

## Javascript Libraries

Set behaviors:

    $('#user_form').yoo_ay.form_dialog();
    $('#descriptions').yoo_ay.tabs();
    
* Widget: part of dom-tree starting (and including) at a specific node.
* Widget-Behavior: Javascript object to encapsulate behavior

    $('#user_form').behavior -> { ... }
    
* Resource-bound widget:
    
    %ul{:data => {:resource => 'users', :id => 42}}
    
or/amd parse Rails convention (DISCUSS)

    %ul#users_42
    
* New resource:

    %ul{:data => {:resource => 'users', :id => '_new'}}
    
    
### Route mapping

    routes.users()          -> "/users"
    routes.users.index()    -> { path: '/users', method: 'GET' }
    routes.users(42)        -> "/users/42"
    routes.users.show(42)   -> { path: '/users/42', method: 'GET' }
    routes.users.edit(42)   -> { path: '/users/42/edit', method: 'GET' }
    
    $('#user_widget').routes.show()
    
### jQuery AJAX convenience methods

    $('fieldset.new_user').remote.create()
    
#### Events

local:

    $('fieldset.new_user').bind('after:create', ...) ?
  
global:
    
    $('body').bind('resource:changed', function(evt, src, ?changed_resource_json?){})
    evt -> {
      resource: 'users',
      id: '42',
      change: 'update/create/delete'
    }
    
### local resource cache

update via conditional get (needs support on REST server side)

### Tier 1 resource objects?

i.e.

    users_resource
    users_resource.path
    users_resource(42).path
    users_resource.create
    users_resource(42).update

etc.

### Resource bound widget

    $('ul#users_42').remote.update()
    
should:
* collect attributes via 'serializeArray'
* provide possibility to define a custom attribute collector in Widget-Behavior

### pseudo data-binding

if a resourcebound widget has been submitted:

* either update local resource cache and notify other widgets bound to same resource / use  jQuery data-binding
* or all resource-bound widgets automatically observe resource:changed events and fire their update logic to refresh their
data/content
* fallbacks for browsers without local cache/storage


### container widgets

widgets bound to a list of data should always provide several ways to initialize/access/modify elements:

* apply widget behavior to existing container node: __ul__ etc
* access/modify/initialize via (data) list of javascript objects
* access/modify/initialize via (view) list of dom nodes