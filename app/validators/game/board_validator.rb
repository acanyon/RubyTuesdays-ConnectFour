class Game::BoardValidator < ActiveModel::Validator
  def validate(record)
    board = record.board
    max_col, max_row = options[:dimensions]

    if board.is_a?(Array)
      unless board.length <= max_col
        record.errors[:board] << "The max board width is #{max_col},"+
            " however the board is #{board.length}."
      end

      if board.all?{|col| col.is_a?(Array)}
        if board.all?{|col| col.length <=  max_row}
          unless all_cells_valid? board
            record.errors[:board] <<
                "Each element must be either 'red' or 'blue'"
          end

        else
          record.errors[:board] <<
              "Each column must not exceed a height of #{max_row}."
        end
      else
        record.errors[:board] << "Each column must be an Array."
      end

    else
      record.errors[:board] << "Board was expected to be an #{Array},"+
          " but instead is a #{board.class}."
    end
  end

  private

  def all_cells_valid?(board)
    board.all? do |column|
      column.all? do |cell|
        cell.is_a?(String) && cell.in?(%(red blue))
      end
    end
  end
end