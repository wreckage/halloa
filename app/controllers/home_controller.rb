class HomeController < ApplicationController
  def index
    render component: "Home"
  end
end
