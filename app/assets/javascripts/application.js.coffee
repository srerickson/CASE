#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require angular.min
#= require d3

#= require_self
#= require_tree ./vis_tools
#= require_tree ./evaluation_set

@app = angular.module "boi", []


jQuery(()->
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
);
