module ApplicationHelper
  def theme
    League.current.theme || "default"
  end
end
