# frozen_string_literal: true

require 'yaml'
require_relative 'display_text'
require_relative 'game_logic'

new = Game.new
new.load_game
