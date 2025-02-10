class ApplicationController < ActionController::Base
  include DetectDevice, MobileApp::Navigation
end
