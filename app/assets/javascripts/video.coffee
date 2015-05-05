$ ->

  $('video').mediaelementplayer
    enableAutosize: true
    features: ['playpause','current','volume','fullscreen']
    success: (media, node, player) ->
      $("##{node.id}-mode").html("mode: #{media.pluginType}")

  loadStream = (url) ->
    $('video')[0].player.setSrc(url)
    $('video')[0].player.play()
