# warn people when they are doing something public.

# test urls
# https://plus.google.com/+TED/posts/PzajYPc3j2Y

return unless location.hostname.match(/plus\.google\.com/)

decorateAsPublic = (els) ->
  els.css('background', '#fff5f5')

highlightPublic = (els) ->
  decorateAsPublic(els)

updateNode = (node) ->
  publicEls = $(node).find('span:contains("Shared publicly")')
  highlightPublic(publicEls.closest('[role="article"]').children())

# watch when things change on the page!
observer = new MutationObserver((mutations) ->
  mutations.some((mutation) ->
    if mutation.addedNodes
      [].slice.call(mutation.addedNodes).forEach((node) -> updateNode(node))
  )
)
config =
  childList: true
  subtree: true
observer.observe(document.body, config)
updateNode(document.body)
