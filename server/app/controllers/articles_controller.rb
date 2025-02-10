class ArticlesController < ApplicationController
  def test_4
    case params[:pop_until]
    when "test_1"
      pop_until_or_redirect_to(test_1_path)
    when "test_2"
      pop_until_or_redirect_to(test_2_path)
    when "camera_access"
      pop_until_or_redirect_to(camera_access_path)
    end
  end
end
