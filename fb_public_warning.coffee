# warn people when they are doing something public.

updateNode = (node) ->
  $(node).find('[aria-label~="Public"]').closest('.userContentWrapper').css('background', '#fee')

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
