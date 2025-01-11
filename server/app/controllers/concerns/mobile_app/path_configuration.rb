module MobileApp::PathConfiguration
  extend ActiveSupport::Concern

  # Rules which apply to both iOS and Android
  def common_rules
    [
      # Server-Driven Routing
      # https://native.hotwired.dev/reference/navigation#server-driven-routing-in-rails
      {
        patterns: ["/recede_historical_location"],
        properties: {presentation: "pop"}
      },
      {
        patterns: ["/refresh_historical_location"],
        properties: {presentation: "refresh"}
      },
      {
        patterns: ["/resume_historical_location"],
        properties: {presentation: "none"}
      }
    ]
  end
end
