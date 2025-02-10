module Api::Mobile::V1::Ios
  class PathConfigurationsController < Api::BaseController
    include MobileApp::PathConfiguration

    # https://native.hotwired.dev/reference/navigation
    # https://native.hotwired.dev/reference/path-configuration
    # The patterns are regular expressions that are matched against the URL.
    # `^/`                  => Begins with `/`
    # $                     => Ends with
    # .*\\?.*foo=bar.*      => Contains `foo=bar`
    # comments/\\d+/edit    => `comments/some_digit/edit`
    # "^/events/\\d+"       => `/events/some_digit`

    def show
      render json: {
        settings: {},
        rules: [
          { # Default rules for all pages (Can be overridden)
            patterns: [".*"],
            properties: {}
          },
          { # Rules for the start page
            patterns: [
              "^$",
              "^/$",
              "^/home$"
            ],
            properties: {
              presentation: "replace_root",
              animated: false
            }
          },
          { # Rules for pages that should be displayed in the modal (full)
            patterns: [],
            properties: {
              context: "modal",
              modal_style: "full"
            }
          },
          { # Rules for pages that should be displayed in the modal (large)
            patterns: [],
            properties: {
              context: "modal",
              modal_style: "large"
            }
          },
          { # Rules for pages that should be displayed in the modal (medium)
            patterns: [],
            properties: {
              context: "modal",
              modal_style: "medium"
            }
          },
          {
            patterns: [
              "^/pop_until"
            ],
            properties: {
              custom_presentation: "pop_until",
            }
          },
          *common_rules
        ]
      }
    end
  end
end
