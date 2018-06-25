$(function(){

  $('select#user_age_range, select#user_sex, select#user_education, select#user_occupation, ' +
    'select#user_income_range, select#user_marital_status, select#user_family_size, select#user_home_owner, select#user_state_abbreviation').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "160",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });  
  
});