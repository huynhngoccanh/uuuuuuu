$(function(){
  
  $('select#second_level_category, select#root_category, select#first_level_category').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "280",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });  
  
  $('select#auction_service_category_id, select#auction_duration, select#auction_budget').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "280",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
  $('select#auction_min_vendors, select#auction_max_vendors').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "60",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
  $('select#contact-time-ofday').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "100",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
  $('select[name="auction[contact_way]"]').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "100",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
});