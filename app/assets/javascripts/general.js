$(function(){
	$('.comingSoon').click(function() {
			$(this).popModal({
				html: function(callback) { 
					$.ajax({url : '/templates/coming-soon.html'}).done(function(content){ 
						callback(content); 
					}); 
				}
			});
	});

	$('.joinModal').click(function() {
		merchant_id = $(this).data("merchant_id");
		if($(this).data("loyalty_enabled")) {
			$(this).closest(".handshake").find('.joinModal_x'+merchant_id).popModal({
				html: function(callback) { 
					$.ajax({url : '/templates/join-modal.html'}).done(function(content){ 
						callback(content); 
					}); 
				}
			});
			$(".member-form").hide();	
		} else {
			$(this).closest(".handshake").find('.joinModal_x'+merchant_id).popModal({
				html: function(callback) { 
					$.ajax({url : '/templates/loyalty-coming-soon.html'}).done(function(content){ 
						callback(content); 
					}); 
				}
			});
		}
	});

	$('.share-btn').click(function(){
		$(this).next('.share-form').show();
	});  

	$('.fa-close').click(function(){
		$('.share-form').hide();
	});

	$(document).on("click", ".click", function(){
		$(".member-form").slideToggle("slow");
	});

	$(document).on("click", ".join-loyalty", function() {
		$(".signup-loader").removeClass("hide");
		$.post("/api/v1/loyalty_programs_users.json", {loyalty_programs_user: {loyalty_program_id: merchant_id, is_signup: true}}, function(data) {
			$(".member-form-loader").addClass("hide");
			var handShakeJoin = $('.joinModal_x'+merchant_id);
			if(data.success) {
				handShakeJoin.popModal("hide")
				handShakeJoin.addClass("hide")
				handShakeJoin.closest(".handshake").find(".joined").removeClass("hide");
				noty({text: "Loyalty Program joined, we will update your dashboard within 24 hours.", type: "success"});
			} else {
				handShakeJoin.popModal("hide")
				noty({text: data.message, type: "error"});
			}
		})
		return(false);
	});

	$(document).on("submit", ".member-form", function() {
		var data = $(this).serializeArray();
		$(".member-form-loader").removeClass("hide");
		$.post("/api/v1/loyalty_programs_users.json", {loyalty_programs_user: {account_id: data[0].value, password: data[1].value, loyalty_program_id: merchant_id}}, function(data) {
			$(".member-form-loader").addClass("hide");
			var handShakeJoin = $('.joinModal_x'+merchant_id);
			if(data.success) {
				handShakeJoin.popModal("hide")
				handShakeJoin.addClass("hide")
				handShakeJoin.closest(".handshake").find(".joined").removeClass("hide");
				noty({text: "Loyalty Program joined, we will update your dashboard within 24 hours.", type: "success"});
			} else {
				noty({text: data.message, type: "error"});
			}
		});
		return(false);
	});
	

	$(document).on("click", ".retry", function() {
		var merchant_id = $(this).data("merchant_id");
		var program_id = $(this).data("program_id");
		var account_id = $(this).data("account_id");
		var password = $(this).data("programs_password");
		 $.ajax({
        url: '/api/v1/loyalty_programs_users/'+ program_id+'.json',
        method: 'put',
        data: {loyalty_programs_user: {account_id: account_id, password: password, loyalty_program_id: merchant_id, is_signup: null}},
        success: function(data, status) {
          if(data.success){
            noty({text: " we will update your dashboard within 24 hours.", type: "success"});
          } else {
            noty({text: "Something went wrong", type: "error"});
          }
        }
      });
	});
});
