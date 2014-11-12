sq = angular.module('sq')

sq.config([
  '$routeProvider'
  '$tooltipProvider'
  '$modalProvider'
  '$popoverProvider'
  '$dropdownProvider'
  ($routeProvider, $tooltipProvider, $modalProvider, $popoverProvider, $dropdownProvider) ->
    $routeProvider.when('/',
      templateUrl: 'game.html'
      controller: 'GameCtrl'
    )

    angular.extend $tooltipProvider.defaults,
      # animation: null
      trigger: 'hover'
      placement: 'bottom'
      container: 'body'

    angular.extend $modalProvider.defaults,
      container: 'body'
      # animation: null
      backdropAnimation: null

    angular.extend $popoverProvider.defaults,
      container: 'body'
      animation: null

    angular.extend $dropdownProvider.defaults,
      animation: null
])

sq.run([
  '$rootScope'
  '$location'
  ($rootScope, $location) ->
    $rootScope.location = $location
])

sq.filter('cap', ->
  (input, scope) ->
    if input != null
      input = input.toLowerCase()
      input.substring(0,1).toUpperCase() + input.substring(1)
)

sq.filter('unsafe', ['$sce', ($sce) ->
  (val) -> $sce.trustAsHtml(val)
])
