  $(document).ready(function(){
    if ($('.browse-the-store').length > 0) {
      var total_images = $(".outer-inner").data("total-count");
      var slide = 1;
      console.log(total_images);
      if(total_images > 3){
          $.each($(".inner"),function(index,value){
              if($(value).data("number") > 2){
                  console.log(value)
                  $(value).hide();
              }
          });
      }

      $("#left-button").click(function(){
          var visible_images = $(".inner:visible").length;
          var first_visible_image = $(".inner:visible").first().data("number");
          if(slide > 1){
              var first_image_range = (first_visible_image  - 3)
              var last_image_range = first_image_range + 3
              $(".inner").hide();
              $.each($(".inner"), function(index, value){
                  if($(value).data("number") >= first_image_range && $(value).data("number") < last_image_range){
                      $(value).show();
                  }
              });
              slide = slide - 1;
          }
      });

      $("#right-button").click(function(){
          var visible_images = $(".inner:visible").length;
          var last_visible_image = $(".inner:visible").last().data("number");
          if(last_visible_image < (total_images -1)){
              var difference = total_images - (last_visible_image + 1)
              if(difference < 4){
                  next_images_range = last_visible_image + difference
              }
              else{
                  next_images_range = last_visible_image + 3
              }
              $(".inner").hide();
              $.each($(".inner"), function(index, value){
                  if($(value).data("number") > last_visible_image && $(value).data("number") <= next_images_range){

                      $(value).show();
                  }
              })
              slide = slide + 1;
          }
      });

      //Sort random function
      function random(owlSelector){
        owlSelector.children().sort(function(){
            return Math.round(Math.random()) - 0.5;
        }).each(function(){
          $(this).appendTo(owlSelector);
        });
      }

      $("#owl-demo").owlCarousel({
        autoPlay: 3000,
        items: 4
      });
    }
  });