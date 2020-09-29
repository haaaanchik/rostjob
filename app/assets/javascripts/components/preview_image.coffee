class RostJob.PreviewImage
  @init: ->
    @bind()

  @bind: ->
    $(document).on 'change', 'input[type="file"]', @showPreview

  @showPreview: (e) ->
    files = e.target.files
    image = files[0]

    if files && image
      reader = new FileReader
      reader.onload = (event) ->
        $('img#preview-logo').attr('src', event.target.result)
        return

      reader.readAsDataURL image
    return