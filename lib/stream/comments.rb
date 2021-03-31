class Stream::Comments < Stream::Base
  def link(opts={})
    Rails.application.routes.url_helpers.comment_stream_path(opts)
  end

  def title
    I18n.translate("streams.comment_stream.title")
  end

  # @return [ActiveRecord::Association<Post>] AR association of posts
  def posts
    @posts ||= EvilQuery::CommentedPosts.new(user).posts
  end
end
