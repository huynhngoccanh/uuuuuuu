$(function () {
    $('#describe-continue').click(function () {
        var slider_elem_width = "-624px";
        $('#company-registration #step2_init').animate({marginLeft:slider_elem_width}, 300, 'swing');
        $('#company-registration #step2_optional').slideDown("slow");
    });
});