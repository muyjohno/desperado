class LeagueController < ApplicationController
  before_action :authorise

  def edit
    @rules = @league.all_rules
  end

  def update
    if @league.update_attributes(league_params)
      rules_params.each do |key, value|
        Rule.rule_for(key).update(value: value)
      end
      redirect_to edit_league_path, notice: t(:updated_league)
    else
      flash.now.alert = t(:update_league_failed)
      @rules = @league.all_rules
      render :edit
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :rules_content, :home_content)
  end

  def rules_params
    params[:rules] || {}
  end
end
