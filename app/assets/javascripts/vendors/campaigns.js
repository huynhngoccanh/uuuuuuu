function resolveMinMaxScoreVisibility(){
  var val = $('select#campaign_score_range').val()
  var enable = val == 'custom'
  $('#score-range-custom').toggle(enable);
  $('#score-range-custom input').attr('disabled', !enable);
  if(val && val.split('-').length == 2) {
    $('#campaign_score_min').data('changed', true).val(val.split('-')[0])
    $('#campaign_score_max').data('changed', true).val(val.split('-')[1])
  }
}

$(document).ready(resolveMinMaxScoreVisibility)
$('select#campaign_score_range').change(resolveMinMaxScoreVisibility)




function setCampaignStatusIcons() {
  $('button.campaign-status-multiselect span:last-child, div.campaign-status-multiselect ul.ui-multiselect-checkboxes li label span:last-child').each(function(){
    var txt = $(this).text().split(' ').join('_').toLowerCase();
    $(this).removeClass().addClass(txt);
  });
}

$(function(){  

  $('select#campaign_duration, select#campaign_score_range, select#campaign_offer_id').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: $('.simple_form.thinner').length ? "190" : "280",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
  $('select#campaign_status').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: $('.simple_form.thinner').length ? "110" : "",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown campaign-status-multiselect",
    position: {
      my: 'left top',
      at: 'left top'
    },
    create: function(){
      setCampaignStatusIcons();
    }
  });
  
  if($('.simple_form.thinner').length) {
    $('select#add-category, select#second_level_category, select#root_category, select#first_level_category').multiselect({
      header: false,
      selectedList: 1,
      height: "auto",
      minWidth: "143",
      maxWidth: "143",
      multiple: false,
      classes: "multiselect-button multiselect-dropdown",
      position: {
        my: 'left top',
        at: 'left top'
      }
    });
  }
  
  var changeCampaignStatus = function (campaign_id, status) {
    var type, url;

    if (status == 'delete') {
      type = "DELETE";
      url = '/campaigns/' + campaign_id;
    } else {
      type = "GET";
      url = '/campaigns/' + campaign_id + '/' + status;
    }

    $.ajax({
      url:url,
      type:type,
      dataType:"script"
    });
  }
  
  $('select#campaign_status').change(function () {
    var status = $(this).val();
    var campaignId = $(this).data('campaign');

    $("select#campaign_status").multiselect("refresh");
    setCampaignStatusIcons();

    if (status == 'delete') {
      var confirm = window.confirm("Are you sure?");
      if (confirm == true)
        changeCampaignStatus(campaignId, status);
      else
        return;
    } else {
      changeCampaignStatus(campaignId, status);
    }


  });
  
});