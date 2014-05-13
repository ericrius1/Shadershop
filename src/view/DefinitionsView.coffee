R.create "DefinitionsView",
  propTypes:
    appRoot: C.AppRoot

  render: ->
    R.div {className: "Definitions"},

      builtIn.fns.map (fn) =>
        R.DefinitionView {fn, key: C.id(fn)}

      R.div {className: "Divider"}

      @appRoot.fns.map (fn) =>
        R.DefinitionView {fn, key: C.id(fn)}

      R.div {className: "AddDefinition"},
        R.button {className: "AddButton", onClick: @_onAddButtonClick}

  _onAddButtonClick: ->
    Actions.addDefinedFn()


defaultBounds = {
  xMin: -6
  xMax: 6
  yMin: -6
  yMax: 6
}

R.create "DefinitionView",
  propTypes:
    fn: C.Fn

  render: ->
    exprString = Compiler.getExprString(@fn, "x")
    fnString = "(function (x) { return #{exprString}; })"

    if @fn instanceof C.BuiltInFn
      bounds = defaultBounds
    else
      bounds = @fn.bounds

    className = R.cx {
      Definition: true
      Selected: UI.selectedFn == @fn
    }

    R.div {
      className: className
    },
      R.span {onMouseDown: @_onMouseDown},
        R.ThumbnailPlotView {bounds, fn: @fn}

      if @fn instanceof C.BuiltInFn
        R.div {className: "Label"}, @fn.label
      else
        R.TextFieldView {
          className: "Label"
          value: @fn.label
          onInput: @_onLabelInput
        }

  _onMouseDown: (e) ->
    util.preventDefault(e)

    addChildFn = =>
      Actions.addChildFn(@fn)

    selectFn = =>
      Actions.selectFn(@fn)

    util.onceDragConsummated(e, addChildFn, selectFn)

  _onLabelInput: (newValue) ->
    Actions.setFnLabel(@fn, newValue)

