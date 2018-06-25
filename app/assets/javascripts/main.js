// jQuery(document).ready(function(){
//     $(".owl-carousel").owlCarousel({
//
// //        autoPlay: 3000, //Set AutoPlay to 3 seconds
//
//         items : 4,
//         itemsDesktop : [1199,3],
//         itemsDesktopSmall : [992,2],
//         itemsTablet : [768,2],
//         itemsMobile :	[667,1]
//
//     });
//     var headertext = [],
//         headers = document.querySelectorAll("#miyazaki th"),
//         tablerows = document.querySelectorAll("#miyazaki th"),
//         tablebody = document.querySelector("#miyazaki tbody");
//
//     for(var i = 0; i < headers.length; i++) {
//         var current = headers[i];
//         headertext.push(current.textContent.replace(/\r?\n|\r/,""));
//     }
//     for (var i = 0, row; row = tablebody.rows[i]; i++) {
//         for (var j = 0, col; col = row.cells[j]; j++) {
//             col.setAttribute("data-th", headertext[j]);
//         }
//     }
//
// });
