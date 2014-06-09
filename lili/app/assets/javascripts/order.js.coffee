# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    default_child = $ "#items tbody tr"
        .first()
        .clone()
        .html()

    $ '.product-select'
    .select2 { placeholder: "Seleccione un producto" }

    $ 'body'
    .on 'click', '.add-item', (e) ->
        e.preventDefault()

        tr_length = $ "#items tbody tr"
            .length + 1

        $ this
            .parents "tr"
            .after "<tr data-steps='0' data-element='" + tr_length + "'>" + default_child + "</tr>"

        $ "tr[data-element='" + tr_length + "']"
            .find '.product-select'
            .select2 { placeholder: "Seleccione un producto" }

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

    validate_field = (e, element, value) ->
        e.preventDefault()

        valid_data = value != ""
        element .attr "data-valid", valid_data

        $ element
            .parents 'tr'
            .trigger('data-valid-changed')

        return valid_data;

    $ 'body'
    .on 'blur', 'input.row-field', (e) ->
        return validate_field(
            e, $(this) , $(this).val()
        )

    $ 'body'
    .on 'change', 'select.row-field', (e) ->
        return validate_field(
            e, $(this) , $(this).val()
        )

    $ 'body'
    .on 'data-valid-changed', '#items tbody tr', (event) ->
        event.preventDefault()

        all_fields = $ this
            .find 'input.row-field, select.row-field'
            .length
        valid_fields = $ this
            .find 'input.row-field[data-valid="true"], select.row-field[data-valid="true"]'
            .length

        $current = $ this
        .find(".status:not('.hide')")

        if all_fields == valid_fields
            if !$current.hasClass("status-ok")
                $ this
                    .find '.status'
                    .hide()
                $ this
                    .find '.status-ok'
                    .show()
                    .toggleClass('hide')
        else
            if !$current.hasClass("status-bad")
                $ this
                    .find '.status'
                    .hide()
                $ this
                    .find '.status-bad'
                    .show()
                    .toggleClass('hide')

$(document).ready(ready)
$(document).on('page:load', ready);
