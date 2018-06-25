function initFlashMessagesCloseButtons(){
	$('.close').remove();
	var imgBtn = $(this).find('.close');
  var close_button = document.createElement('div');
  $(close_button)
  .addClass("close")

  .prependTo('#flash .wrapper div')
  .click(function(){
    $(this).closest('.wrapper').fadeOut('fast');
  });
}

$(function(){
  initFlashMessagesCloseButtons();
  $('#experience-btn').click(function() {
     window.location.href = '/experience';
  });
  $('#referral-btn, #refer-a-friend-btn').click(function() {
     window.location.href = '/referral';
  });
  $('#iac-register-btn').click(function() {
     window.location.href = '/signup';
  });
  $('#business-btn').click(function() {
     window.location.href = '/company';
  });
  $('#try-now-btn, #start-now, .browser-logo-enabled').click(function() {
     window.location.href = '/mm-extension';
  });
  $('#try-now-btn-lite').click(function() {
     window.location.href = '/mm-extension-lite';
  });

  $('#business-signup-offer1').click(function() {
      window.location.href = '/company/signup_original';
  });
  $('#business-signup-offer2').click(function() {
     window.location.href = '/company/signup_premium';
  });

  $('#experience-mbook-zoom').mouseover(function() {
      $('#experience-popup3').fadeIn(500);
      $('#experience-popup-backdrop').fadeIn(500);
  });
  $('#experience-imac-zoom').mouseover(function() {
      $('#experience-popup2').fadeIn(500);
      $('#experience-popup-backdrop').fadeIn(500);
  });
  $('#experience-monitor3-zoom').mouseover(function() {
      $('#experience-popup1').fadeIn(500);
      $('#experience-popup-backdrop').fadeIn(500);
  });
  $('#experience-popup1-close, #experience-popup2-close, #experience-popup3-close').click(function() {
     $(this).parent().fadeOut(300);
     $('#experience-popup-backdrop').fadeOut(300);
  });
});

var stateEventAttached = false;
function simpleAjaxPagination(loaderTargetSelector) {
  $(loaderTargetSelector + ' .pagination a,' + loaderTargetSelector + ' th a').on('click',function (e){
    e.preventDefault();
    History.pushState({loaderTargetSelector: loaderTargetSelector}, document.title, this.href);
    return false;
  })

  if(!stateEventAttached) {
    stateEventAttached = true;
    $(window).bind('statechange', function(){
      var state = History.getState();
      showLoader($(state.data.loaderTargetSelector || loaderTargetSelector));
      $.getScript(state.url)
    });
    var state = History.getState();
    if(state.url != location.href) {
      showLoader($(state.data.loaderTargetSelector || loaderTargetSelector));
      $.getScript(state.url)
    }
  }
}

function initDialog(dialogContent, dialogLink, options) {
  options = options || {};
  $(dialogContent).dialog( $.extend({
    autoOpen: false,
    width: 660,
    minWidth: 200,
    minHeight: 200
  }, options) );

  $(dialogLink).on('click', function(e){
    e.preventDefault();
    var dc = $(dialogContent);
    dc.dialog( "open" );

     if(options.showLoader) {
       dc.html('');
       showLoader(dc);
     }
     if(options.callback) {
       options.callback.call(this)
     }
  });
}

function initTabsNav(tabsUl, tabIdSuffix) {

  var showTab = function(tabId){
    var tab = $('#' + tabId + tabIdSuffix);
    var link = $('#' + tabId + '-tab-link')

    if(!tab.length || !link.length) return;

    var activeTab = $('.tab-content:visible');
    if(activeTab.length &&
      activeTab[0].id.replace(new RegExp(tabIdSuffix + '$'), '') == tabId
    ) return;

    tabsUl.find('li').removeClass('active');
    link.closest('li').addClass('active');

    if(activeTab.length) {//lock height so thers no jumping
      activeTab.parent().height(activeTab.parent().height())
    }
    $('.tab-content').hide();

    location.hash = tabId
    tab.fadeIn();
    if(activeTab.length) {
      activeTab.parent().css('height', 'auto');
    }
  }

  $(function(){
    if(location.hash) {
      var tabId = location.hash.replace(/^#/, '');
      showTab(tabId)
    }
  });


  tabsUl.find('li').on('click', function(e){
    e.preventDefault();
    var tabId = $(this).find('a')[0].id.replace('-tab-link','');
    showTab(tabId);
  });
}

function isInView(element) {
  var st = $(document).scrollTop(),
      ot = $(element).offset().top,
      wh = (window.innerHeight && window.innerHeight < $(window).height()) ? window.innerHeight : $(window).height();
  return ot > st && ($(element).height() + ot) < (st + wh);
}
