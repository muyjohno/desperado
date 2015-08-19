class RulesController < ApplicationController
  include MarkdownContent

  def show
    @content = markdown(league.rules_content)
  end
end
