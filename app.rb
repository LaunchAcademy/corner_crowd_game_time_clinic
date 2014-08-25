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

# Finds a team hash with a given value for name key in the array of teams
def find_team(teams, name)
  teams.find do |team|
    team[:name] == name
  end
end

# Creates a new team hash with 0 wins and 0 losses
def build_team(teams, name)
  team = { name: name, wins: 0, losses: 0 }
  teams << team
  team
end

def find_or_build_team(teams, name)
  # Try to find the team with the matching name.
  # Build a new team if one is not found.
  find_team(teams, name) || build_team(teams, name)
end

def leaderboard
  teams = []

  scores.each do |score|
    home_team = find_or_build_team(teams, score[:home_team])
    away_team = find_or_build_team(teams, score[:away_team])

    if score[:home_score] > score[:away_score]
      home_team[:wins] += 1
      away_team[:losses] += 1
    else
      away_team[:wins] += 1
      home_team[:losses] += 1
    end
  end

  teams
end

get '/leaderboard' do
  teams = leaderboard

  # Sort the teams first by most wins, then by least losses
  sorted_teams = teams.sort_by do |team|
    [-team[:wins], team[:losses]]
  end

  erb :leaderboard, locals: { teams: sorted_teams }
end
