class StatisticsPresenter < NodeInfoPresenter
  def initialize
    super("1.0")
  end

  def as_json(_options={})
    base_data.merge(user_counts)
             .merge(post_counts)
             .merge(comment_counts)
  end

  def base_data
    {
      "name"               => name,
      "network"            => "Diaspora",
      "version"            => version,
      "registrations_open" => open_registrations?,
      "services"           => available_services
    }
  end

  def user_counts
    return {} unless expose_user_counts?
    {
      "total_users"           => total_users,
      "active_users_monthly"  => monthly_users,
      "active_users_halfyear" => halfyear_users
    }
  end

  def post_counts
    return {} unless expose_posts_counts?
    {
      "local_posts" => local_posts
    }
  end

  def comment_counts
    return {} unless expose_comment_counts?
    {
      "local_comments" => local_comments
    }
  end
end
