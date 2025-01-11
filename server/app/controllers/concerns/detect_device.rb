module DetectDevice
  extend ActiveSupport::Concern

  included do
    before_action :set_variant

    def set_variant
      request.variant = :mobile_app if mobile_app?
    end

    def current_mobile_app
      @_current_mobile_app ||= MobileApp.new(request)
    end
    helper_method :current_mobile_app

    def mobile_app?
      current_mobile_app.mobile_app?
    end
    helper_method :mobile_app?
  end
end
