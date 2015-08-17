class RulesController < ApplicationController
  def show
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @content = renderer.render(league.rules_content)
  end
end
