@CashbackModal = new (->
  @ShowCashbackModal = (placement) ->
    $("#placement_header").text(placement.header.toUpperCase())
    $("#placement_description").text(placement.description.toUpperCase())
    
    $("#placement_action").attr(
    	"href", 
    	"/validate_session?return_to=" + placement.merchants_redirect_path
    )

    if placement.code == null || placement.code.toLowerCase() == "no code needed"
    	$("#placement_code").text("No Code Needed")
    else
    	$("#placement_code").text(placement.code)

    $("#cashbackModal").modal("show");

  return @
) 
