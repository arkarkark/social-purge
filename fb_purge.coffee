# remove old stuff from facebook

console.log("fb_purge")

return unless location.hostname.match(/facebook\.com/)
return unless location.pathname.match(/\/[a-z0-9_.-]+\/allactivity\/?$/i)


console.log("fb_purge SHOWING!")

chrome.runtime.sendMessage({message: "showPageAction"})

chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->

  console.log("got a message", arguments)
)

if window == top
  chrome.extension.onRequest.addListener((req, sender, sendResponse) ->
    console.log("got a request!", arguments)
    sendResponse("fliipy")
  )


# $($('.fbTimelineLogStream')[3])
# [<div class=​"fbTimelineLogStream" id=​"pagelet_all_activity_2015_2">​</div>​]
