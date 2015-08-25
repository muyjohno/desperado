module LeagueHelper
  def tab_class(active, current)
    :active if current == active
  end
end
