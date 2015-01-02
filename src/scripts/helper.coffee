"use strict"

do (that = @, name = ".amo") ->
  amo = that[name] ?= {}
  amo.test ?= {}
  amo.test.helper =
    jasmine:
      spyOnDecorator: (_spyOn) -> ($delegate) ->
        holder = { $delegate }
        _spyOn(holder, "$delegate").and.callThrough()
        return holder.$delegate

    runWithDataProvider: (dataProvider, runBlock, thisArg) ->
      for data in dataProvider()
        runBlock.apply thisArg, data

