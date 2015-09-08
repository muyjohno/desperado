module LeagueHelper
  def tab_class(active, current)
    :active if current == active
  end

  def theme_options
    League.themes.keys.map { |theme| [t("theme_#{theme}"), theme] }
  end
end
