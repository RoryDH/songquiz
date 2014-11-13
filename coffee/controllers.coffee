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
  'Random'
  'Song'
  'Question'
  'songsJSON'
  ($scope, $http, $timeout, Random, Song, Question, songsJSON) ->
    songIds = Random.shuffle(songsJSON.data.song_uris).slice(0,3)
    $scope.attempts = songIds.map((id) ->
      songId: id
      answeredIndex: null
      question: null
    )
    $scope.attemptIndex = -1
    $scope.currentA = null
    howlInstance = null

    setPlaybackStatus = (s) ->
      $timeout( ->
        $scope.playbackStatus = s
      , 1)

    nextAttempt = ->
      $scope.currentA = null
      setPlaybackStatus("Loading audio...")
      $scope.attemptIndex += 1
      newAttempt = $scope.attempts[$scope.attemptIndex]
      new Question(newAttempt.songId, (question) ->
        newAttempt.question = question
        $scope.currentA = newAttempt
        howlInstance = new Howl(
          urls: [question.correctSong.preview_url + ".mp3"]
          onplay: -> setPlaybackStatus("Playing audio!")
          onend: -> setPlaybackStatus("Playback finished")
          onloaderror: -> setPlaybackStatus("Error loading audio!")
        ).play()
      )

    $scope.submitAnswer = ->
      howlInstance.unload()
      setPlaybackStatus("_")
      if $scope.attemptIndex >= $scope.attempts.length - 1
        alert('done')
        return
      nextAttempt()

    nextAttempt()

    
])
