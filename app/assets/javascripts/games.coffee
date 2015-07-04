$ ->
  $("form.game_form").bind "update_player_names", ->
    $(".game_runner_name", @).text($("#game_runner_id option:selected", @).text())
    $(".game_corp_name", @).text($("#game_corp_id option:selected", @).text())

  $("form.game_form").trigger "update_player_names"

  $("form.game_form select").on "change", ->
    $("form.game_form").trigger "update_player_names"
