class MeerkatsController < ApplicationController

  def index
    @meerkats = Meerkat.all.sort_by(:created_at, limit: [0,8], order: 'DESC')
  end
end
