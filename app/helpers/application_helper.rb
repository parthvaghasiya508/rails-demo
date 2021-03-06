module ApplicationHelper
  def pod_name
    AppConfig.settings.pod_name
  end

  def pod_version
    AppConfig.version.number
  end

  def changelog_url
    return AppConfig.settings.changelog_url.get if AppConfig.settings.changelog_url.present?

    url = "https://github.com/diaspora/diaspora/blob/master/Changelog.md"
    url.sub!('/master/', "/#{AppConfig.git_revision}/") if AppConfig.git_revision.present?
    url
  end

  def source_url
    AppConfig.settings.source_url.presence || "#{root_path.chomp('/')}/source.tar.gz"
  end

  def timeago(time, options={})
    timeago_tag(time, options.merge(:class => 'timeago', :title => time.iso8601, :force => true)) if time
  end

  def bookmarklet_code(height=400, width=620)
    "javascript:" +
      BookmarkletRenderer.body +
      "bookmarklet('#{bookmarklet_url}', #{width}, #{height});"
  end

  def all_services_connected?
    current_user.services.size == AppConfig.configured_services.size
  end

  def popover_with_close_html(without_close_html)
    without_close_html + link_to('&times;'.html_safe, "#", :class => 'close')
  end

  # Require jQuery from CDN if possible, falling back to vendored copy, and require
  # vendored jquery_ujs
  def jquery_include_tag
    buf = []
    if AppConfig.privacy.jquery_cdn?
      version = Jquery::Rails::JQUERY_2_VERSION
      buf << [javascript_include_tag("//code.jquery.com/jquery-#{version}.min.js")]
      buf << [nonced_javascript_tag("!window.jQuery && document.write(unescape('#{j javascript_include_tag('jquery2')}'));")]
    else
      buf << [javascript_include_tag("jquery2")]
    end
    buf << [javascript_include_tag("jquery_ujs")]
    buf << [nonced_javascript_tag("jQuery.ajaxSetup({'cache': false});")]
    buf << [nonced_javascript_tag("$.fx.off = true;")] if Rails.env.test?
    buf.join("\n").html_safe
  end
end
