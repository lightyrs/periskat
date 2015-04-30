class PeriscopesController < ApplicationController

  def index
    @periscopes = Periscope.all.sort_by(:created_at, limit: [0,8], order: 'DESC')
  end
end
