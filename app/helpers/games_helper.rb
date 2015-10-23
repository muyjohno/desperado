module GamesHelper
  def result_options
    Game.results.keys.map { |result| [t(result).titleize, result] }
  end

  def corp_achievements
    Achievement.corp
  end

  def runner_achievements
    Achievement.runner
  end

  def result_class(game, player)
    game.player_result(player)
  end

  def played_side_against_opponent(game, player)
    return t(:bye_game_title,
      bye_player: link_player(player)
    ).html_safe if game.bye?

    t(:played_side_against_opponent,
      side: game.side(player).to_s.titleize,
      opponent: link_player(game.opponent(player))
    ).html_safe
  end

  def neutral_game_title(game)
    return t(:bye_game_title,
      bye_player: link_player(game.bye_player)
    ).html_safe if game.bye?

    t(:neutral_game_title,
      corp_player: link_player(game.corp),
      runner_player: link_player(game.runner),
      result: neutral_result(game)
    ).html_safe
  end

  def neutral_result(game)
    return t(:tie) if game.tie?

    name = game.winner.name
    result = t(:win) if game.corp_win? || game.runner_win?
    result = t(:time_win) if game.corp_time_win? || game.runner_time_win?
    "#{h(name)} #{result}"
  end

  def link_player(player)
    link_to(h(player.name), player_path(player)).html_safe
  end

  def player_select(field_name, default = nil)
    select_tag field_name,
      options_from_collection_for_select(Player.all, "id", "name", default),
      include_blank: true,
      class: "form-control"
  end
end
