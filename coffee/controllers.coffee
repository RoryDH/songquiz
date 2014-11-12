sq = angular.module('sq')

sq.controller("MainCtrl", [
  '$scope'
  '$http'
  ($scope, $http) ->

])

sq.controller("GameCtrl", [
  '$scope'
  ($scope) ->
    $scope.message = '1'
])
