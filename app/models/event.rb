class Event < ActiveRecord::Base
  has_many :votes

  def aggregate_votes
    votes = self.votes

    secondsInYear = 1

    model = {
        title: 'Kanari',
        series: [{
                     title: 'Thumbs Up',
                     points: [
                         {x: secondsInYear * 2, y: 9.5},
                         {x: secondsInYear * 3, y: 0},
                         {x: secondsInYear * 4, y: 0},
                         {x: secondsInYear * 6, y: 25.2},
                         {x: secondsInYear * 7, y: 26.5},
                         {x: secondsInYear * 8, y: 23.3},
                         {x: secondsInYear * 9, y: 18.3},
                         {x: secondsInYear * 10, y: 13.9},
                         {x: secondsInYear * 11, y: 9.6}
                     ]
                 },
                 {
                     title: 'Thumbs Down',
                     points: [
                         {x: secondsInYear * 0, y: 9},
                         {x: secondsInYear * 2, y: 5.7},
                         {x: secondsInYear * 4, y: 17.0},
                         {x: secondsInYear * 5, y: 22.0},
                         {x: secondsInYear * 6, y: 24.8},
                         {x: secondsInYear * 7, y: 24.1},
                         {x: secondsInYear * 8, y: 20.1},
                         {x: secondsInYear * 9, y: 14.1},
                         {x: secondsInYear * 10, y: 8.6},
                         {x: secondsInYear * 11, y: 2.5}
                     ]
                 }, {
                     title: 'Confused',
                     points: [
                         {x: secondsInYear * 0, y: 5},
                         {x: secondsInYear * 2, y: 5.7},
                         {x: secondsInYear * 3, y: 11.3},
                         {x: secondsInYear * 5, y: 22.0},
                         {x: secondsInYear * 6, y: 24.8},
                         {x: secondsInYear * 9, y: 14.1},
                         {x: secondsInYear * 10, y: 8.6},
                     ]
                 }, {
                     title: 'Love',
                     points: [
                         {x: secondsInYear * 0, y: 0.0},
                         {x: secondsInYear * 3, y: 11.3},
                         {x: secondsInYear * 4, y: 17.0},
                         {x: secondsInYear * 5, y: 22.0},
                         {x: secondsInYear * 8, y: 20.1},
                         {x: secondsInYear * 9, y: 14.1},
                         {x: secondsInYear * 10, y: 8.6},
                         {x: secondsInYear * 11, y: 2.5}
                     ]
                 }]
    }

    #votes.each do |vote|
    #
    #end

    model
  end
end
