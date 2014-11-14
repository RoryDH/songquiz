sq = angular.module('sq')

sq.controller("MainCtrl", [
  '$scope'
  '$http'
  ($scope, $http) ->

])

sq.controller("GameCtrl", [
  '$scope'
  '$http'
  '$timeout'
  '$interval'
  'Random'
  'Song'
  'Question'
  'songsJSON'
  ($scope, $http, $timeout, $interval, Random, Song, Question, songsJSON) ->
    songIds = Random.shuffle(songsJSON.data.song_uris).slice(0,3)
    $scope.attempts = songIds.map((id) ->
      songId: id
      answeredIndex: null
      question: null
    )
    $scope.attemptIndex = -1
    $scope.currentA = null

    howlInstance = null
    $scope.playBarLoc = 0
    playBarTimer = null

    # 0:loading
    # 1:playing
    # 2:finished
    # 3:error
    setPlaybackStatus = (s) ->
      $timeout( ->
        $scope.playbackStatus = s
      , 1)

    runPlayBar = ->
      return unless howlInstance
      playBarTimer = $interval( ->
        unless howlInstance
          $interval.cancel(playBarTimer)
          return

        $scope.playBarLoc = Math.floor((howlInstance.pos() / 30) * 100)
        console.log("p")
      , 100, 300)

    nextAttempt = ->
      $scope.currentA = null
      setPlaybackStatus(0)
      $scope.attemptIndex += 1
      newAttempt = $scope.attempts[$scope.attemptIndex]
      $timeout( ->
        new Question(newAttempt.songId, (question) ->
          newAttempt.question = question
          $scope.currentA = newAttempt
          howlInstance = new Howl(
            urls: [question.correctSong.preview_url + ".mp3"]
            sprite: {song: [0, 30000]}
            onplay: ->
              setPlaybackStatus(1)
              runPlayBar()
            onend: ->
              setPlaybackStatus(2)
            onloaderror: ->
              setPlaybackStatus(3)
          ).play('song')
          window.myh = howlInstance
        )
      , 1500)

    $scope.submitAnswer = ->
      $interval.cancel(playBarTimer)
      $scope.playBarLoc = 0
      howlInstance.unload()
      setPlaybackStatus(-1)
      if $scope.attemptIndex >= $scope.attempts.length - 1
        alert('done')
        return
      nextAttempt()

    nextAttempt()

    
])
