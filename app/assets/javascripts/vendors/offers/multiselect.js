$(function(){

  $('#offer_expiration_time_1i, #offer_expiration_time_3i, #offer_expiration_time_4i, #offer_expiration_time_5i').multiselect({
      header: false,
      selectedList: 1,
      height: "auto",
      minWidth: "80",
      multiple: false,
      classes: "multiselect-button multiselect-dropdown",
      position: {
        my: 'left top',
        at: 'left top'
      }
    });

  $('#offer_expiration_time_2i').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "105",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });

});