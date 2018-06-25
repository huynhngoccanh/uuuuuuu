module Vendors::TrackingEventsHelper
  def tracking_code
    url = create_vendor_tracking_event_url('visited', :v=>current_vendor.id)
    
    "<script type=\"text/javascript\">(function(){ 
var p = '#{VendorTrackingEvent::AUCTION_ID_PARAM_NAME}', q=location.search, rx = new RegExp('[?&]'+p+'=([^&]+)'), m=q.match(rx);
if(!m||!m.length) return; var c=document.cookie.match(/[;\s]?_mmaid=([^;]+)/);
if(!c || c[1] != m[1]) { var d = location.host, dc;
if((dc=d.match(/\./g)) && dc.length>1) d=d.replace(/^[^.]+\./,'')
d=d.replace(/\:.+$/,'')
document.cookie=\"_mmaid=\"+m[1]+'; expires=' + (new Date(2147483647000).toUTCString())+'; domain='+d;
var img = document.createElement('img');
img.src = '#{url}&a='+m[1]
}})()</script>"
  end
  
  def conversion_code
    url = create_vendor_tracking_event_url('converted', :v=>current_vendor.id)
    "<script type=\"text/javascript\">
(function(){var c=document.cookie.match(/[;\s]?_mmaid=([^;]+)/); if(!c||!c.length) return;
var img = document.createElement('img'); img.src = '#{url}&a='+c[1]
})()</script>"
  end
  
end
