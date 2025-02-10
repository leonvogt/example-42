class MobileApp::NavigationController < ApplicationController
  def pop_until
    render html: "Pop Until"
  end
end
