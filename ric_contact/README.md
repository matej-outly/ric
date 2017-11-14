# RicContact

## Installation

## Configuration

## reCAPTCHA

```ruby
Recaptcha.configure do |config|
    config.site_key   = "6LcTEDgUAAAAABC20zEgqqitk1mR7ss9S2Hfj3Sy"
    config.secret_key = "6LcTEDgUAAAAAGK5sAnV5DGuALxdn4t0qy50ph-2"
end
```

```ruby
def save_with_recaptcha
    (user_signed_in? || use_recaptcha != true || verify_recaptcha(model: @sample, attribute: :recaptcha)) && @sample.save
end
```

### Simple tag

```erb
<%= recaptcha_tags %>
```

### Multiple tags on one page

```js
var recaptchaOnload = function() {
    ['recaptcha-1', 'recaptcha-2'].forEach(function(elementId) {
        var element = document.getElementById(elementId);
        if (element) {
            grecaptcha.render(element, {
                'sitekey' : '<%= Recaptcha.configuration.site_key %>'
            });
        }
    });
};
```

```erb
<script src="https://www.google.com/recaptcha/api.js?onload=recaptchaOnload&render=explicit" async defer></script>
```

```erb
<div id="recaptcha-1" class="recaptcha"></div>
```