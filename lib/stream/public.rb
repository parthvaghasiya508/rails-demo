class Stream::Public < Stream::Base
  def link(opts={})
    Rails.application.routes.url_helpers.public_stream_path(opts)
  end

  def title
    I18n.translate("streams.public.title")
  end

  # @return [ActiveRecord::Association<Post>] AR association of posts
  def posts
    @posts ||= Post.all_public
  end

  def can_comment?(post)
    post.author.local?
  end

  # Override base class method
  def aspects
    ["public"]
  end
end
