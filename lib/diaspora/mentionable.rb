module Diaspora::Mentionable

  # regex for finding mention markup in plain text
  # ex.
  #   "message @{User Name; user@pod.net} text"
  #   will yield "User Name" and "user@pod.net"
  REGEX = /(@\{(.+?; [^\}]+)\})/

  # class attribute that will be added to all mention html links
  PERSON_HREF_CLASS = "mention hovercardable"

  def self.mention_attrs(mention_str)
    mention = mention_str.match(REGEX)[2]
    del_pos = mention.rindex(/;/)

    name = mention[0..(del_pos - 1)].strip
    handle = mention[(del_pos + 1)..-1].strip

    [name, handle]
  end

  # takes a message text and returns the text with mentions in (html escaped)
  # plain text or formatted with html markup linking to user profiles.
  # default is html output.
  #
  # @param [String] text containing mentions
  # @param [Array<Person>] list of mentioned people
  # @param [Hash] formatting options
  # @return [String] formatted message
  def self.format(msg_text, people, opts={})
    people = [*people]

    msg_text.to_s.gsub(REGEX) {|match_str|
      name, handle = mention_attrs(match_str)
      person = people.find {|p| p.diaspora_handle == handle }

      ERB::Util.h(MentionsInternal.mention_link(person, name, opts))
    }
  end

  # takes a message text and returns an array of people constructed from the
  # contained mentions
  #
  # @param [String] text containing mentions
  # @return [Array<Person>] array of people
  def self.people_from_string(msg_text)
    identifiers = msg_text.to_s.scan(REGEX).map do |match_str|
      _, identifier = mention_attrs(match_str.first)
      identifier if Validation::Rule::DiasporaId.new.valid_value?(identifier)
    end

    identifiers.compact.uniq.map {|identifier| find_or_fetch_person_by_identifier(identifier) }.compact
  end

  # takes a message text and converts mentions for people that are not in the
  # given array to simple markdown links, leaving only mentions for people who
  # will actually be able to receive notifications for being mentioned.
  #
  # @param [String] message text
  # @param [Array] allowed_people ids of people that are allowed to stay
  # @return [String] message text with filtered mentions
  def self.filter_people(msg_text, allowed_people)
    mentioned_ppl = people_from_string(msg_text)

    msg_text.to_s.gsub(REGEX) {|match_str|
      name, handle = mention_attrs(match_str)
      person = mentioned_ppl.find {|p| p.diaspora_handle == handle }
      mention = MentionsInternal.profile_link(person, name) unless allowed_people.include?(person.id)

      mention || match_str
    }
  end

  private

  private_class_method def self.find_or_fetch_person_by_identifier(identifier)
    Person.find_or_fetch_by_identifier(identifier)
  rescue DiasporaFederation::Discovery::DiscoveryError
    nil
  end

  # inline module for namespacing
  module MentionsInternal
    extend ::PeopleHelper

    # output a formatted mention link as defined by the given arguments.
    # if the display name is blank, falls back to the person's name.
    # @see Diaspora::Mentions#format
    #
    # @param [Person] AR Person
    # @param [String] display name
    # @param [Hash] formatting options
    def self.mention_link(person, display_name, opts)
      return display_name unless person.present?

      if opts[:plain_text]
        display_name.presence || person.name
      else
        person_link(person, class: PERSON_HREF_CLASS, display_name: display_name)
      end
    end

    # output a markdown formatted link to the given person with the display name as the link text.
    # if the display name is blank, falls back to the person's name.
    #
    # @param [Person] AR Person
    # @param [String] display name
    # @return [String] markdown person link
    def self.profile_link(person, display_name)
      return display_name unless person.present?

      "[#{display_name.presence || person.name}](#{local_or_remote_person_path(person)})"
    end
  end

end
