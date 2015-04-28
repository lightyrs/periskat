class PeriscopesController < ApplicationController

  def index
    @periscopes = Periscope.order("created_at DESC").first(8)
  end
end
