# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $ 'body'
    .on 'click', '.add-item', (e) ->
        e.preventDefault()

        new_child =
            $ "#items tbody tr"
            .first()
            .clone()
            .html()

        $ this
            .parents "tr"
            .after "<tr>" + new_child + "</tr>"

$(document).ready(ready)
