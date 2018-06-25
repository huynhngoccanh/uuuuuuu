// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require typeahead.js/dist/typeahead.bundle.js

$(function() {

  var search = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/api/v1/autocompletes/search?q=%QUERY'
  });
  search.initialize();
  var k = $("#search").typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    selected: function() {
    }
  }, {
    itemText: 'slug',
    displayKey: 'name',
    source: search.ttAdapter()
  }).bind('typeahead:selected', function(obj, datum, name) {  
    window.location.href = "/merchants/"+datum.slug+"/coupons";
  });

})
