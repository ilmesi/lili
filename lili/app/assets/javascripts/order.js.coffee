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

    add_new_row = ($element) ->
        $element
            .parents "tr"
            .after "<tr data-valid='false'>" + default_child + "</tr>"

        $element
            .parents "tr"
            .next 'tr'
            .find '.product-select'
            .select2 { placeholder: "Seleccione un producto" }

    $ 'body'
    .on 'click', '.add-item', (e) ->
        e.preventDefault()
        add_new_row $ this
        return true

    $ 'body'
    .on 'click', '.remove-item', (e) ->
        e.preventDefault()

        only_one = $ "#items tbody tr"
            .length == 1

        if only_one
            add_new_row $ this
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
                $ this
                    .attr "data-valid", true
        else
            if !$current.hasClass("status-bad")
                $ this
                    .find '.status'
                    .hide()
                $ this
                    .find '.status-bad'
                    .show()
                    .toggleClass('hide')
                $ this
                    .attr "data-valid", false

    load_items = ->
        $ '#order-modal'
            .modal 'toggle'

        ready =
            $ '#items tbody tr[data-valid="true"]'
            .length > 0

        console.log ready

        if !ready
            $ '#final-order tbody #empty-row'
                .show()
            $("#save-order").attr('disabled', 'disabled');
            $("#create-order").attr('disabled', 'disabled');
            return

        $ '#final-order tbody #progress-row'
            .show()
        $ '#final-order tbody #empty-row'
            .hide()
        $("#save-order").removeAttr('disabled');
        $("#create-order").removeAttr('disabled');

        items_list = []
        items_rows = ''
        $ '#items tbody tr'
            .each ->
                item = {}
                item['product'] =
                    $ this
                        .find "[name='product']"
                        .find "option:selected"
                        .text()
                item['size'] =
                    $ this
                        .find "[name='size']"
                        .val()
                item['amount'] =
                    $ this
                        .find "[name='amount']"
                        .val()
                item['cost'] =
                    $ this
                        .find "[name='cost']"
                        .val()
                items_list .push item
                row_item = (item) ->
                    "<tr><td>#{item['product']}</td><td>#{item['size']}</td><td>#{item['amount']}</td><td>#{item['cost']}</td></tr>"

                items_rows += row_item(item)

        $bar = $ '#order-progress'
        setTimeout ->
            $bar .width "30%"
        , 1000
        setTimeout ->
            $bar .width "60%"
        , 1000
        setTimeout ->
            $bar .width "100%"
        , 1000
        setTimeout ->
            $bar
                .width "0"
                .parent()
                .hide()
            $ '#final-order tbody tr.disposable-row'
                .hide()
            $ '#final-order tbody'
                .append items_rows
        , 2000

    $ 'form#new_order'
    .on 'hidden.bs.modal', (e) ->
        alert "bye"

    $ 'form#new_order'
    .submit (e) ->
        self = this
        e.preventDefault()
        load_items()
        return false;

$(document).ready(ready)
$(document).on('page:load', ready);
