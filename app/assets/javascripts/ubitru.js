
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require typeahead.js/dist/typeahead.bundle.js
//= require bootstrap/js/modal.js
//= require popModal
//= require general
//= require search
//= require noty/jquery.noty
//= require noty/layouts/bottom
//= require noty/themes/default
//= require zeroclipboard
//= require coupon_modal
//= require cashback_modal
// expires_at soon




$(function(){
$('.css-checkbox').change(function(){
  $('.merchant-filters').submit();
});

});


$(function(){
  $('#button_not').click(function(){
    $('.chck').prop('checked',false);

  });
});

function auth() {
 var config = {
    'client_id': '102906306413-onu41nqlm39i5vak4vjh3i7j3ebk63av.apps.googleusercontent.com',
    'scope': 'https://www.google.com/m8/feeds'
  };
  gapi.auth.authorize(config, function() {
    fetch(gapi.auth.getToken());
  });
}
function fetch(token) {
    $.ajax({
        url: "https://www.google.com/m8/feeds/contacts/default/full?access_token=" + token.access_token + "&alt=json",
        dataType: "jsonp",
        success:function(data) {
          console.log(JSON.stringify(data, null, "\t")) ;
          for(var i = 0; i < data.feed.entry.length; i++){
            $('#email-container').append("<tr><td>"+JSON.stringify(data.feed.entry[i].gd$email[0].address, null, "\t")+"</td><td><input type='radio' class='referral-email' value='"+data.feed.entry[i].gd$email[0].address+"' name='key'/></td></tr>");
          }
        }
    });
}

$( function() {
$('#radiusFilter').change(function() {
$('#rFilter').submit();
});
});


