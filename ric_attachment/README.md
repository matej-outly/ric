# RicAttachment

RicAttachment provides model and controllers for saving and retrieving file attachments for different objects in the application. Multiple (save) backends are provided for common WYSIWYG editors such as Froala Editor or TinyMCE. 

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_attachment"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_attachment:install:migrations
    $ rake db:migrate

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

Each attachment can be binded to subject which creates a scope in which the attachment is managed. Subject association is set as polymorphic so there is possibility to bind attachment to different subjects.

## Session ID and attachment claiming

In most cases attachments are managed (listed, created and destroyed) through the parent resource (typically some kind of WYSIWYG editor). Problem with this approach is in "new" action when the parent resource is not saved in DB (ID is not known yet) but editor requires some kind of ID cor attachments to be created in the correct scope. In this case, a temporary session ID must be used instead of resource ID. Both editor and backend should support subject ID and also session ID params (see editor settings example and backend implementation inside this module).

After parent resource is finally created and ID is obtained, this resource must claim temporary attachments created with the temporary session ID with this function:

```ruby
RicAttachment::Attachment.claim(parent, session_id)
```

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
    var sessionId = $(this).data('sessionId');
    if (subjectId && subjectType) {
        var params = { subject_id: subjectId, subject_type: subjectType };
        $.extend(editor.opts.imageManagerLoadParams, params);
        $.extend(editor.opts.imageManagerDeleteParams, params);
        $.extend(editor.opts.imageUploadParams, params);
        $.extend(editor.opts.fileUploadParams, params);
        $.extend(editor.opts.videoUploadParams, params);
    } else if (sessionId) {
        var params = { session_id: sessionId };
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

You can use RugBuilder to create a text area with Froala editor integrated:

```erb
<%= f.text_area_row :attribute_name, 
    plugin: :froala, 
    data: (
        @parent.new_record? ? { 
            session_id: session.id 
        } : { 
            subject_id: @parent.id, 
            subject_type: @parent.class.to_s 
        }
    ) %>
```

