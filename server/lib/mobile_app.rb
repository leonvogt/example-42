class MobileApp
  attr_reader :request

  def initialize(request)
    @request = request
    @user_agent = request.user_agent.to_s
  end

  def mobile_app?
    @_mobile_app ||= @user_agent.match?(/(Turbo|Hotwire) Native/)
  end

  def app_version
    @_app_version ||= scan_user_agent(/app_version: ([\d\.]+)/)
  end

  def supported_bridge_components
    @_supported_bridge_components ||= scan_user_agent(/bridge-components: \[([\w\s-]+)\]/)
  end

  def platform
    return :android if is_android?
    return :ios if is_ios?
    :unknown
  end

  def is_android?
    @_is_android ||= @user_agent.match?(/Android/)
  end

  def is_ios?
    @_is_ios ||= @user_agent.match?(/iOS/)
  end

  def scan_user_agent(regex)
    @user_agent.match(regex).try(:[], 1)
  end
end
