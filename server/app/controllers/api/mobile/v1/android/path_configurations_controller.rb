module Api::Mobile::V1::Android
  class PathConfigurationsController < Api::BaseController
    include MobileApp::PathConfiguration

    # https://native.hotwired.dev/reference/navigation
    # https://native.hotwired.dev/reference/path-configuration
    # The patterns are regular expressions that are matched against the URL.
    # `^/`                  => Begins with `/`
    # $                     => Ends with
    # .*\\?.*foo=bar.*      => Contains `foo=bar`
    # comments/\\d+/edit    => `comments/some_digit/edit`
    # "^/events/\\d+"       => `events/some_digit`

    def show
      render json: {
        settings: {},
        rules: [
          { # Default rules for all pages (Can be overridden)
            patterns: [".*"],
            properties: {
              context: "default",
              uri: "hotwire://fragment/web",
              fallback_uri: "hotwire://fragment/web",
              pull_to_refresh_enabled: true,
              show_menu_button: false
            }
          },
          { # Rules for the start page
            patterns: [
              "^$",
              "^/$",
              "^/home$"
            ],
            properties: {
              uri: "hotwire://fragment/web/home",
              presentation: "replace_root",
              show_menu_button: true
            }
          },
          { # Rules for pages that should be displayed in the modal (full)
            patterns: [],
            properties: {
              context: "modal",
              uri: "hotwire://fragment/web/modal"
            }
          },
          { # Rules for pages that should be displayed in the modal (medium)
            patterns: [
            ],
            properties: {
              context: "modal",
              uri: "hotwire://fragment/web/modal/sheet"
            }
          },
          *common_rules
        ]
      }
    end
  end
end
