# BBRuby

* [http://rubygems.org/gems/bb-ruby](http://rubygems.org/gems/bb-ruby) [![Build Status](https://travis-ci.org/cpjolicoeur/bb-ruby.png?branch=master)](https://travis-ci.org/cpjolicoeur/bb-ruby)

## Description:

BBRuby is a [BBCode](http://www.bbcode.org) implementation for Ruby. It will convert strings with BBCode markup to their HTML equivalent.

## Installation:

    gem install bb-ruby


## Usage:

    require 'bb-ruby'

BBRuby has been included directly into the String class for use on any string object:
```rb
text = "[b]Here is some bold text[/b] followed by some [u]underlined text[/u]"
output = text.bbcode_to_html
text.bbcode_to_html!
```
BBRuby will auto-escape HTML tags.  To prevent this just pass false as the second param:
```rb
output = text.bbcode_to_html({}, false)
```
Only allow certain tags:
```rb
output = text.bbcode_to_html({}, true, :enable, :image, :bold, :quote)
```
Disable certain tags:
```rb
output = text.bbcode_to_html({}, true, :disable, :image, :bold, :quote)
```
Alternative Direct usage:
```rb
output = BBRuby.to_html(bbcode_markup)
```
Define your own translation, in order to be more flexible:
```rb
my_blockquote = {
  'Quote' => [
    /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/mi,
    '<div class="quote"><p><cite>\2</cite></p><blockquote>\3</blockquote></div>',
    'Quote with citation',
    '[quote=mike]please quote me[/quote]',
    :quote
  ],
}

text.bbcode_to_html(my_blockquote)
```
Define Proc as replacement:
```rb
module BBRuby
  @@tags = @@tags.merge({
      'File' => [
        /\[file(:.*)?=(.*?)\](.*?)\[\/file\1?\]/mi,
        lambda{ |e| "<div class="file"><p><cite>#{e[3]}</cite></p><blockquote>#{file_read_method(e[2])}</blockquote></div>"},
        'File content with citation',
        '[file=script.rb]Script Caption[/file]',
        :file
      ],
    })
end
```
You can also use the `simple_format` method of ActionPack by using the *_with_formatting methods:
```rb
output = text.bbcode_to_html_with_formatting
output = text.bbcode_to_html_with_formatting!
```

### TAGS PROCESSED:

The following is the list of BBCode tags processed by BBRuby and their associated symbol for enabling/disabling them

    [b]               :bold
    [i]               :italics
    [u]               :underline
    [s]               :strikeout
    [del]             :delete
    [ins]             :insert
    [code]            :code
    [size]            :size
    [color]           :color
    [ol]              :orderedlist
    [ul]              :unorderedlist
    [li]              :listitem
    [*]               :listitem
    [list]            :listitem
    [list=1]          :listitem
    [list=a]          :listitem
    [dl]              :definelist
    [dt]              :defineterm
    [dd]              :definition
    [quote]           :quote
    [quote=source]    :quote
    [url=link]        :link
    [url]             :link
    [img size=]       :image
    [img align=]      :image
    [img=]            :image
    [img]             :image
    [youtube]         :video
    [gvideo]          :video
    [vimeo]           :video
    [email]           :email
    [align]           :align
    [left]            :left
    [center]          :center
    [right]           :right
    [br]              :br
