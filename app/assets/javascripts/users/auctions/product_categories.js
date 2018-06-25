$(document).ready(function(){
  
  $('select#root_category').change(function(){
    var category_id = $(this).val();
    var select = document.getElementById('first_level_category');
    loadCategories(category_id, select);
  });
  
  $('select#first_level_category').change(function(){
    var category_id = $(this).val();    
    var select = document.getElementById('second_level_category');
    loadCategories(category_id, select);
  });
  
});


function initCategorySelects(root_category, first_level_category, product_category_id){
  var select1 = document.getElementById('first_level_category');
  var select2 = document.getElementById('second_level_category');

  $.when(loadCategories(root_category, select1, first_level_category)).then(function(){
    loadCategories(first_level_category, select2, product_category_id)});

}


function loadCategories(category_id, select, selected_option){
  return $.ajax({
    type: "GET",
    url: "/load_product_categories",
    data: {
      id : category_id
    },
    dataType: "json",
    success: function(data){
      reloadCategorySelects(data, select, selected_option)
    }
  });
}

function reloadCategorySelects(data, select, selected_option){
  var the_lowest_select;

  if ( document.getElementById('second_level_category') != null )
    the_lowest_select = document.getElementById('second_level_category');
  else if ( document.getElementById('affiliation_second_level_category') != null )
    the_lowest_select = document.getElementById('affiliation_second_level_category');

  var addPrompt;
  if ( select.size <= 1 )
    addPrompt = true;
  else
    addPrompt = false;

  //remove old options and add the blank one
  if (select == the_lowest_select) {
    select.options.length = 0;
    if (addPrompt) {
      select.options.add(new Option("Select", ""));
    }
  } else {
    select.options.length = 0;
    the_lowest_select.options.length = 0;
    if (addPrompt) {
      select.options.add(new Option("Select", ""));
      the_lowest_select.options.add(new Option("", ""));
    }
  }

  var i, cat;
  for (i = 0; i < data.length; ++i) {
    cat = data[i];
    select.options.add(new Option(cat.name, cat.id, false, cat.id == selected_option ));
  }
  
  //refresh multiselects after reload selects
  if (select == the_lowest_select) {
    $('select#second_level_category').multiselect("refresh");
  } else {
    $('select#second_level_category').multiselect("refresh");
    $('select#first_level_category').multiselect("refresh");
  }
}

