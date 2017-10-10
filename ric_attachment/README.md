# RicAttachment

RicAttachment provides model and controllers for saving and retrieving file attachments for different objects in the application. Multiple (save) backends are provided for common WYSIWYG editors such as Froala Editor or TinyMCE. 

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_attachment"
```

Mount routing engine in your `routes.rb` file:

```ruby
mount RicAttachment::Engine => "/", as: :ric_attachment
```

## Configuration

You can configure module through `config/initializers/ric_attachment.rb` file:

```ruby
RicAttachment.setup do |config|
    config.enable_slugs = true
    config.editors = [:froala, :tinymce]
end
```

Available options:

- attachment_model
- enable_slugs
- editors

## Subject

Each attachment can be binded to subject which creates a scope in which the attachment is managed. Subject association is set as polymorphic so there is posiibility to bind attachment to different subjects.

## Slugs

Attachments can be suggified during save operation. In order to make it work you must integrate RicUrl module and set configuration option `enable_slugs` to `true`. Binded subjects must be slug generators too (must provide `compose_slug_translation` method).

## Froala Editor

You can use the following code to initialize Froala Editor and connect it to the RicAttachment backend. Of course, you must configure RicAttachment module to enable this editor. See Configuration chapter.

```javascript
$('textarea.froala').on('froalaEditor.initialized', function (e, editor) {
    
    /* Inject correct upload, load and delete params */
    $.extend(editor.opts.imageManagerLoadParams, { kind: 'image' });
    var subjectId = $(this).data('subjectId');
    var subjectType = $(this).data('subjectType');
    if (subjectId && subjectType) {
        var params = { subject_id: subjectId, subject_type: subjectType }
        $.extend(editor.opts.imageManagerLoadParams, params);
        $.extend(editor.opts.imageManagerDeleteParams, params);
        $.extend(editor.opts.imageUploadParams, params);
        $.extend(editor.opts.fileUploadParams, params);
        $.extend(editor.opts.videoUploadParams, params);
    }

    /* ... */
})
.froalaEditor({
    
    /* Upload, load and delete URLs */
    imageManagerLoadURL: '/froala',
    imageManagerDeleteURL: '/froala',
    imageManagerDeleteMethod: 'DELETE',
    imageUploadURL: '/froala',
    fileUploadURL: '/froala',
    videoUploadURL: '/froala',

    /* ... */
});

```

