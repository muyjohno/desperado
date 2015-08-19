module MarkdownContent
  extend ActiveSupport::Concern

  def markdown(raw)
    markdown_renderer.render(raw.to_s)
  end

  def markdown_renderer(strategy = Redcarpet::Render::HTML)
    Redcarpet::Markdown.new(strategy)
  end
end
