sq = angular.module('sq')

sq.config([
  '$routeProvider'
  '$tooltipProvider'
  '$modalProvider'
  '$popoverProvider'
  '$dropdownProvider'
  'SpotifyProvider'
  ($routeProvider, $tooltipProvider, $modalProvider, $popoverProvider, $dropdownProvider, SpotifyProvider) ->
    $routeProvider.when('/',
      templateUrl: 'home.html'
      controller: 'HomeCtrl'
    ).when('/:quizName',
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

    SpotifyProvider.setClientId('d9f8807019e343318c130038ad5206cd')
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
