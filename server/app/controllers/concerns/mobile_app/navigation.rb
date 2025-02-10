module MobileApp::Navigation
  extend ActiveSupport::Concern

  # Pop until the given URL is reached on the navigation stack.
  def pop_until_or_redirect_to(url, **options)
    if mobile_app?
      redirect_to pop_until_path(url: url, **options)
    else
      redirect_to url, options
    end
  end
end
