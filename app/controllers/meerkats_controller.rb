class MeerkatsController < ApplicationController

  def index
    MeerkatPopulator.fetch_and_persist!
    @meerkats = Meerkat.order("created_at DESC").first(8)
  end
end
