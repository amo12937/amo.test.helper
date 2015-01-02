(function() {
  "use strict";
  (function(that, name) {
    var amo;
    amo = that[name] != null ? that[name] : that[name] = {};
    if (amo.test == null) {
      amo.test = {};
    }
    return amo.test.helper = {
      jasmine: {
        spyOnDecorator: function(_spyOn) {
          return function($delegate) {
            var holder;
            holder = {
              $delegate: $delegate
            };
            _spyOn(holder, "$delegate").and.callThrough();
            return holder.$delegate;
          };
        }
      },
      runWithDataProvider: function(dataProvider, runBlock, thisArg) {
        var data, _i, _len, _ref, _results;
        _ref = dataProvider();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          data = _ref[_i];
          _results.push(runBlock.apply(thisArg, data));
        }
        return _results;
      }
    };
  })(this, ".amo");

}).call(this);
