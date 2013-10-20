class Event < ActiveRecord::Base
  has_many :votes

  def aggregate_votes
    chart = initialize_chart(self.start_time, self.end_time)

    votes_hash = group_votes_by_timestamp(self.start_time, self.votes)

    layer_votes_on_chart(votes_hash, chart)

    # cleanup_titles(chart)

    model = {
        title: self.title,
        series: chart
    }
    model
  end

  def layer_votes_on_chart(votes_hash, chart)
    # Iterate over each vote type and update the chart accordingly
    votes_hash.each do |vote_type, time_bucket|
      section = detect_vote_section(vote_type, chart)
      time_bucket.each do |second, count|
        section[:points][second][:y] = count
      end
    end
  end

  def detect_vote_section(vote_type, chart)
    chart.each do |section|
      return section if section[:title] == vote_type
    end
  end

  def initialize_chart(start_time, end_time)
    series = []
    VoteType::TYPES.each do |vote_type|
      points = []
      #ActiveSupport::TimeWithZone
      (start_time...(end_time+1.second)).to_a.each_with_index do |i, idx|
        point = {x: idx, y: 0}
        points << point
      end

      series << {
          title:  vote_type,
          points: points
      }
    end
    series
  end

  # Groups the votes into their corresponding timestamp buckets to display frequencies
  def group_votes_by_timestamp(start_time, votes)
    hash = {}

    VoteType::TYPES.each do |vote_type|
      hash[vote_type] = {}
    end

    # Iterate through all votes and group the frequencies in the created_at
    votes.each do |vote|
      seconds_since_start = (vote.created_at - start_time).to_i
      vote_key = hash[vote.vote_type][seconds_since_start]
      if vote_key.present?
        hash[vote.vote_type][seconds_since_start] += 1
      else
        hash[vote.vote_type][seconds_since_start] = 1
      end
    end

    hash
  end

  #def aggregate_votes_old
  #  votes = self.votes
  #
  #  secondsInYear = 1
  #
  #  model = {
  #      title: 'Kanari',
  #      series: [{
  #                   title: 'Thumbs Up',
  #                   points: [
  #                       {x: secondsInYear * 2, y: 9.5},
  #                       {x: secondsInYear * 3, y: 0},
  #                       {x: secondsInYear * 4, y: 0},
  #                       {x: secondsInYear * 6, y: 25.2},
  #                       {x: secondsInYear * 7, y: 26.5},
  #                       {x: secondsInYear * 8, y: 23.3},
  #                       {x: secondsInYear * 9, y: 18.3},
  #                       {x: secondsInYear * 10, y: 13.9},
  #                       {x: secondsInYear * 11, y: 9.6}
  #                   ]
  #               },
  #               {
  #                   title: 'Thumbs Down',
  #                   points: [
  #                       {x: secondsInYear * 0, y: 9},
  #                       {x: secondsInYear * 2, y: 5.7},
  #                       {x: secondsInYear * 4, y: 17.0},
  #                       {x: secondsInYear * 5, y: 22.0},
  #                       {x: secondsInYear * 6, y: 24.8},
  #                       {x: secondsInYear * 7, y: 24.1},
  #                       {x: secondsInYear * 8, y: 20.1},
  #                       {x: secondsInYear * 9, y: 14.1},
  #                       {x: secondsInYear * 10, y: 8.6},
  #                       {x: secondsInYear * 11, y: 2.5}
  #                   ]
  #               }, {
  #                   title: 'Confused',
  #                   points: [
  #                       {x: secondsInYear * 0, y: 5},
  #                       {x: secondsInYear * 2, y: 5.7},
  #                       {x: secondsInYear * 3, y: 11.3},
  #                       {x: secondsInYear * 5, y: 22.0},
  #                       {x: secondsInYear * 6, y: 24.8},
  #                       {x: secondsInYear * 9, y: 14.1},
  #                       {x: secondsInYear * 10, y: 8.6},
  #                   ]
  #               }, {
  #                   title: 'Love',
  #                   points: [
  #                       {x: secondsInYear * 0, y: 0.0},
  #                       {x: secondsInYear * 3, y: 11.3},
  #                       {x: secondsInYear * 4, y: 17.0},
  #                       {x: secondsInYear * 5, y: 22.0},
  #                       {x: secondsInYear * 8, y: 20.1},
  #                       {x: secondsInYear * 9, y: 14.1},
  #                       {x: secondsInYear * 10, y: 8.6},
  #                       {x: secondsInYear * 11, y: 2.5}
  #                   ]
  #               }]
  #  }
  #
  #  #votes.each do |vote|
  #  #
  #  #end
  #
  #  model
  #end
end
