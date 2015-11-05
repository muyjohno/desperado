include MarkdownContent

module ApplicationHelper
  def theme
    League.current.theme || "default"
  end

  def markdown(text)
    MarkdownContent.markdown(text.to_s).html_safe
  end
end