// end
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


  var searchServices = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/api/v1/autocompletes/services?q=%QUERY'
  });

  searchServices.initialize();

  var k1 = $("#services-autocomplete").typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    selected: function() {
    }
  }, {
    displayKey: 'name',
    source: searchServices.ttAdapter()
  }).bind('typeahead:selected', function(obj, datum, name) {
    openServiceModal(datum.id,"undefined",datum.name);

  });


  $(document).on("click",".referral-email", function(){
    $("#invite_user_email").val($(this).val());
  });

  $(document).on("click", ".open-service-modal", function(e) {
    openServiceModal($(e.target).data("taxon_id"), $(e.target).data("taxon_name"));
    return false;
  })

  $(document).on("submit", ".services-search", function() {
    openServiceModal($(".taxans-select").val());
    return false;
  })

  $(document).on("submit", ".services-keyword-search", function() {
    openServiceModal(null, null, $("#services-autocomplete").val());
    return false;
  })

  $('#qualified_popup_button').click(function(){
    $('#qualified_popup').modal("show");
    $('.scr').css({'display':'block'})
    $('.close-reveal-modal').click(function(){
      $('.scr').css({'display':'none'})
    });

  });


  var openServiceModal = function(taxon_id, taxon_name, keyword) {
    global_taxon_id = taxon_id;
    global_taxon_name = taxon_name;
    global_keyword = keyword;
    serviceTemplate = $('#services_modal').clone();
    serviceTemplate.modal("show");
  }

  $(document).on("submit", ".zip-form", function() {

    serviceTemplate.find(".service-loader").removeClass("hide");
    $.get("/api/v1/taxons/search.json", {zip: serviceTemplate.find("#zip-code").val(), taxon_id: global_taxon_id, q: global_keyword }, function(data) {
      serviceTemplate.find(".service-loader").addClass("hide");
      serviceTemplate.find(".zip-code").addClass("hide");
      serviceTemplate.find(".results").removeClass("hide");
      var body = ""
      if(data.length == 0) {
        body = body + "<tr><td colspan='5'>No results found</td></tr>"
      } else {
        $.each(data, function(index, result) {
          body = body + "<tr><td class='align-left'>"+result.name+"</td>"+
          "<td class='align-center'>"+result.cashback+"</td>"+
          "<td class='align-center'><a class='view-number' href='#' data-href='"+result.link+"' data-cashback = "+result.cashback+"><i class='fa fa-phone'></i>View Number</a></td></tr>";
        });
      }
      $(".results-table tbody").html(body)
    });
    return false;
  })

  $(document).on('click','.nav-btn',function(){
    if ($('.main-nav').css('right') != '-10px'){
      $('.main-nav').animate({right: '-10px'},300);
    } else {
      $('.main-nav').animate({right: '-320px'},300);
    }
  });

  $(document).on('click','#cat-link',function(){
    if ($('.nav-scr').css('visibility')=="hidden"){
      $('.nav-scr').css({visibility:"visible"});
      console.log('kajskj');
    } else {
      $('.nav-scr').css({visibility:"hidden"});
      console.log('1112321');
    }
  });



  $(document).on("click", ".view-number", function(e) {
    var href = $(e.target).data("href");
    if(global_taxon_name == "undefined") {
      var taxon_name = global_keyword;
    } else {
      var taxon_name = global_taxon_name;
    }
    var cash_back = $(e.target).data("cashback");
    $(e.target).find("i").removeClass("fa-phone").addClass("fa-spinner").addClass("fa-spin")
    $.post("/api/v1/taxons/get_number.json", {href: href ,zip: serviceTemplate.find("#zip-code").val(), cashback: cash_back, keyword: taxon_name}, function(data) {
      $(e.target).parent(".align-center").html("<a href=tel:1"+data.number+">"+data.number+"</a>")
    })
    return(false);
  })



	var ScreenWidth = window.innerWidth;

	if(ScreenWidth <= 767) {
		$('.category-drop-down > li > a').attr("href", "javascript:void(0);");
		$('.category-drop-down > li > a').click(function() {
			$(this).next('.dropdown').toggle();
		});
	}

	$('#cat-link').bind("click", function() {
		$('.category-drop-down').slideToggle();
    $('.nav-scr').css({'display':'block'});
	});



  var ScreenWidth = window.innerWidth;

  if(ScreenWidth <= 767) {
    $('.men-drop-down > li > a').attr("href", "javascript:void(1);");
    $('.men-drop-down > li > a').click(function() {
      $(this).next('.dropdown').toggle();
    });
  }

  $('#men-link').bind("click", function() {
    $('.men-drop-down').slideToggle();
  });

  $(document).on("click", ".coupon-code", function(event) {
    window.open($(this).data("show_url"), '_blank').focus();
  })

  $(document).on("click", ".coupon-view", function(event) {
    event.preventDefault()
    
    $("#modal").find('.modal-dialog').html('<p style="text-align: center; padding: 50px 20px">Loading ....</p>')
    $("#modal").modal("show");

    $.get($(this).attr('href'), function(data) {
      $("#modal").find('.modal-dialog').html(data)
    })
    return false;
  })

  $(document).on("click", "#merchant-pat", function(event){
    window.open('/merchants/'+$(this).data("merchant_id")+'/redirect', '_blank').focus();
  })

  $(document).on("click", ".merchant-popup", function(event) {
    var template = $("#footer-links").clone();
    template.modal("show");
    $.get("/api/v1/merchants/"+$(event.target).data("merchant_id")+".json", function(data) {
      template.find(".data-loading").addClass("hide");
      template.find(".popup-content").removeClass("hide");
      template.find(".inline-link").attr("href", "/validate_session?return_to=" + data.redirection_link);
      template.find(".inline-link").text(data.name);
      template.find(".btn-link").text("GO TO " + data.name);
      template.find(".btn-link").attr("href", "/validate_session?return_to=" + data.redirection_link);
      template.find(".logo img").attr("src", data.image_url)
    })
    return false;
  })

  $(document).on("click", ".submit-coupon-btn", function(e) {
    submit_coupon_template = $("#submit_coupon").clone();
    submit_coupon_template.modal("show");
  })

  $(document).on("click", ".review", function() {

  });

  $(document).on("click", ".coupon-types a", function(e) {
    $(".coupon-types a").removeClass("active")
    $(e.target).addClass("active")
    if($(e.target).data("coupon_type") == "printable") {
      $(".print-block").removeClass("hide");
      $(".url-block").removeClass("hide");
      $(".code-block").addClass("hide");
    }else if($(e.target).data("coupon_type") == "tip"){
      $(".url-block").addClass("hide");
      $(".print-block").addClass("hide");
      $(".code-block").addClass("hide");
    }else {
      $(".url-block").addClass("hide");
      $(".print-block").addClass("hide");
      $(".code-block").removeClass("hide");
    }
  });

  $(document).on("submit", ".coupons-form", function(e) {
    var couponForm = $(e.target);
    var file_data = couponForm.find("#print").prop("files")[0];
    var form_data = new FormData();
    if(file_data) {
      form_data.append("coupon[print]", file_data);
    }
    form_data.append("coupon[description]", couponForm.find("#discount_desc").val());
    form_data.append("coupon[code]", couponForm.find("#code").val());
    form_data.append("coupon[coupon_type]", couponForm.find(".coupon-types a.active").data("coupon_type"));
    form_data.append("coupon[temp_website]", couponForm.find("#website").val());
    form_data.append("coupon[expires_at]", couponForm.find("#expiration").val());
    form_data.append("coupon[ad_url]", couponForm.find("#url").val());

    $.ajax({
      url: "/api/v1/coupons.json",
      dataType: 'script',
      cache: false,
      contentType: false,
      processData: false,
      data: form_data,
      type: 'post'
    }).always(function(data) {
      var response = JSON.parse(data.responseText)
      if(typeof(response.success) == "undefined") {
        noty({text: "Thanks, we will post your coupon shortly.", type: "success"});
        submit_coupon_template.modal('hide');
      } else {
        noty({text: response.message, type: "error"});
      }
    });
    return(false);
  })


