#! /usr/bin/env ruby

require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '/../lib/bb-ruby'))

# text = <<eot
# [b]Here is some bold text[/b]
# [i]Here is some italicized text[/i]
# [u]Underlined text[/u]
# [b]Bold, [u]underlined, and [i]italicized[/i][/u][/b]
# 
# a [del]mistake[/del] [ins]corrected[/ins]
# 
# List of stuff:
# [ul]
#         [*]Lions
#         [*]Tigers
#         [li]Bears[/li]
# [/ul]
# 
# [size=32]12px Text[/size]
# [color=red]Red Text[/color]
# [color=#ff0023]Hex Color Text[/color]
# 
# Link: [url=http://google.com]Google[/url]
# Link (implied): [url]http://google.com[/url]
# Link (automatic): http://google.com
# Image: [img]http://zoople/hochzeit.png[/img]
# Image: [img=http://zoople/hochzeit.png]
# Image (resized 1): [img size=96x96]http://zoople/hochzeit.png[/img]
# Image (resized 2): [img size="96x96"]http://zoople/hochzeit.png[/img]
# Image (resized 3): [img size='96x96']http://zoople/hochzeit.png[/img]
# Image (invalid): [img]http://google.com/google.img[/img]
# 
# [quote=Bush]Go kill them terrists[/quote]
# [quote]Something wise.[/quote]
# 
# [youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]
# [gvideo]http://video.google.com/videoplay?docid=-2200109535941088987[/gvideo]
# eot
# 
# output = text.bbcode_to_html
# puts output
# text.bbcode_to_html! #(:enable, :unorderedlist, :quote)
# puts text

class TestBBRuby < Test::Unit::TestCase

  def test_strong
    assert_equal '<strong>simple</strong>', '[b]simple[/b]'.bbcode_to_html
    assert_equal '<strong>simple</strong>', '[b:7a9ca2c5c3]simple[/b:7a9ca2c5c3]'.bbcode_to_html
  end
  
  def test_em
    assert_equal '<em>simple</em>', '[i]simple[/i]'.bbcode_to_html
    assert_equal '<em>simple</em>', '[i:7a9ca2c5c3]simple[/i:7a9ca2c5c3]'.bbcode_to_html
  end
  
  def test_u
    assert_equal '<u>simple</u>', '[u]simple[/u]'.bbcode_to_html
    assert_equal '<u>simple</u>', '[u:7a9ca2c5c3]simple[/u:7a9ca2c5c3]'.bbcode_to_html
  end
  
  def test_del
    assert_equal '<del>simple</del>', '[del]simple[/del]'.bbcode_to_html
    assert_equal '<del>simple</del>', '[del:7a9ca2c5c3]simple[/del:7a9ca2c5c3]'.bbcode_to_html
    assert_equal '<del>simple</del>', '[s]simple[/s]'.bbcode_to_html
    assert_equal '<del>simple</del>', '[s:7a9ca2c5c3]simple[/s:7a9ca2c5c3]'.bbcode_to_html
  end
    
  def test_ins
    assert_equal '<ins>simple</ins>', '[ins]simple[/ins]'.bbcode_to_html
    assert_equal '<ins>simple</ins>', '[ins:7a9ca2c5c3]simple[/ins:7a9ca2c5c3]'.bbcode_to_html
  end  
  
  def test_code
    assert_equal '<code>simple</code>', '[code]simple[/code]'.bbcode_to_html
    assert_equal '<code>simple</code>', '[code:7a9ca2c5c3]simple[/code:7a9ca2c5c3]'.bbcode_to_html
  end  
  
  def test_size
    assert_equal '<span style="font-size: 32px;">12px Text</span>', '[size=32]12px Text[/size]'.bbcode_to_html
  end
  
  def test_color
    assert_equal '<span style="color: red;">Red Text</span>', '[color=red]Red Text[/color]'.bbcode_to_html
    assert_equal '<span style="color: #ff0023;">Hex Color Text</span>', '[color=#ff0023]Hex Color Text[/color]'.bbcode_to_html
  end
  
  def test_ordered_list
    assert_equal '<ol><li>item 1</li><li>item 2</li></ol>', '[ol][li]item 1[/li][li]item 2[/li][/ol]'.bbcode_to_html
    assert_equal '<ol><li>item 1</li><li>item 2</li></ol>', '[ol][*]item 1[li]item 2[/li][/ol]'.bbcode_to_html
  end

  def test_unordered_list
    assert_equal '<ul><li>item 1</li><li>item 2</li></ul>', '[ul][li]item 1[/li][li]item 2[/li][/ul]'.bbcode_to_html
    assert_equal '<ul><li>item 1</li><li>item 2</li></ul>', '[ul][*]item 1[li]item 2[/li][/ul]'.bbcode_to_html
  end
  
  def test_definition_list_term_definition
    assert_equal '<dl><dt>term 1</dt><dd>definition 1</dd><dt>term 2</dt><dd>definition 2</dd></dl>', '[dl][dt]term 1[/dt][dd]definition 1[/dd][dt]term 2[/dt][dd]definition 2[/dd][/dl]'.bbcode_to_html
  end
  
  def test_quote
    assert_equal '<fieldset><blockquote>quoting</blockquote></fieldset>', '[quote]quoting[/quote]'.bbcode_to_html
    assert_equal '<fieldset><legend>"black"</legend><blockquote>si el niño hubiera sido de "penalty" le hubieran llamado <strong>system Error</strong>!!! :)</blockquote></fieldset>', "[quote:7a9ca2c5c3=\"black\"]si el niño hubiera sido de \"penalty\" le hubieran llamado [b:7a9ca2c5c3]system Error[/b:7a9ca2c5c3]!!! :)[/quote:7a9ca2c5c3]".bbcode_to_html
    assert_equal '<fieldset><legend>Who</legend><blockquote>said that</blockquote></fieldset>', '[quote=Who]said that[/quote]'.bbcode_to_html
  end
  
  def test_link
    assert_equal '<a href="http://google.com">Google</a>', '[url=http://google.com]Google[/url]'.bbcode_to_html
    assert_equal '<a href="http://google.com">http://google.com</a>', '[url]http://google.com[/url]'.bbcode_to_html
  end
  
  def test_image
    assert_equal '<img src="http://zoople/hochzeit.png" alt="" />', '[img]http://zoople/hochzeit.png[/img]'.bbcode_to_html
    assert_equal '<img src="http://zoople/hochzeit.png" alt="" />', '[img=http://zoople/hochzeit.png]'.bbcode_to_html
    assert_equal '<img src="http://zoople/hochzeit.png" style="width: 95px; height: 96px;" />', '[img size=95x96]http://zoople/hochzeit.png[/img]'.bbcode_to_html
    # Image (resized 1): 
    # Image (resized 2): [img size="96x96"]http://zoople/hochzeit.png[/img]
    # Image (resized 3): [img size='96x96']http://zoople/hochzeit.png[/img]
    # Image (invalid): [img]http://google.com/google.img[/img]
  
  end
  
  def test_youtube
  end
  
  def test_google_video
  end
    
end