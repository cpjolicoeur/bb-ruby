#! /usr/bin/env ruby
load 'bbcode.rb'

text = <<eot
[b]Here is some bold text[/b]
[i]Here is some italicized text[/i]
[u]Underlined text[/u]
[b]Bold, [u]underlined, and [i]italicized[/i][/u][/b]

a [del]mistake[/del] [ins]corrected[/ins]

List of stuff:
[ul]
        [*]Lions
        [*]Tigers
        [li]Bears[/li]
[/ul]

Link: [url=http://google.com]Google[/url]
Link (implied): [url]http://google.com[/url]
Link (automatic): http://google.com
Image: [img]http://zoople/hochzeit.png[/img]
Image: [img=http://zoople/hochzeit.png]
Image (invalid): [img]http://google.com/google.img[/img]

[quote=Bush]Go kill them terrists[/quote]
[quote]Something wise.[/quote]
eot

text.bbcode_to_html!(:enable, :unorderedlist, :quote)

puts text
