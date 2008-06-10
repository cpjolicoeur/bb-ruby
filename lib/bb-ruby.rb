module BBRuby
  @@imageformats = 'png|bmp|jpg|gif'
  @@tags = {
    # tag name => [regex, replace, description, example, enable/disable symbol]
    'Bold' => [
      /\[b\](.*?)\[\/b\]/,
      '<strong>\1</strong>',
      'Embolden text',
      'Look [b]here[/b]',
      :bold],
    'Italics' => [
      /\[i\](.*?)\[\/i\]/,
      '<em>\1</em>',
      'Italicize or emphasize text',
      'Even my [i]cat[/i] was chasing the mailman!',
      :italics],
    'Underline' => [
      /\[u\](.*?)\[\/u\]/,
      '<u>\1</u>',
      'Underline',
      'Use it for [u]important[/u] things or something',
      :underline],
    'Strikeout' => [
      /\[s\](.*?)\[\/s\]/,
      '<del>\1</del>',
      'Strikeout',
      '[s]nevermind[/s]',
      :strikeout],
    'Delete' => [
      /\[del\](.*?)\[\/del\]/,
      '<del>\1</del>',
      'Deleted text',
      '[del]deleted text[/del]',
      :delete],
    'Insert' => [
      /\[ins\](.*?)\[\/ins\]/,
      '<ins>\1</ins>',
      'Inserted Text',
      '[ins]inserted text[/del]',
      :insert],

    'Size' => [
      /\[size=['"]?(.*?)['"]?\](.*?)\[\/size\]/im,
      '<span style="font-size: \1px;">\2</span>',
      'Change text size',
      '[size=20]Here is some larger text[/size]',
      :size],
    'Color' => [
      /\[color=['"]?(.*?)['"]?\](.*?)\[\/color\]/im,
      '<span style="color: \1;">\2</span>',
      'Change text color',
      '[color=red]This is red text[/color]',
      :color],
  
    'Ordered List' => [
      /\[ol\](.*?)\[\/ol\]/m,
      '<ol>\1</ol>',
      'Ordered list',
      'My favorite people (alphabetical order): [ol][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ol]',
      :orderedlist],
    'Unordered List' => [
      /\[ul\](.*?)\[\/ul\]/m,
      '<ul>\1</ul>',
      'Unordered list',
      'My favorite people (order of importance): [ul][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ul]',
      :unorderedlist],
    'List Item' => [
      /\[li\](.*?)\[\/li\]/,
      '<li>\1</li>',
      'List item',
      'See ol or ul',
      :listitem],
    'List Item (alternative)' => [
      /\[\*\](.*?)$/,
      '<li>\1</li>',
      'List item (alternative)',
      nil, nil,
      :listitem],
  
    'Definition List' => [
      /\[dl\](.*?)\[\/dl\]/m,
      '<dl>\1</dl>',
      'List of terms/items and their definitions',
      '[dl][dt]Fusion Reactor[/dt][dd]Chamber that provides power to your... nerd stuff[/dd][dt]Mass Cannon[/dt][dd]A gun of some sort[/dd][/dl]',
      :definelist],
    'Definition Term' => [
      /\[dt\](.*?)\[\/dt\]/,
      '<dt>\1</dt>',
      'List of definition terms',
      nil, nil,
      :defineterm],
    'Definition Definition' => [
      /\[dd\](.*?)\[\/dd\]/,
      '<dd>\1</dd>',
      'Definition definitions',
      nil, nil,
      :definition],
  
    'Quote' => [
      /\[quote=(.*?)\](.*?)\[\/quote\]/m,
      '<fieldset>
<legend>\1</legend>
<blockquote>\2</blockquote>
</fieldset>',
      'Quote with citation',
      nil, nil,
      :quote],
    'Quote (Sourceless)' => [
      /\[quote\](.*?)\[\/quote\]/m,
      '<fieldset>
<blockquote>\1</blockquote>
</fieldset>',
      'Quote (sourceclass)',
      nil, nil,
      :quote],
  
    'Link' => [
      /\[url=(.*?)\](.*?)\[\/url\]/,
      '<a href="\1">\2</a>',
      'Hyperlink to somewhere else',
      'Maybe try looking on [url=http://google.com]Google[/url]?',
      nil, nil,
      :link],
    'Link (Implied)' => [
      /\[url\](.*?)\[\/url\]/,
      '<a href="\1">\1</a>',
      'Hyperlink (implied)',
      nil, nil,
      :link],
    # 
    # TODO: fix automatic links
    #
    # 'Link (Automatic)' => [
    #   /http:\/\/(.*?)[^<\/a>]/,
    #   '<a href="\1">\1</a>',
    #   'Hyperlink (automatic)',
    #   nil, nil,
    #   :link],
  
    'Image' => [
      /\[img\]([^\[\]].*?)\.(#{@@imageformats})\[\/img\]/i,
      '<img src="\1.\2" alt="" />',
      'Display an image',
      'Check out this crazy cat: [img]http://catsweekly.com/crazycat.jpg[/img]',
      :image],
    'Image (Alternative)' => [
      /\[img=([^\[\]].*?)\.(#{@@imageformats})\]/i,
      '<img src="\1.\2" alt="" />',
      'Display an image (alternative format)', 
      '[img=http://myimage.com/logo.gif]',
      :image],
    'Image (Resized)' => [
      /\[img size=['"]?(\d+)x(\d+)['"]?\](.*?)\[\/img\]/i,
      '<img src="\3" style="width: \1px; height: \2px;" />',
      'Display an image with a set width and height', 
      '[img size=96x96]http://www.google.com/intl/en_ALL/images/logo.gif[/img]',
      :image],
      
    'YouTube' => [
      /\[youtube\](.*?)\?v=([\w\d\-]+).*\[\/youtube\]/i,
      '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      'Display a video from YouTube.com', 
      '[youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]',
      :video],
    'YouTube (Alternative)' => [
      /\[youtube\](.*?)\/v\/([\w\d\-]+)\[\/youtube\]/i,
      '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      'Display a video from YouTube.com (alternative format)', 
      '[youtube]http://youtube.com/watch/v/E4Fbk52Mk1w[/youtube]',
      :video],
    'Google Video' => [
      /\[gvideo\](.*?)\?docid=([-]{0,1}\d+).*\[\/gvideo\]/i,
      '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2" flashvars=""> </embed>',
      'Display a video from Google Video', 
      '[gvideo]http://video.google.com/videoplay?docid=-2200109535941088987[/gvideo]',
      :video]
  }
  def self.to_html(text, method = :disable, *tags)
    text = text.clone
    # escape < and > to remove any html
    text.gsub!( '<', '&lt;' )
    text.gsub!( '>', '&gt;' )
    
    # parse bbcode tags
    case method
      when :enable
        @@tags.each_value { |t|
          text.gsub!(t[0], t[1]) if tags.include?(t[4])
        }
      when :disable
        # this works nicely because the default is disable and the default set of tags is [] (so none disabled) :)
        @@tags.each_value { |t|
          text.gsub!(t[0], t[1]) unless tags.include?(t[4])
        }
    end
    
    # parse spacing
    text.gsub!( /\r\n?/, "\n" )
    text.gsub!( /\n/, "<br />" )
    
    # return markup
    text
  end
  
  def self.tags
    @@tags.each { |tn, ti|
      # yields the tag name, a description of it and example
      yield tn, ti[2], ti[3] if ti[2]
    }
  end
end

class String
  def bbcode_to_html(method = :disable, *tags)
          BBRuby.to_html(self, method, tags)
  end
  def bbcode_to_html!(method = :disable, *tags)
          self.replace(BBRuby.to_html(self, method, tags))
  end
end
