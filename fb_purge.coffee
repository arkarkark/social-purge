# remove old stuff from facebook

return unless location.hostname.match(/facebook\.com/)
return unless location.pathname.match(/\/[a-z0-9_.-]+\/allactivity\/?$/i)


chrome.runtime.sendMessage({message: "showPageAction"})

chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->

  console.log("got a message", arguments)
)

if window == top
  chrome.extension.onRequest.addListener((req, sender, sendResponse) ->
    sendResponse("fliipy")
    purge()
  )


# $($('.fbTimelineLogStream')[3])
# [<div class=​"fbTimelineLogStream" id=​"pagelet_all_activity_2015_2">​</div>​]
# $('#pagelet_all_activity_2015_2').is(':visible')

oldest_year = 2010


purge = ->
  console.log("Purging")
  purgePage().then(->
    scrollDown().then((scrolled)->
      console.log("scrolling promise resolved with", scrolled)
      purge() if scrolled
    )
  )

# return a random positive number between 0 and amount
wiggle = (amount=100) ->
  Math.floor(Math.random(amount))

# returns a promise that resolves with false if we appear to be at the bottom of the page
scrollDown = (count=3, lastScrollTop=-1, promise=null) ->
  el = document.body
  promise ?= $.Deferred()
  lastScrollTop = el.scrollTop if lastScrollTop == -1
  console.log("Scrollin'", count, lastScrollTop, el.scrollHeight)
  window.scrollTo(0, el.scrollHeight)
  window.setTimeout(
    ->
      if count < 1
        console.log("Done scrollin", count, lastScrollTop, el.scrollTop)
        promise.resolve(el.scrollTop != lastScrollTop)
      else
        scrollDown(count - 1, lastScrollTop, promise)
    1000 + wiggle()
  )
  promise

purgePage = ->
  promise = $.Deferred()

  today = new Date()
  monthsCount = (today.getFullYear() * 12) + today.getMonth() - 2
  year = Math.floor(monthsCount / 12)
  month = monthsCount % 12

  purgeMonths(year, month, promise)
  return promise

purgeMonths = (year, month, promise) ->
  purgeMonth(year, month, promise).then(->
    month -= 1
    if month < 1
      month = 12
      year -= 1
    if year < oldest_year
      promise.resolve()
    else
      purgeMonths(year, month, promise)
  )

purgeMonth = (year, month) ->
  id = "pagelet_all_activity_#{year}_#{month}"
  container = $("##{id}")
  visibilitySelectors = container.find(".audienceSelector,.uiStreamPrivacy").next().find("a")
  console.log("#{id} has ", visibilitySelectors.length, " visibilitySelectors") if visibilitySelectors.length

  monthPromise = $.Deferred()
  clickVisibilitySelector(0, visibilitySelectors, monthPromise)
  return monthPromise

clickVisibilitySelector = (idx, selectors, promise) ->
  if idx >= selectors.length
    promise.resolve()
    return
  selectors[idx].click()
  window.setTimeout(
    ->
      deleteMenuItem = $('a[ajaxify^="/ajax/timeline/delete/confirm"]')
      if deleteMenuItem.length
        console.log("Deleting", idx, selectors[idx]) # , selectors)
        deleteMenuItem?[0]?.click()
        window.setTimeout(
          ->
            cancelConfirmButton = $('a[role="button"]').filter((idx, x) -> x.innerText?.indexOf("Cancel") != -1)
            deleteConfirmButton = $("button").filter((idx, x) -> x.innerText?.indexOf("Delete Post") != -1)
            console.log(deleteConfirmButton)
            deleteConfirmButton?[0]?.click()
            # cancelConfirmButton?[0]?.click()
            # move onto the next one
            window.setTimeout(
              ->
                clickVisibilitySelector(idx + 1, selectors, promise)
              200 + wiggle()
            )
          500 + wiggle()
        )
      else
        # maybe it was an unlike thing?
        unlike = $('a[ajaxify^="/ajax/timeline/all_activity/remove_content"]')
        if unlike.length
          console.log("Unliking", idx, selectors[idx]) # , selectors)
          unlike[0].click()
          window.setTimeout(
            ->
              clickVisibilitySelector(idx + 1, selectors, promise)
            200 + wiggle()
          )
        else
          console.log("Can't click", idx, selectors[idx]) # , selectors)

          clickVisibilitySelector(idx + 1, selectors, promise)
    200 + wiggle()
  )
