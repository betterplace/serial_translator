# SerialTranslator

[![Gem Version](https://badge.fury.io/rb/serial_translator.svg)](http://badge.fury.io/rb/serial_translator)
[![Build Status](https://github.com/betterplace/serial_translator/workflows/tests/badge.svg)](https://github.com/betterplace/serial_translator/actions)

Translate ActiveRecord object attributes without the use of additional models.

## Installation

Add it to your Gemfile:

    gem 'serial_translator', '~> 2.0'

## Usage

Add a `*_translations` column to your table, e.g. `title_translations`.

```ruby
class AddTitleTranslationsToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :title_translations, :text
  end
end
```

In your model, call `#serial_translator_for`.

```ruby
class BlogPost < ActiveRecord::Base
  serial_translator_for :title
  # [...]
end
```

Now you can read and write `title_translations` or `title_#{locale}` or `title(locale)`.

```ruby
blog_post = BlogPost.new
blog_post.title_translations = { de: 'Hallo Welt', en: 'Hello world' }
blog_post.title_en # => "Hello world"
blog_post.title(:en) # => "Hello world"
blog_post.translated_locales # => [:de, :en]
```

Setting or getting the field name without specifying a locale defaults to the current locale.

```ruby
I18n.locale = :de
blog_post.title # => "Hallo Welt"
blog_post.title = 'Hey'
blog_post.title_translations # => { de: 'Hey', en: 'Hello world' }
```

So if you add a `title` field to a BlogPost form it will work on the title in the user’s locale by default. You can override this by setting the record’s `#current_translation_locale`.

Add length or presence validations if you want. They will use the same localization keys for error messages as the standard length and presence validations.

```ruby
class BlogPost < ActiveRecord::Base
  validates :title, serial_translator_presence: true
  validates :text,  serial_translator_length: { minimum: 100 }
end
```

## Contributing

`SerialTranslator` is released under the [Apache License 2.0](LICENSE.txt) and
Copyright 2013...2021 [gut.org gAG](https://gut.org).

0. Consider creating an [issue](https://github.com/betterplace/serial_translator/issues) and start a discussion
1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
