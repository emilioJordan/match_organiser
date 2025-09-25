require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  def setup
    @organizer = User.create!(
      name: "Test Organizer", 
      email: "organizer@test.com", 
      password: "password", 
      role: "organizer"
    )
    
    @player = User.create!(
      name: "Test Player", 
      email: "player@test.com", 
      password: "password", 
      role: "player"
    )
  end

  test "organizer can create and manage matches" do
    # Organizer meldet sich an
    post login_path, params: { email: @organizer.email, password: "password" }
    assert_redirected_to root_path
    
    # Organizer erstellt Match
    get new_match_path
    assert_response :success
    
    assert_difference 'Match.count', 1 do
      post matches_path, params: {
        match: {
          title: "Test Match",
          date: Date.tomorrow,
          time: "19:00",
          location: "Test Location",
          description: "Test Description"
        }
      }
    end
    
    match = Match.last
    assert_equal @organizer, match.created_by
    assert_redirected_to match_path(match)
  end

  test "player can participate in matches" do
    # Organizer erstellt Match
    match = Match.create!(
      title: "Test Match",
      date: Date.tomorrow,
      time: "19:00",
      location: "Test Location",
      created_by: @organizer
    )
    
    # Player meldet sich an
    post login_path, params: { email: @player.email, password: "password" }
    assert_redirected_to root_path
    
    # Player nimmt am Match teil
    assert_difference 'Participation.count', 1 do
      post match_participations_path(match), params: { status: "confirmed" }
    end
    
    participation = Participation.last
    assert_equal @player, participation.user
    assert_equal match, participation.match
    assert_equal "confirmed", participation.status
  end

  test "unauthorized access is prevented" do
    # Player versucht Match zu erstellen (ohne Berechtigung)
    post login_path, params: { email: @player.email, password: "password" }
    
    get new_match_path
    assert_redirected_to matches_path
    assert_not_empty flash[:alert]
  end
end