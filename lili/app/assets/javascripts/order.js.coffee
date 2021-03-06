# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    default_child = $ "#items tbody tr"
        .first()
        .clone()
        .html()

    $ 'input.integer'
    .bind 'keypress', (event) ->
        regex = new RegExp /^[0-9]+$/
        key = String.fromCharCode if !event.charCode then event.which else event.charCode
        if !regex.test(key)
           event.preventDefault()
           return false

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
    .on 'change', 'input.row-field', (e) ->
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
        .find(".status:visible")

        if all_fields == valid_fields
            if !$current.hasClass("status-ok")
                $ this
                    .find '.status'
                    .hide()
                $ this
                    .find '.status-ok'
                    .show()
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
                $ this
                    .attr "data-valid", false

    clear_order_items = ->
        $ '#final-order tbody tr'
            .not '.disposable-row'
            .remove()

    add_order_items = (items_rows) ->
        $ '#final-order tbody'
            .append items_rows

    get_items = ->
        items_rows = ''

        $ '#items tbody tr[data-valid="true"]'
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

            row_item = (item) ->
                "<tr><td>#{item['product']}</td><td>#{item['size']}</td><td>#{item['amount']}</td><td>#{item['cost']}</td></tr>"

            items_rows += row_item(item)

        return items_rows

    load_items = ->
        $ '#order-modal'
            .modal 'toggle'

        ready =
            $ '#items tbody tr[data-valid="true"]'
            .length > 0

        if !ready
            $ '#final-order tbody #empty-row'
                .show()
            $("#save-order").attr('disabled', 'disabled');
            $("#create-order").attr('disabled', 'disabled');
            return

        items = get_items()

        add_order_items items

    $ '#order-modal'
    .on 'hidden.bs.modal', (e) ->
        clear_order_items()
        $ '#final-order tbody #empty-row'
            .hide()
        $ "#save-order"
            .removeAttr 'disabled'
        $ "#create-order"
            .removeAttr 'disabled'

    $ 'button#show-order'
    .click (e) ->
        e.preventDefault()
        load_items()
        return false;

$(document).ready(ready)
$(document).on('page:load', ready);
