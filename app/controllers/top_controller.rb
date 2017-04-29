# Top Controller for static pages
class TopController < ApplicationController
  def index
    render layout: 'top'
  end
end
