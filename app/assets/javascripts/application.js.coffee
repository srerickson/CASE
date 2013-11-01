#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require angular.min
#= require ui-bootstrap-tpls-0.6.0
#= require d3

#= require_self
#= require_tree ./frontend/vis_tools
#= require_tree ./frontend/evaluation_set

@app = angular.module "boi", [ "ui.bootstrap" ]


jQuery(()->
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
);
