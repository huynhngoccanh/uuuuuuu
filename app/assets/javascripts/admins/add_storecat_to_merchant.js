// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
    
    $( document ).ajaxStart(function() {
        $(".loader").css("display","inline-block");
    });
    $( document ).ajaxStop(function() {
        $(".loader").hide();
    });
  
    $(document).on("change","#category",function(){
       var cat_id = $(this).val();
       $.ajax({
              type:'get',
              url: '/admin/add_storecat_to_merchant/get_merchants_list',
              data: {cat_id:cat_id},
              success:function(data){
                var len= data.length;
                var html = '<h3>Select Merchant</h3><select id="merchant">';
                for (var i=0; i<len; i++) {
                   
                   var type_id = first(data[i]);
                   if (type_id==1) {
                    var type = "Cj";
                   }
                   if (type_id==2) {
                    var type = "Pj";
                   }
                   if (type_id==3) {
                    var type = "Avant"
                   }
                   if (type_id==4) {
                    var type = "Linkshare"
                   }
                   if (type_id==5) {
                    var type = "Ir"
                   }
                 
                   html = html + '<option value="'+type+ "-" +data[i]['id']+'"  >'+ data[i]['name'] +'</option>';
                }
                html = html + '</select> &nbsp; <input type="button" id="AddMerchant" value="Add" />';
                $(".merchant_content").html(html).show();
                
              }
       });
    });
    
    function first(obj) {
    for (var a in obj) return a;
     }
    
    $(document).on("change","#category",function(){
       var cat_id = $("#category").val();
       $.ajax({
              type:'get',
              url: '/admin/add_storecat_to_merchant/get_selected_merchants_list',
              data: {cat_id:cat_id},
              success:function(data){
                var html = '<h3>Added Merchants List</h3><div class="input tags advertisers-tags">';
                len = data.length;
                for(var i = 0; i<len; i++){
                    item = data[i];
                        var name = item[0]['name'];
                        html =  html + '<div class="tag "> &nbsp; '+name +' | <span title="Remove" class="removeMarchant" id="rem-'+item[1]+'">X</span></div>';
                }
                html = html + "</div>";
                $(".selected_merchant_content").html(html).show();
               
              }
       });
    });
    
     $(document).on("click",".removeMarchant",function(){
        var id_str = $(this).prop("id");
        id_arr = id_str.split('-');
        id= id_arr[1];
        var token = $("meta[name='csrf-token']").attr("content");
        $.ajax({
              type:'delete',
              url: '/admin/add_storecat_to_merchant/remove_selected_merchant',
              headers: { 'X-CSRF-Token': token },
              data: {id:id},
              success:function(data){
                $('#'+id_str).parent('div').remove();
                $(".message").html("<b>"+data+"</b>").css("margin-left","20%").show().fadeOut(5000);
              }
        });
     });
    
     $(document).on("click","#AddMerchant",function(){
        var cat_id = $("#category").val();
        var merchant_str = $("#merchant").val();
        var merchant_arr = merchant_str.split("-");
        var merchant_type = merchant_arr[0];
        var merchant_id = merchant_arr[1];
        var token = $("meta[name='csrf-token']").attr("content");
         $.ajax({
              type:'post',
              url: '/admin/add_storecat_to_merchant/add_merchant',
              headers: { 'X-CSRF-Token': token },
              data: {cat_id:cat_id,merchant_id:merchant_id,merchant_type:merchant_type},
              success:function(data){
                $(".message").html("<b>"+data+"</b>").css("margin-left","20%").show().fadeOut(5000);
                if (data=="Merchent Added successfully") {
                  $("#category").trigger("change");
                }
                
                 
              }
        });
     });
      $("#category").trigger("change");
});