$ ->
  $("#sortable-tiebreakers").sortable(
    axis: "y"
    items: ".item"
    cursor: "move"
    stop: (e, ui) ->
      ui.item.children("td").effect("highlight", {}, 1000)
    update: (e, ui) ->
      $.ajax(
        type: "PATCH"
        url: "/tiebreakers/#{ui.item.data("item-id")}"
        dataType: "json"
        data: { tiebreaker: { ordinal_position: ui.item.index() } }
      )
  )