$(document).on("click", ".review", function(e) {

    var couponForm = $(e.target).parent().parent();
    var file_data = couponForm.find("#print").prop("files")[0];
    var form_data = new FormData();
    if(file_data) {
      form_data.append("coupon[print]", file_data);
    }
    form_data.append("coupon[description]", couponForm.find("#discount_desc").val());
    form_data.append("coupon[code]", couponForm.find("#code").val());
    form_data.append("coupon[coupon_type]", couponForm.find(".coupon-types a.active").data("coupon_type"));
    form_data.append("coupon[temp_website]", couponForm.find("#websit").val());
    form_data.append("coupon[expires_at]", couponForm.find("#expiration").val());
    form_data.append("coupon[ad_url]", couponForm.find("#url").val());

       $('#newcode').text(couponForm.find("#code").val());
       $('#coupon_header').text('Header details like "10% off"');
       $('#coupon_des').text(couponForm.find("#discount_desc").val());
       $('#coupon_date').text(couponForm.find("#expiration").val());
       $('#coupon_merchant').text(couponForm.find("#websit").val());
       $('#cou_type').text(couponForm.find(".coupon-types a.active").data("coupon_type"));
       submit_coupon_template = $("#preview_coupon").clone();
       submit_coupon_template.modal("show");

  })

  // $(document).on("click", "#cancel-preview'", function() {
  //   $('submit_coupon').show();
  // })



  $(document).on("click", ".shareBtn", function(e) {
    var placement_id = $(e.target).closest(".links").find(".shareBtn").data("placement_id");
    var shareURL = window.location.origin + $(e.target).closest(".links").find(".shareBtn").data("show_url");
    var addthis_share = {
      url: shareURL
    }
    console.log(shareURL);
    var currentScope = $(this);
    $('.shareModal_x'+placement_id).popModal({
      html: function(callback) {
        var content = '<div class="content01"><h4>Send this coupon to your friends or post it.</h4><div class="addthis_inline_share_toolbox_brgh" addthis:url="'+ shareURL +'" ></div></div>';
        callback(content);
        addthis.layers.refresh();

      },
      placement : 'bottomRight'
    });
    return false;
  })

})


