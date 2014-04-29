class Dashing.Pingdomstatus extends Dashing.Widget

  @accessor 'arrow', ->
    if (@get('current') == "up" ) then 'value-up icon-caret-up' else 'icon-caret-down'

  @accessor 'value', ->
    if (@get('current') == "up" ) then 'value value-up' else 'value value-down'
