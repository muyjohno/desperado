$ ->
  $("form#new_game").bind "update_reverse_players", ->
    $("#reverse_corp", @).text($("#game_runner_id option:selected", @).text())
    $("#reverse_runner", @).text($("#game_corp_id option:selected", @).text())

  $("form#new_game").trigger "update_reverse_players"

  $("form#new_game select").on "change", ->
    $("form#new_game").trigger "update_reverse_players"
