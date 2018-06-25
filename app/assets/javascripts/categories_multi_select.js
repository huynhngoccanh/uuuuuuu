$(function(){
  if(!$('select#root_category, select#add-category').length) return;
  
  var removeCategory = function(categoriesBox, categoryId) {
    var categoriesInputName = categoriesBox.data('input-name');
    var inputSelector = 'input[name="' + categoriesInputName + '"][value="' + categoryId + '"]';
    $(categoriesBox).find(inputSelector).remove();
    $(categoriesBox).find('.category_tag_id_' + categoryId).fadeOut('fast', function(){$(this).remove()});
  }

  var renderTag = function(categoriesBox, categoryId, categoryName) {
    $(categoriesBox).find('.category_tag_id_' + categoryId).stop(true,true)
    if(!$(categoriesBox).find('.category_tag_id_' + categoryId).length) {
      var tag = $('<div class="category_tag_id_' + categoryId + '" >').addClass("tag")
      .html('<span>'+categoryName+'</span>')
      .appendTo(categoriesBox)
      .hide().fadeIn('fast')

      $('<a href="#" class="close">x</a>')
      .appendTo(tag)
      .click(function(e){
        e.preventDefault();
        removeCategory(categoriesBox, categoryId);
      });  
    }
  }
  
  var addCategory = function(categoriesBox, categoryId, categoryName){
  	console.log(categoriesBox)
  	console.log(categoryId)
  	console.log(categoryName)
  	
  	var categoriesInputName = categoriesBox.attr('data-input-name'); 
    var inputSelector = 'input[name="' + categoriesInputName + '"][value="' + categoryId + '"]';

    if(!$(inputSelector).length) {
      $('<input name="' + categoriesInputName + '" value="' + categoryId + '" type="hidden" />')
      .appendTo(categoriesBox);
    }
    renderTag(categoriesBox, categoryId, categoryName)
  }
  
  var loadInitialTags = function(){
    $('.hidden-categories .checkbox input').each(function(){
      var $this = $(this);
      if(!$this.val()) return;
      var categoriesBox = $(this).parents('.inputs').find('.categories-tags');
      if(!categoriesBox.length) {
        categoriesBox = $(this).parents('form').find('.categories-tags');
      }
      renderTag(categoriesBox, $this.val(), $this.closest('.checkbox').find('label').text())
    })
  }
  
  $('.add-category-button').click(function(e){
    e.preventDefault();
    var selected = $(this).parent().find('option:selected:first');
    if(!selected.length || !selected.val())
      return;
    var categoriesBox = $(this).parents('.inputs').find('.categories-tags');
    if(!categoriesBox.length) {
      categoriesBox = $(this).parents('form').find('.categories-tags');
    }
    addCategory(categoriesBox, selected.val(), selected.text());
  })
  
  loadInitialTags();
  
  $('select#add-category, select#second_level_category, select#root_category, select#first_level_category').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "239",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
});