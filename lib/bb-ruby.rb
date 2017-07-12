module BBRuby
  # allowable image formats
  @@imageformats = 'png|bmp|jpg|gif|jpeg'
  @@quote_matcher = '(&quot;|&apos;|)'

  # built-in BBCode tabs that will be processed
  @@tags = {
    # tag name => [regex, replace, description, example, enable/disable symbol]
    'Bold' => [
      /\[b(:.*)?\](.*?)\[\/b\1?\]/mi,
      '<strong>\2</strong>', #Proc alternative for example: lambda{ |e| "<strong>#{e[2]}</strong>" }
      'Embolden text',
      'Look [b]here[/b]',
      :bold],
    'Italics' => [
      /\[i(:.+)?\](.*?)\[\/i\1?\]/mi,
      '<em>\2</em>',
      'Italicize or emphasize text',
      'Even my [i]cat[/i] was chasing the mailman!',
      :italics],
    'Underline' => [
      /\[u(:.+)?\](.*?)\[\/u\1?\]/mi,
      '<span style="text-decoration:underline;">\2</span>',
      'Underline',
      'Use it for [u]important[/u] things or something',
      :underline],
    'Strikeout' => [
      /\[s(:.+)?\](.*?)\[\/s\1?\]/mi,
      '<del>\2</del>',
      'Strikeout',
      '[s]nevermind[/s]',
      :strikeout],
    'Delete' => [
      /\[del(:.+)?\](.*?)\[\/del\1?\]/mi,
      '<del>\2</del>',
      'Deleted text',
      '[del]deleted text[/del]',
      :delete],
    'Insert' => [
      /\[ins(:.+)?\](.*?)\[\/ins\1?\]/mi,
      '<ins>\2</ins>',
      'Inserted Text',
      '[ins]inserted text[/ins]',
      :insert],
    'Code' => [
      /\[code(:.+)?\](.*?)\[\/code\1?\]/mi,
      '<code>\2</code>',
      'Code Text',
      '[code]some code[/code]',
      :code],
    'Size' => [
      /\[size=#{@@quote_matcher}(.*?)\1\](.*?)\[\/size\]/im,
      '<span style="font-size: \2px;">\3</span>',
      'Change text size',
      '[size=20]Here is some larger text[/size]',
      :size],
    'Color' => [
      /\[color=#{@@quote_matcher}(\w+|\#\w{6})\1(:.+)?\](.*?)\[\/color\3?\]/im,
      '<span style="color: \2;">\4</span>',
      'Change text color',
      '[color=red]This is red text[/color]',
      :color],
    'Ordered List' => [
      /\[ol\](.*?)\[\/ol\]/mi,
      '<ol>\1</ol>',
      'Ordered list',
      'My favorite people (alphabetical order): [ol][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ol]',
      :orderedlist],
    'Unordered List' => [
      /\[ul\](.*?)\[\/ul\]/mi,
      '<ul>\1</ul>',
      'Unordered list',
      'My favorite people (order of importance): [ul][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ul]',
      :unorderedlist],
    'List Item' => [
      /\[li\](.*?)\[\/li\]/mi,
      '<li>\1</li>',
      'List item',
      '[li]list item[/li]',
      :listitem],
    'List Item (alternative)' => [
      /\[\*(:[^\[]+)?\]([^(\[|\<)]+)/mi,
      '<li>\2</li>',
      'List item (alternative)',
      '[*]list item',
      :listitem],
    'Unordered list (alternative)' => [
      /\[list(:.*)?\]((?:(?!\[list(:.*)?\]).)*)\[\/list(:.)?\1?\]/mi,
      '<ul>\2</ul>',
      'Unordered list item',
      '[list][*]item 1[*] item2[/list]',
      :list],
    'Ordered list (numerical)' => [
      /\[list=1(:.*)?\](.+)\[\/list(:.)?\1?\]/mi,
      '<ol>\2</ol>',
      'Ordered list numerically',
      '[list=1][*]item 1[*] item2[/list]',
      :list],
    'Ordered list (alphabetical)' => [
      /\[list=a(:.*)?\](.+)\[\/list(:.)?\1?\]/mi,
      '<ol sytle="list-style-type: lower-alpha;">\2</ol>',
      'Ordered list alphabetically',
      '[list=a][*]item 1[*] item2[/list]',
      :list],
    'Definition List' => [
      /\[dl\](.*?)\[\/dl\]/im,
      '<dl>\1</dl>',
      'List of terms/items and their definitions',
      '[dl][dt]Fusion Reactor[/dt][dd]Chamber that provides power to your... nerd stuff[/dd][dt]Mass Cannon[/dt][dd]A gun of some sort[/dd][/dl]',
      :definelist],
    'Definition Term' => [
      /\[dt\](.*?)\[\/dt\]/mi,
      '<dt>\1</dt>',
      'List of definition terms',
      '[dt]definition term[/dt]',
      :defineterm],
    'Definition Definition' => [
      /\[dd\](.*?)\[\/dd\]/mi,
      '<dd>\1</dd>',
      'Definition definitions',
      '[dd]my definition[/dd]',
      :definition],
    'Quote' => [
      /\[quote(:.*)?=(?:&quot;)?(.*?)(?:&quot;)?\](.*?)\[\/quote\1?\]/mi,
      '<fieldset><legend>\2</legend><blockquote>\3</blockquote></fieldset>',
      'Quote with citation',
      '[quote=mike]Now is the time...[/quote]',
      :quote],
    'Quote (Sourceless)' => [
      /\[quote(:.*)?\](.*?)\[\/quote\1?\]/mi,
      '<fieldset><blockquote>\2</blockquote></fieldset>',
      'Quote (sourceclass)',
      '[quote]Now is the time...[/quote]',
      :quote],
    'Link' => [
      /\[url=(?:&quot;)?(.*?)(?:&quot;)?\](.*?)\[\/url\]/mi,
      '<a href="\1">\2</a>',
      'Hyperlink to somewhere else',
      'Maybe try looking on [url=http://google.com]Google[/url]?',
      :link],
    'Link (Implied)' => [
      /\[url\](.*?)\[\/url\]/mi,
      '<a href="\1">\1</a>',
      'Hyperlink (implied)',
      'Maybe try looking on [url]http://google.com[/url]',
      :link],
    'Link (Automatic)' => [
      %r{(\A|\s)(https?://[^\s<\[]+)},
      ' <a href="\2">\2</a>',
      'Hyperlink (automatic)',
      'Maybe try looking on http://www.google.com',
      :link],
    'Link (Automatic without leading http(s))' => [
      /(\A|\s)(www\.[^\s<\[]+)/,
      ' <a href="http://\2">\2</a>',
      'Hyperlink (automatic without leading http(s))',
      'Maybe try looking on www.google.com',
      :link],
    'Image (Resized)' => [
      /\[img(:.+)? size=#{@@quote_matcher}(\d+)x(\d+)\2\](.*?)\[\/img\1?\]/im,
      '<img src="\5" style="width: \3px; height: \4px;" />',
      'Display an image with a set width and height',
      '[img size=96x96]http://www.google.com/intl/en_ALL/images/logo.gif[/img]',
      :image],
    'Image (Alternative)' => [
      /\[img=([^\[\]].*?)\.(#{@@imageformats})\]/im,
      '<img src="\1.\2" alt="" />',
      'Display an image (alternative format)',
      '[img=http://myimage.com/logo.gif]',
      :image],
    'Image (Aligned)' => [
      /\[img(:.+)? align=(left|right)\](.*?)\[\/img\1?\]/im,
      '<img src="\3" alt="" style="float: \2;" />',
      'Display an aligned image',
      '[img align=right]http://catsweekly.com/crazycat.jpg[/img]',
      :image],
    'Image' => [
      /\[img(:.+)?\]([^\[\]].*?)\.(#{@@imageformats})\[\/img\1?\]/im,
      '<img src="\2.\3" alt="" />',
      'Display an image',
      'Check out this crazy cat: [img]http://catsweekly.com/crazycat.jpg[/img]',
      :image],
    'YouTube' => [
      /\[youtube\](.*?)\?v=([\w\d\-]+).*?\[\/youtube\]/im,
      # '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      '<iframe id="ytplayer" type="text/html" width="640" height="390" src="//youtube.com/embed/\2" frameborder="0"></iframe>',
      'Display a video from YouTube.com',
      '[youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]',
      :video],
    'YouTube (Alternative)' => [
      /\[youtube\](.*?)\/v\/([\w\d\-]+)\[\/youtube\]/im,
      # '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      '<iframe id="ytplayer" type="text/html" width="640" height="390" src="//youtube.com/embed/\2" frameborder="0"></iframe>',
      'Display a video from YouTube.com (alternative format)',
      '[youtube]http://youtube.com/watch/v/E4Fbk52Mk1w[/youtube]',
      :video],
    'Vimeo' => [
      /\[vimeo\](.*?)\/(\d+)\[\/vimeo\]/im,
      '<iframe src="//player.vimeo.com/video/\2" width="640" height="390" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>',
      'Display a video from Vimeo',
      '[vimeo]http://www.vimeo.com/3485239[/vimeo]',
      :video],
    'Google Video' => [
      /\[gvideo\](.*?)\?docid=([-]{0,1}\d+).*\[\/gvideo\]/mi,
      '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2" flashvars=""> </embed>',
      'Display a video from Google Video',
      '[gvideo]http://video.google.com/videoplay?docid=-2200109535941088987[/gvideo]',
      :video],
    'Email' => [
      %r{\[email[^:=]?\](((?!\[/email\]).)*)\[/email\]}mi,
      '<a href="mailto:\1">\1</a>',
      'Link to email address',
      '[email]wadus@wadus.com[/email]',
      :email],
    'Email (alternative)' => [
      %r{\[email[:=]([^\]]+)\](((?!\[/email\]).)*)(\[/email\1?\])?}mi,
      '<a href="mailto:\1">\2</a>',
      'Link to email address',
      '[email:wadus@wadus.com]Email Me[/email]',
      :email],
    'Align' => [
      /\[align=(.*?)\](.*?)\[\/align\]/mi,
      "<span class=\"bb-ruby_align_\\1\" style=\"float:\\1;\">\\2</span>",
      'Align this object using float',
      'Here\'s a wrapped image: [align=right][img]image.png[/img][/align]',
      :align],
    'Left' => [
      /\[left(:.+)?\](.*?)\[\/left\1?\]/mi,
      "<div style=\"text-align: left;\">\\2</div>",
      'Aligns contents along the left side',
      '[left]Left-aligned content[/left]',
      :left],
    'Center' => [
      /\[center(:.+)?\](.*?)\[\/center\1?\]/mi,
      "<div style=\"text-align: center;\">\\2</div>",
      'Aligns contents on the center',
      '[center]Centered content[/center]',
      :center],
    'Right' => [
      /\[right(:.+)?\](.*?)\[\/right\1?\]/mi,
      "<div style=\"text-align: right;\">\\2</div>",
      'Aligns contents along the right side',
      '[right]Right-aligned content[/right]',
      :right],
    'Line break' => [
      /\[br\]/mi,
      "<br />",
      'Inserts line break tag',
      'One[br]Two[br]Three lines!',
      :br]
  }

  class << self
    # Convert a string with BBCode markup into its corresponding HTML markup
    #
    # === Basic Usage
    #
    # The first parameter is the string off BBCode markup to be processed
    #
    #   text = "[b]some bold text to markup[/b]"
    #   output = BBRuby.to_html(text)
    #   # output => "<strong>some bold text to markup</strong>"
    #
    # === Custom BBCode translations
    #
    # You can supply your own BBCode markup translations to create your own custom markup
    # or override the default BBRuby translations (parameter is a hash of custom translations).
    #
    # The hash takes the following format: "name" => [regexp, replacement, description, example, enable_symbol]
    #
    #  custom_blockquote = {
    #    'Quote' => [
    #      /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/mi,
    #      '<div class="quote"><p><cite>\2</cite></p><blockquote>\3</blockquote></div>',
    #      'Quote with citation',
    #      '[quote=mike]please quote me[/quote]',
    #      :quote
    #    ]
    #  }
    #
    # === Enable and Disable specific tags
    #
    # BBRuby will allow you to only enable certain BBCode tags, or to explicitly disable certain tags.
    # Pass in either :disable or :enable to set your method, followed by the comma-separated list of tags
    # you wish to disable or enable
    #
    #   BBRuby.to_html(text, {}, true, :enable, :image, :bold, :quote)
    #   BBRuby.to_html(text, {}, true, :disable, :image, :video, :color)
    #
    def to_html(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = process_tags(text, tags_alternative_definition, escape_html, method, *tags)

      # parse spacing
      text.gsub!( /\r\n?/, "\n" )

      # return markup
      text
    end

    # The same as BBRuby.to_html except the output is passed through simple_format first
    #
    # Returns text transformed into HTML using simple formatting rules. Two or more consecutive newlines(\n\n)
    # are considered as a paragraph and wrapped in <p> tags. One newline (\n) is considered as a linebreak and
    # a <br /> tag is appended. This method does not remove the newlines from the text.
    #
    def to_html_with_formatting(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = process_tags(text, tags_alternative_definition, escape_html, method, *tags)

      # parse spacing
      simple_format( text )
    end

    # Returns the list of tags processed by BBRuby in a Hash object
    def tag_list
      @@tags
    end

    # Checks if text contains any bb tag
    def any_bb_tags?(text)
      tag_list.map{|k,v| v[0]}.any?{|regex| text.match(regex) }
    end

    private

    def process_tags(text, tags_alternative_definition={}, escape_html=true, method=:disable, *tags)
      text = text.dup

      # escape "<, >, &" and quotes to remove any html
      if escape_html
        text.gsub!( '&', '&amp;' )
        text.gsub!( '<', '&lt;' )
        text.gsub!( '>', '&gt;' )
        text.gsub!( '"', '&quot;' )
        text.gsub!( "'", '&apos;' )
      end

      tags_definition = @@tags.merge(tags_alternative_definition)

      # parse bbcode tags
      case method
      when :enable
        tags_definition.each_value do |t|
          gsub!(text, t[0], t[1]) if tags.include?( t[4] )
        end
      when :disable
        # this works nicely because the default is disable and the default set of tags is [] (so none disabled) :)
        tags_definition.each_value do |t|
          gsub!(text, t[0], t[1]) unless tags.include?( t[4] )
        end
      end

      text
    end

    def gsub!(text, pattern, replacement)
      if replacement.class == String
        # just replace if replacement is String
        while text.gsub!( pattern, replacement ); end
      else
        # call replacement
        # It may be Proc or lambda with one argument
        # Argument is MatchData. See 'Bold' tag name for example.
        while text.gsub!( pattern ){ replacement.call($~) }; end
      end
    end

    # extracted from Rails ActionPack
    def simple_format( text )
      start_tag = '<p>'
      text = text.to_s.dup
      text.gsub!(/\r\n?/, "\n")                     # \r\n and \r => \n
      text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  => paragraph
      text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')  # 1 newline   => br
      text.insert 0, start_tag
      text << '</p>'
    end
  end # class << self

end

class String
  # Convert a string with BBCode markup into its corresponding HTML markup
  #
  # === Basic Usage
  #
  #   text = "[b]some bold text to markup[/b]"
  #   output = text.bbcode_to_html
  #   # output => "<strong>some bold text to markup</strong>"
  #
  # === Custom BBCode translations
  #
  # You can supply your own BBCode markup translations to create your own custom markup
  # or override the default BBRuby translations (parameter is a hash of custom translations).
  #
  # The hash takes the following format: "name" => [regexp, replacement, description, example, enable_symbol]
  #
  #  custom_blockquote = {
  #    'Quote' => [
  #      /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/mi,
  #      '<div class="quote"><p><cite>\2</cite></p><blockquote>\3</blockquote></div>',
  #      'Quote with citation',
  #      '[quote=mike]please quote me[/quote]',
  #      :quote
  #    ]
  #  }
  #
  #  output = text.bbcode_to_html(custom_blockquote)
  #
  # === Enable and Disable specific tags
  #
  # BBRuby will allow you to only enable certain BBCode tags, or to explicitly disable certain tags.
  # Pass in either :disable or :enable to set your method, followed by the comma-separated list of tags
  # you wish to disable or enable
  #
  #   output = text.bbcode_to_html({}, true, :enable, :image, :bold, :quote)
  #   output = text.bbcode_to_html({}, true, :disable, :image, :video, :color)
  #
  # === HTML auto-escaping
  #
  # By default, BBRuby will auto-escape HTML.  You can prevent this by passing in false as the second
  # parameter
  #
  #   output = text.bbcode_to_html({}, false)
  #
  def bbcode_to_html(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    BBRuby.to_html(self, tags_alternative_definition, escape_html, method, *tags)
  end

  # Replace the string contents with the HTML-converted markup
  def bbcode_to_html!(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    self.replace(BBRuby.to_html(self, tags_alternative_definition, escape_html, method, *tags))
  end

  def bbcode_to_html_with_formatting(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    BBRuby.to_html_with_formatting(self, tags_alternative_definition, escape_html, method, *tags)
  end

  # Replace the string contents with the HTML-converted markup using simple_format
  def bbcode_to_html_with_formatting!(tags_alternative_definition = {}, escape_html=true, method=:disable, *tags)
    self.replace(BBRuby.to_html_with_formatting(self, tags_alternative_definition, escape_html, method, *tags))
  end

  def bbcode_formatted?
    BBRuby.any_bb_tags?(self)
  end
end
