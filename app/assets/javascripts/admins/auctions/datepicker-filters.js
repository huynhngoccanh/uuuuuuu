$(function(){
  $('form#auctions-filters input.datepicker').change(function(){
    $('form#auctions-filters').submit();
  });
});