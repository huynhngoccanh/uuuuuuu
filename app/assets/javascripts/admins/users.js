$(function(){
    $('input[name="to_release[]"]').on('click', function(){
        var total = 0;
        $('input[name="to_release[]"]').each(function() {
            if(this.checked) {
                total += Number(this.value) * 100;
            }
        });
        $('#for_release').text('$' + (total / 100).toFixed(2));
    });
});