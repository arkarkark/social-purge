# background page for services

chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->
  chrome.pageAction.show(sender.tab.id) if request.message == 'showPageAction'
)

chrome.pageAction.onClicked.addListener((tab) ->
  console.log('pageAction Clicked')
)
