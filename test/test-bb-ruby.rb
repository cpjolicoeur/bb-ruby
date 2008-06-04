#! /usr/bin/env ruby
load 'lib/bb-ruby.rb'

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

[size=32]12px Text[/size]
[color=red]Red Text[/color]
[color=#ff0023]Hex Color Text[/color]





Link: [url=http://google.com]Google[/url]
Link (implied): [url]http://google.com[/url]
Link (automatic): http://google.com
Image: [img]http://zoople/hochzeit.png[/img]
Image: [img=http://zoople/hochzeit.png]
Image (resized 1): [img size=96x96]http://zoople/hochzeit.png[/img]
Image (resized 2): [img size="96x96"]http://zoople/hochzeit.png[/img]
Image (resized 3): [img size='96x96']http://zoople/hochzeit.png[/img]
Image (invalid): [img]http://google.com/google.img[/img]

[quote=Bush]Go kill them terrists[/quote]
[quote]Something wise.[/quote]

[youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]
[gvideo]http://video.google.com/videoplay?docid=-2200109535941088987[/gvideo]
eot

output = BBRuby.to_html(text)
puts output

# text.bbcode_to_html! #(:enable, :unorderedlist, :quote)
# puts text
