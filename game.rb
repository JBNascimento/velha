class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @com = "#{red('X')}" # the computer's marker
    @hum =  "#{green('O')}" # the user's marker
  end

  # colors
  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end
    
  def red(text); colorize(text, "\e[31m"); end
  def green(text); colorize(text, "\e[32m"); end
  def yellow(text); colorize(text, "\e[33m"); end
    

  def start_game
    # start by printing the board
    puts "\n"
    puts "--------------------------------------------"
    puts "YOU WON'T BEAT ME. BUT, DO YOU WANT TRY? ;)" 
    puts "--------------------------------------------"
    puts "\n"   
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n---+---+---\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n---+---+---\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts "\n" 
    puts "Choose your move! Enter a number between 0 and 8:"

    # loop through until the game was won or tied
    until game_is_over(@board) || tie(@board)
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        eval_board
      end
      puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n---+---+---\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n---+---+---\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    end    
     puts "\n" 
     puts "---------- GAME OVER ----------"     
     check_result(@board)
     puts "\n"
  end

  def get_human_spot
    spot = nil
    until spot
      spot_temp = gets.chomp
      # Valid Input        
      valid =*("0".."8")
      
      while !valid.include? spot_temp
        puts "#{red('Invalid Character!')} Enter a number between 0 and 8:"
        spot_temp = gets.chomp       
      end        
             
      spot = spot_temp.to_i
      puts "You chose: #{spot}"
      if @board[spot] != "#{red('X')}" && @board[spot] != "#{green('O')}"
        @board[spot] = @hum
      else
        spot = nil
      end      
    end
  end
     
  def eval_board
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @com
      else
        spot = get_best_move(@board, @com)
        if @board[spot] != "#{red('X')}" && @board[spot] != "#{green('O')}"
          @board[spot] = @com
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    board.each do |s|
      if s != "#{red('X')}" && s != "#{green('O')}"
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  def game_is_over(b)

    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def check_result(b)
    if
      [b[0], b[1], b[2]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[3], b[4], b[5]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[6], b[7], b[8]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[0], b[3], b[6]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[1], b[4], b[7]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[2], b[5], b[8]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[0], b[4], b[8]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"] ||
      [b[2], b[4], b[6]] == ["#{red('X')}", "#{red('X')}","#{red('X')}"]

        puts red(loser_sentences.sample)
    elsif  
      [b[0], b[1], b[2]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[3], b[4], b[5]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[6], b[7], b[8]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[0], b[3], b[6]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[1], b[4], b[7]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[2], b[5], b[8]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[0], b[4], b[8]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"] ||
      [b[2], b[4], b[6]] == ["#{green('O')}", "#{green('O')}","#{green('O')}"]

      puts green(winner_sentences.sample)
    else       
      puts yellow(tie_sentences.sample)
    end
  end

  def loser_sentences
    messages = ["YOU LOSE! Easy peasy...", "YOU LOSE! Were you even trying?", "YOU LOSE! You have a lot to learn, human"]
  end 

  def winner_sentences 
    messages = ["YOU WON! Are you sure you are human?", "YOU WON! Were you using cheats?", "YOU WON! Humm... We have a Jedi here"]
  end 

  def tie_sentences
    messages = ["TIE! I see that you studied a little", "TIE! I see someone is leveling up here", "TIE! I was not on my best days..."]
  end 
  
  def tie(b)
    b.all? { |s| s == "#{red('X')}" || s == "#{green('O')}" }    
  end

end

game = Game.new
game.start_game
