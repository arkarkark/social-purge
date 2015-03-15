# warn people when they are doing something public.

# test urls
# https://www.facebook.com/search/str/amazon/keywords_top
# https://www.facebook.com/Amazon/photos/a.10150354146103124.344011.9465008123/10152077194838124

return unless location.hostname.match(/facebook\.com/)

highlightPublic = (els) ->
  els.css('background', '#fee')

stopForms = (forms) ->
  forms.submit((event) ->
    console.log('submit')
    event.preventDefault()
    false
  )

updateNode = (node) ->
  publicEls = $(node).find('[aria-label~="Public"]')
  highlightPublic(publicEls.closest('.userContentWrapper').parent())
  highlightPublic(publicEls.closest('.uiScrollableAreaBody,.fbPhotoPageInfo'))
  stopForms(publicEls.closest('form'))

  likes = $(node).find('.UFILikeLink,.share_action_link').click((event) ->
    return true if $(event.target).text() == 'Unlike'
    confirm('This is a puclic ation.\nAre you sure you want to continue?')
  )

  x = $(node).find('[action~="add_comment"]')
  if x && x.length
    console.log(x)


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
