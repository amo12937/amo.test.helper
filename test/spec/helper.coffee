"use strict"

do (that = @, name = ".amo") ->
  describe "#{name}.test.helper.jasmine の仕様", ->
    helper = that[name].test.helper
    describe "#{name}.test.helper.jasmine.spyOnDecorator は", ->
      decorator = null
      beforeEach ->
        decorator = helper.jasmine.spyOnDecorator spyOn

      it "jasmine の spyOn を受け取り、何にも属さない関数を spy するためのデコレータを提供する", ->
        expect(decorator).toEqual jasmine.any Function

        toDouble = (a) -> 2 * a
        decorated = decorator toDouble
        expect(decorated).not.toHaveBeenCalled()
        expect(decorated 3).toBe 6
        expect(decorated).toHaveBeenCalledWith 3

        decorated.and.returnValue 5
        expect(decorated 3).toBe 5

      it "関数がプロパティを持っていた場合は、これを保持する", ->
        square = (a) -> a * a
        square.thenAddThree = (a) -> @(a) + 3

        decorated = decorator square
        expect(decorated.thenAddThree).toEqual jasmine.any Function
        expect(decorated).not.toHaveBeenCalled()
        expect(decorated -2).toBe 4
        expect(decorated).toHaveBeenCalledWith -2

        expect(decorated.thenAddThree -2).toBe 7
        decorated.and.returnValue 5
        expect(decorated.thenAddThree -2).toBe 8

  describe "#{name}.test.helper.runWithDataProvider の仕様", ->
    runWithDataProvider = that[name].test.helper.runWithDataProvider
    it "dataProvider が返す data のリストの一つ一つに対し、runBlock 関数を適用する", ->
      dataProvider = -> [
        [1, 2, 3]
        [4, 5, 9]
        ["fizz", "buzz", "fizzbuzz"]
      ]
      runBlock = jasmine.createSpy("runBlock").and.callFake (a, b, c) ->
        expect(a + b).toBe c

      runWithDataProvider dataProvider, runBlock
      expect(runBlock.calls.count()).toBe 3

    it "thisArg が渡された場合 runBlock 内の this として渡される", ->
      dataProvider = -> [
        ["a", 1]
        ["b", 2]
        ["c", undefined]
      ]
      runBlock = (prop, expected) ->
        expect(@[prop]).toBe expected
      thisArg =
        a: 1
        b: 2

      runWithDataProvider dataProvider, runBlock, thisArg

