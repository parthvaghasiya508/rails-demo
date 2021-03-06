module AspectGlobalHelper
  def aspect_options_for_select(aspects)
    options = {}
    aspects.each do |aspect|
      options[aspect.to_s] = aspect.id
    end
    options
  end

  def publisher_aspects_for(stream=nil)
    if stream
      aspects = stream.aspects
      aspect = stream.aspect
      aspect_ids = stream.aspect_ids
    elsif current_user
      aspects = current_user.post_default_aspects
      aspect = aspects.first
      aspect_ids = current_user.aspect_ids
    else
      return {}
    end
    {selected_aspects: aspects, aspect: aspect, aspect_ids: aspect_ids}
  end

  def public_selected?(selected_aspects)
    "public" == selected_aspects.try(:first)
  end

  def all_aspects_selected?(aspects, selected_aspects)
    !aspects.empty? && aspects.size == selected_aspects.size && !public_selected?(selected_aspects)
  end

  def aspect_selected?(aspect, aspects, selected_aspects)
    selected_aspects.include?(aspect) && !all_aspects_selected?(aspects, selected_aspects)
  end
end
