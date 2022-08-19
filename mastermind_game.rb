CODE_NUMBERS = [1, 2, 3, 4, 5, 6]

class Display
  attr_reader :game_over, :gameboard

  def initialize
    @lives = 8
    # gameboard keeps track of number guesses of codebreaker
    @gameboard = []
    # guessboard keeps track of whether each position is correct or not
    @guessboard = []
    # bool to hold whether game is still ongoing
    @game_over = false
    # varible to hold current iteration of guess from codebreaker
    @current_guess = []
  end

  def set_secret_code(code)
    @secret_code = code
    print @secret_code
  end

  def set_current_guess(guess)
    @current_guess = guess
    @gameboard.append(@current_guess)
  end

  def lives_reducer
    @lives -= 1
  end

  # QND game is over check, will prop need to update soon
  def game_is_over?
    if @lives.zero? 
      @game_over = true
    end
  end

=begin
  def guess_checker
    correct_guess_array = ['C', 'C', 'C', 'C']
    cg_array_placeholder = 0
    i = 0
    until i == (correct_guess_array.length) -1
      if @current_guess[i] == @secret_code[i]
        correct_guess_array[cg_array_placeholder] = 'A'
        cg_array_placeholder += 1
      end
      i += 1
    end

  end
=end

  def perfect_match_checker()
    correct_guess_array = ['C', 'C', 'C', 'C']
    i = 0
    cg_place = 0
    until i == correct_guess_array.length
      #puts "It is now checing index of #{i}"
      if @current_guess[i] == @secret_code[i]
        #puts "a match has been found"
        correct_guess_array[cg_place] = 'A'
        cg_place += 1
      end
      i += 1
    end
    return correct_guess_array
  end

  def alright_match_checker(c_g_array)
    perfect_guesses = c_g_array.count('A')
    puts perfect_guesses
    correct_elements = (@current_guess & @secret_code).count
    puts correct_elements
    alright_elements = correct_elements - perfect_guesses
    puts alright_elements
    if alright_elements > 0
      i = 0
      until i == alright_elements
        puts "alrtight assigner is running"
        c_g_array[perfect_guesses + i] = 'B'
        i += 1
      end
    end
    print c_g_array
    return c_g_array
  end

    



end

class Computer
  attr_reader :random_code

  # If CPU is code setter, sets up a random combination as the code
  def cpu_code_setter
    @random_code = []
    4.times do 
      temp = CODE_NUMBERS.sample
      @random_code.append(temp)
    end
    return @random_code
  end
end

class Human
  def initialize(name)
    @name = name
  end

  # If Human is code setter, allows the user to set the code while also validating correct input
  def human_code_setter
    @human_code = []
    puts "Hello #{@name}, you will know be prompted to pick 4 numbers to be the code the computer will try to break "
    while @human_code.length != 4
      print 'type in a number from 1 to 6: '
      num = gets.chomp.to_i
      num = loop_validator(num)
      @human_code.append(num)
    end
    print @human_code
    return @human_code
  end

  def human_code_guessor
    @human_code_guess = []
    print "\nwhat is your guess for the number in the first spot? : "
    temp = gets.chomp.to_i
    temp = loop_validator(temp)
    @human_code_guess.append(temp)
    print "\nwhat is your guess for the number in the second spot? : "
    temp = gets.chomp.to_i
    temp = loop_validator(temp)
    @human_code_guess.append(temp)
    print "\nwhat is your guess for the number in the third spot? : "
    temp = gets.chomp.to_i
    temp = loop_validator(temp)
    @human_code_guess.append(temp)
    print "\nwhat is your guess for the number in the fourth and final spot? : "
    temp = gets.chomp.to_i
    temp = loop_validator(temp)
    @human_code_guess.append(temp)
    return @human_code_guess
  end

  # little function to make data input validation easier in class
  def loop_validator(number)
    if CODE_NUMBERS.include?(number)
      return number
    else
        while !(CODE_NUMBERS.include?(number))
          print '\nRUH ROE, that input was not in or between 1-6, please type in an interger in that range here: '
          number = gets.chomp.to_i
        end
        return number
    end
  end
end

al = Computer.new
john = Human.new("John")
game = Display.new


sc = al.cpu_code_setter
game.set_secret_code(sc)

until game.game_over == true
  cg = john.human_code_guessor
  game.set_current_guess(cg)
  temp = game.perfect_match_checker
  game.alright_match_checker(temp)
  game.lives_reducer
  game.game_is_over?
end

print game.gameboard
