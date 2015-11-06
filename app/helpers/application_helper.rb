module ApplicationHelper
  include MarkdownContent

  def theme
    League.current.theme || "default"
  end
end
