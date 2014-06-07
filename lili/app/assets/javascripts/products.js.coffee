# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $ '.product-select'
    .select2 { placeholder: "Seleccione un producto", allowClear: true }

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

    $ 'body'
    .on 'click', '.remove-item', (e) ->
        e.preventDefault()

        only_one = $ "#items tbody tr"
            .length == 1

        if only_one
            $ this
            .parents "tr"
            .find "input"
            .val ""
        else
            $ this
                .parents "tr"
                .remove()

$(document).ready(ready)
$(document).on('page:load', ready);
