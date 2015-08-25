class LeagueController < ApplicationController
  before_action :authorise

  def edit
  end

  def update
    if @league.update_attributes(league_params)
      redirect_to edit_league_path, notice: t(:updated_league)
    else
      flash.now.alert = t(:update_league_failed)
      render :edit
    end
  end

  def rules
    @rules = @league.all_rules
  end

  def update_rules
    rules_params.each do |key, value|
      Rule.rule_for(key).update(value: value)
    end
    redirect_to edit_rules_path, notice: t(:updated_rules)
  end

  def tiebreakers
    @tiebreakers = Tiebreaker.ordered
  end

  def update_tiebreaker
    @tiebreaker = Tiebreaker.find(tiebreaker_params[:tiebreaker_id])
    @tiebreaker.ordinal_position = tiebreaker_params[:ordinal_position]
    @tiebreaker.save

    render nothing: true
  end

  private

  def league_params
    params.require(:league).permit(:name, :rules_content, :home_content)
  end

  def rules_params
    params[:rules] || {}
  end

  def tiebreaker_params
    params.require(:tiebreaker).permit(:tiebreaker_id, :ordinal_position)
  end
end
