class MeerkatsController < ApplicationController

  before_action :run_populator, only: [:index]

  def index
    @meerkats = Meerkat.order("created_at DESC").first(8)
  end

  private

  def run_populator
    MeerkatPopulator.run
  end
end
