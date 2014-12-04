sq = angular.module('sq')

sq.service('spotifyCache', [
  'Spotify'
  (Spotify) ->
    getCacheKey = (getFn, args) ->
      "#{getFn}|#{args.join('|')}"

    get: (getFn, args, cb) ->
      self = @
      cacheKey = getCacheKey(getFn, args)
      cachedResponse = localStorage[cacheKey]
      if cachedResponse
        cb(JSON.parse(cachedResponse))
      else
        Spotify[getFn].apply(Spotify, args).then((response) ->
          localStorage[cacheKey] = JSON.stringify(response)
          cb(response)
        )
])

sq.service('Song', [
  'spotifyCache'
  (spotifyCache) ->
    return class Song
      constructor: (@uri, cb) ->
        self = @
        spotifyCache.get('getTrack', [@uri], (track) ->
          self.writeSongObjectToInstance(track)
          cb(self)
        )

      writeSongObjectToInstance: (object) ->
        @id = object.id
        @name = object.name
        @share_url = object.external_urls.spotify
        @preview_url = object.preview_url
        @artists = object.artists
])

sq.service('Question', [
  'Song'
  'spotifyCache'
  'Random'
  (Song, spotifyCache, Random) ->
    questionKinds = ['artist', 'name']
    bannedWrongAnswers = ['Ben Folds', 'Ben Folds Five']
    wrongAnswerAllowed = (answer) -> bannedWrongAnswers.indexOf(answer) is -1

    return class Question
      constructor: (correctUri, cb) ->
        @kind = 'artist'
        self = @
        new Song(correctUri, (song) ->
          self.correctSong = song
          self.generateWrongs (wrongStrings) ->
            self.correctIndex = Random.range(0, 3)
            wrongStrings.splice(self.correctIndex, 0, song.artists[0].name)
            self.answerStrings = wrongStrings
            cb(self)
        )

      generateWrongs: (cb) ->
        spotifyCache.get('getRelatedArtists', [@correctSong.artists[0].id], (response) ->
          cb(response.artists.map((artist) -> artist.name).filter(wrongAnswerAllowed).slice(0, 4))
        )
      
])

sq.service('Random', ->
  {
    range: (min, max) -> Math.floor(Math.random() * (max - min + 1)) + min
    shuffle: (array) ->
      currentIndex = array.length
      temporaryValue = null
      randomIndex = null
      while 0 isnt currentIndex
        randomIndex = Math.floor(Math.random() * currentIndex)
        currentIndex -= 1
        temporaryValue = array[currentIndex]
        array[currentIndex] = array[randomIndex]
        array[randomIndex] = temporaryValue
      array
  }
)
