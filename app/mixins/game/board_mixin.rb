module Game::BoardMixin

  # Calls the input block once for each coordindate on the board. For example
  #
  #   $ Game.each_board_position do |coord|
  #       puts coord.to_s
  #     end
  #   > [0, 0][0, 1][0, 2] ... [0, 5][1, 0][1, 1][1, 2] ... [5, 5]
  #
  # @param [block] passes an array of coords
  def each_board_position(&block)
    (0...Game::NUM_COLUMNS).each do |col|
      (0...Game::NUM_ROWS).each do |row|
        yield([col, row])
      end
    end
  end

  ## direction helpers ##


  # gets the coordinates n away in the diagonal direction from the coordinates
  # we started from
  #
  # @param [Array] origin_coord The coordinates to start from
  # @param [Integer] n The distance away from the origin_coord
  # @return [Array] The coordinates in the diagonal direction, n away from the
  #   origin coords
  def diagonal(coords, i)
    [coords[0]+i, coords[1]+i]
  end

  # gets the coordinates n away in the vertical direction from the coordinates
  # we started from
  #
  # @param [Array] origin_coord The coordinates to start from
  # @param [Integer] n The distance away from the origin_coord
  # @return [Array] The coordinates in the diagonal direction, n away from the
  #   origin coords
  def vertical(coords, i)
    [coords[0], coords[1]+i]
  end

  # gets the coordinates n away in the horizontal direction from the coordinates
  # we started from
  #
  # @param [Array] origin_coord The coordinates to start from
  # @param [Integer] n The distance away from the origin_coord
  # @return [Array] The coordinates in the diagonal direction, n away from the
  #   origin coords
  def horizontal(coords, i)
    [coords[0]+i, coords[1]]
  end

  # Prints the board in a human-readable format
  #
  # @return [String] Human-readable board
  def pretty_print
    pretty_board = ''
    (0...Game::NUM_ROWS).map(&:to_i).reverse.each do |row|
      pretty_board << '| '
      (0...Game::NUM_COLUMNS).each do |column|
        if self.board[column].length <= row
          pretty_board << '  '
        else
          pretty_board << "#{self.board[column][row][0]} "
        end

      end
      pretty_board << "|\n"
    end
    pretty_board << '|'
    (0..(Game::NUM_COLUMNS*2)).each{pretty_board << '-'}
    pretty_board << '|'
    pretty_board
  end

end
