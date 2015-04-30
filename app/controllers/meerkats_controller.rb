class MeerkatsController < ApplicationController

  def index
    MeerkatPopulator.run!
    @meerkats = Meerkat.order("created_at DESC").first(8)
  end
end
