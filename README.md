# amo.test.helper

テストで使えるヘルパーを提供する

# インストール方法
```
bower install -D amo.test.helper
```

```coffee:karma.conf.coffee
module.exports = (config) ->
  config.set
    # ...
    files: [
      # ...
      "bower_components/amo.test.helper/dist/js/helper.js"
      # ...
    ]
    # ...
```

# 使い方
## @[".amo"].test.helper.jasmine
### @[".amo"].test.helper.jasmine.spyOnDecorator
spyOn は基本的にオブジェクトのメンバ関数を spy するが、何にも属さない関数を spy することはできない。
（jasmine.createSpy があるが、これは新しく spied オブジェクトを作るものであり、既存の関数を spy することはできない）

spyOnDecorator は、何にも属さない関数を渡し、それを spy した関数を返す。

```coffee: test.coffee
do (that = @, name = ".amo") ->
  describe "何にも属さない関数に関するテスト", ->
    decorator = that[name].test.helper.jasmine.spyOnDecorator spyOn

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
```

## @[".amo"].test.helper.runWithDataProvider
ほとんど同じテストで、渡すデータだけが違うようなテストを簡潔に記述する。

```coffee: test.coffee
do (that = @, name = ".amo") ->
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
```
