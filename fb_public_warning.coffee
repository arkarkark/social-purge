# warn people when they are doing something public.

# test urls
# https://www.facebook.com/search/str/amazon/keywords_top
# https://www.facebook.com/Amazon/photos/a.10150354146103124.344011.9465008123/10152077194838124

return # DO NOT SUBMIT

return unless location.hostname.match(/facebook\.com/)

decorateAsPublic = (els) ->
  els.css('background', '#fff5f5')

highlightPublic = (els) ->
  decorateAsPublic(els)
  els.find('.UFILikeLink,.share_action_link').click((event) ->
    return true if $(event.target).text() == 'Unlike'
    confirm('This is a puclic ation.\nAre you sure you want to continue?')
  )

isInPublic = (el) ->
  x = el.closest('.userContentWrapper,.uiScrollableAreaBody,.fbPhotoPageInfo').find('[aria-label~="Public"]')
  x && x.length

updateNode = (node) ->
  publicEls = $(node).find('[aria-label~="Public"]')
  console.log('updateNode', publicEls) if publicEls.length
  highlightPublic(publicEls.closest('.userContentWrapper').parent())
  highlightPublic(publicEls.closest('.uiScrollableAreaBody,.fbPhotoPageInfo'))

  editable = $(node).find('[contenteditable]')
  if editable && editable.length && isInPublic(editable)
    decorateAsPublic(editable.closest('.UFIAddCommentInput'))


# watch when things change on the page!
observer = new MutationObserver((mutations) ->
  mutations.some((mutation) ->
    if mutation.addedNodes?.length
      console.log('added', mutation.addedNodes)
      [].slice.call(mutation.addedNodes).forEach((node) ->
        console.log('updateNode', node)
        updateNode(document.body)
      )
  )
)
config =
  childList: true
  subtree: true
observer.observe(document.body, config)
updateNode(document.body)

window.__ark__updateNode = updateNode

for x in [500, 1000, 1500, 2000]
  window.setTimeout(
    -> updateNode(document.body)
    x
  )
