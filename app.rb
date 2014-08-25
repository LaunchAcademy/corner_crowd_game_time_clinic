require 'sinatra'
require 'sinatra/reloader'

require 'pry'

def scores
  [
    {
      home_team: "Patriots",
      away_team: "Broncos",
      home_score: 7,
      away_score: 3
    },
    {
      home_team: "Broncos",
      away_team: "Colts",
      home_score: 3,
      away_score: 0
    },
    {
      home_team: "Patriots",
      away_team: "Colts",
      home_score: 11,
      away_score: 7
    },
    {
      home_team: "Steelers",
      away_team: "Patriots",
      home_score: 7,
      away_score: 21
    }
  ]
end

def find_team(teams, name)
  teams.find do |team|
    team[:name] == name
  end
end

get '/leaderboard' do
  @teams = [
    { name: 'Steelers', wins: 0, losses: 0 },
    { name: 'Patriots', wins: 0, losses: 0 },
    { name: 'Colts', wins: 0, losses: 0 },
    { name: 'Broncos', wins: 0, losses: 0 }
  ]

  scores.each do |score|
    # find or create hash for home team
    home_team = find_team(@teams, score[:home_team])

    # find or create hash for away team
    away_team = find_team(@teams, score[:away_team])

    # figure out who won, increment their value for wins
    # figure out who list, increment their value for losses
    if score[:home_score] > score[:away_score]
      home_team[:wins] += 1
      away_team[:losses] += 1
    else
      away_team[:wins] += 1
      home_team[:losses] += 1
    end
  end

  erb :leaderboard
end