$(document).ready(function() {
  $.noty.defaults = {
    layout: 'topCenter',
    theme: 'defaultTheme', // or 'relax'
    type: 'alert',
    text: '', // can be html or string
    dismissQueue: true, // If you want to use queue feature set this true
    template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>',
    animation: {
        open: {height: 'toggle'}, // or Animate.css class names like: 'animated bounceInLeft'
        close: {height: 'toggle'}, // or Animate.css class names like: 'animated bounceOutLeft'
        easing: 'swing',
        speed: 500 // opening & closing animation speed
    },
    timeout: 5000, // delay for closing event. Set false for sticky notifications
    force: false, // adds notification to the beginning of queue when set to true
    modal: false,
    maxVisible: 5, // you can set max visible notification for dismissQueue true option,
    killer: false, // for close all notifications before show
    closeWith: ['click'], // ['click', 'button', 'hover', 'backdrop'] // backdrop click will close all notifications
    callback: {
      onShow: function() {},
      afterShow: function() {},
      onClose: function() {},
      afterClose: function() {},
      onCloseClick: function() {},
    },
    buttons: false // an array of buttons
  };
  if ( !! noty_option) {
    noty(noty_option);
  }


  $('.like').click(function() {

    var row = $(this).closest('.like');
    // var userId = row.data("user_id");
    var resourceId = row.data("merchant_id");
    var resourceType = row.data("merchant_type")
    var user_favourite_id = row.data("user_favourite_id")
    var likeSate = row.data("like_state")

    if(user_favourite_id == 0) {
      $.ajax({
        url: '/api/v1/user_favourites.json',
        method: 'post',
        data: {user_favourite: {resource_id: resourceId, resource_type: resourceType}},
        success: function(data, status) {
          if(typeof(data.success) == "undefined") {
            noty({text: "Merchant added to favourite list.", type: "success"});
            row.addClass("change-color");
            row.data("user_favourite_id", data.id);
          } else {
            noty({text: data.message, type: "error"});
          }
        }
      });
    } else {
      $.ajax({
        url: '/api/v1/user_favourites/'+user_favourite_id+'.json',
        method: 'delete',
        data: {user_favourite: {resource_id: resourceId}},
        success: function(data, status) {
          if(data.success){
            noty({text: "Merchant removed to favourite list.", type: "notice"});
            row.removeClass("change-color");
            row.data('user_favourite_id', 0);
          } else {
            noty({text: "Something went wrong", type: "error"});
          }
        }
      });

    }
    return !$(row).data("signed_in");
  });




  $('.thumb').click(function() {

    var row = $(this).closest('.thumb');
    var sibling = $(this).siblings();
    var userId = row.data("user_id");
    var resourceId = row.data("merchant_id");
    var resourceType = row.data("merchant_type");
    var user_like_id = row.attr('data-user_like_id');
    var status_value = row.attr('data-status_value');
    var likeSate = row.data("like_state")
    console.log(status_value);
    if( status_value == 0) {
      if (user_like_id != 0 ) {
        console.log(sibling)
        sibling.attr('data-status_value', 0);
        sibling.removeClass('fa fa-thumbs-down');
        sibling.html('<i class="fa fa-thumbs-o-down" aria-hidden="true"></i>');
      }
      row.removeClass('fa fa-thumbs-o-up');
      row.html('<i class="fa fa-refresh fa-spin"></i>')
      $.ajax({
        url: '/api/v1/likes.json',
        method: 'post',
        data: {user_like: {resource_id: resourceId, resource_type: resourceType , like: true, dislike: false}},
        success: function(data, status) {
          if(typeof(data.success) == "undefined") {

            console.log(data.id)
            row.addClass("change-color");
            row.attr('data-status_value', 1);
            row.attr('data-user_like_id', data.id);
            sibling.attr('data-user_like_id', data.id);
            row.removeClass('fa fa-refresh fa-spin');
            row.html('<i class="fa fa-thumbs-up" aria-hidden="true"></i>')
            noty({text: "This coupon added in your like list", type: "success"});
          } else {
            noty({text: data.message, type: "error"});
          }
        }
      });
    } else {
      row.removeClass('fa fa-thumbs-up');
      row.html('<i class="fa fa-refresh fa-spin"></i>')
      $.ajax({
        url: '/api/v1/likes/'+user_like_id+'.json',
        method: 'delete',
        data: {user_like: {resource_id: resourceId}},
        success: function(data, status) {
          if(data.success){
            // noty({text: "Merchant removed to favourite list.", type: "notice"});
            row.removeClass("change-color");
            row.attr('data-status_value', 0);
            row.attr('data-user_like_id', 0);
            row.removeClass('fa fa-refresh fa-spin');
            row.html('<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>');
            noty({text: "This coupon is added in your like list", type: "success"});
          } else {
            noty({text: "Something went wrong", type: "error"});
          }
        }
      });

    }
    return !$(row).data("signed_in");
  });




  $('.thumb_down').click(function() {

    var row = $(this).closest('.thumb_down');
    // var userId = row.data("user_id");
    var sibling = $(this).siblings();
    var resourceId = row.data("merchant_id");
    var resourceType = row.data("merchant_type")
    var user_like_id = row.attr('data-user_like_id');
    var status_value = row.attr('data-status_value');

    var likeSate = row.attr('data-like_state');

    if( status_value == 0) {
      if (user_like_id != 0 ) {
        console.log(sibling)
        sibling.attr('data-status_value', 0);
        sibling.removeClass('fa fa-thumbs-up');
        sibling.html('<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>');
      }
      row.removeClass('fa-thumbs-o-down');
      row.html('<i class="fa fa-refresh fa-spin"></i>')
      $.ajax({
        url: '/api/v1/likes.json',
        method: 'post',
        data: {user_like: {resource_id: resourceId, resource_type: resourceType , like: false, dislike: true}},
        success: function(data, status) {
          if(typeof(data.success) == "undefined") {
            // noty({text: "placement added to favourite list.", type: "success"});
            console.log(data.id)
            row.addClass("change-color");
            row.attr('data-status_value', 1);
            row.attr('data-user_like_id', data.id);
            sibling.attr('data-user_like_id', data.id);
            row.removeClass('fa fa-refresh fa-spin');
            row.html('<i class="fa fa-thumbs-down" aria-hidden="true"></i>')
            noty({text: "This coupon added in your dislike list", type: "success"});
          } else {
            noty({text: data.message, type: "error"});
          }
        }
      });
    } else {
      row.removeClass('fa fa-thumbs-down');
      row.html('<i class="fa fa-refresh fa-spin"></i>')
      $.ajax({
        url: '/api/v1/likes/'+user_like_id+'.json',
        method: 'delete',
        data: {user_like: {resource_id: resourceId}},
        success: function(data, status) {
          if(data.success){
            // noty({text: "Merchant removed to favourite list.", type: "notice"});
            row.removeClass("change-color");
            row.attr('data-status_value', 0);
            row.attr('data-user_like_id', 0);
            row.removeClass('fa fa-refresh fa-spin');
            row.html('<i class="fa fa-thumbs-o-down" aria-hidden="true"></i>');
            noty({text: "This coupon is removed from your dislike list", type: "success"});
          } else {
            noty({text: "Something went wrong", type: "error"});
          }
        }
      });

    }
    return !$(row).data("signed_in");
  });




});
