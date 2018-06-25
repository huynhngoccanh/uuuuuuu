class LoggedInUserConstraint
  def matches?(request)
    request.env["warden"].authenticated?(:user)
  end
end

class LoggedInVendorConstraint
  def matches?(request)
    request.env["warden"].authenticated?(:vendor)
  end
end

class LoggedInAdminConstraint
  def matches?(request)
    request.env["warden"].authenticated?(:admin)
  end
end