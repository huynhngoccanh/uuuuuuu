@CouponModal = new (->
  @ShowCouponModal = (placement) ->
    $("#placement_description").text(placement.description)
    $("#placement_action").text("Go to " + placement.merchant_name)
    $("#placement_action").attr("href", placement.merchants_redirect_path)

    if placement.code == null || placement.code.toLowerCase() == "no code needed"
      $("#placement_code").text("No Code Needed")
    else
      $("#placement_code").text(placement.code)

    if placement.expiry == null
      $(".offer-info-2-b span").text("Never Expires")
    else
      $(".offer-info-2-b span").text(placement.expiry)

    $("#couponModal").modal("show")

  return @
)