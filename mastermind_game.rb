

CODE_NUMBERS = [1, 2, 3, 4, 5, 6]

class Display
  attr_reader :game_over, :gameboard, :game_won, :secret_code

  def initialize
    @lives = 7
    # gameboard keeps track of number guesses of codebreaker
    @gameboard = []
    # guessboard keeps track of whether each position is correct or not
    @guessboard = []
    # bool to hold whether game is still ongoing
    @game_over = false
    # varible to hold current iteration of guess from codebreaker
    @current_guess = []
    # Variable to hold bool when game is won
    @game_won = false
  end

  def set_secret_code(code)
    @secret_code = code
    #print @secret_code
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

  def guess_checker
    cg_array = perfect_match_checker
    #print "the cg array is #{cg_array}"
    ag_elements = alright_match_checker
    #puts
    #print "The number of alright elements is #{ag_elements}"
    cg_elements = cg_array.count('A')
    #puts 
    #print "The number of correct guess elements is #{cg_elements}"
    elements_left_over = [ag_elements - cg_elements, 0].max
    #print "\nThe number of elements left over is #{elements_left_over}"
    if elements_left_over > 0
      j = 0
      until elements_left_over == 0
        cg_array[cg_elements + j] = 'B'
        elements_left_over -= 1
        j += 1
      end
    end
    @guessboard.append(cg_array)
    puts 
    #print "The guess array is #{cg_array} \n"
    cg_array
  end

  def perfect_match_checker()
    correct_guess_array = ['C', 'C', 'C', 'C']
    i = 0
    cg_place = 0
    until i == correct_guess_array.length
      #puts "It is now checing index of #{i}"
      if @current_guess[i] == @secret_code[i]
        #puts "#{@current_guess[i]} matches #{@secret_code}"
        correct_guess_array[cg_place] = 'A'
        cg_place += 1
      end
      i += 1
    end
    correct_guess_array
  end

  def alright_match_checker
    #puts "new iteration of checker is running"
    #print @secret_code
    #puts
    number_of_alright_guesses = 0
    secret_code_copy = secret_code_cloner
    @current_guess.each do |ele|
    #  puts "we are now checking #{ele}"
      i = 0
      while i < @secret_code.count
        if ele == secret_code_copy[i]
          number_of_alright_guesses += 1
     #     puts "we have matching elements of guess #{ele} and secret code of #{@secret_code[i]} with an index of #{i}"
          secret_code_copy.delete_at(i)
     #     print "\n we now have #{secret_code_copy} as alright matches\n"
          i += 1
          break
        else 
          i += 1
     #     puts "the else statement has been executed"
        end
      end
    end
     number_of_alright_guesses
  end

  def secret_code_cloner
    k = 0
    copied_array = []
    while k < @secret_code.length
      copied_array[k] = @secret_code[k]
      k += 1
    end
    copied_array
  end

  def game_won?(guess_array)
    result = guess_array.all?('A')
    if result == true
      @game_won = true
      @game_over = true
    end
  end

  def display_boards
    i = 0
    print "\nGameboard:          Guessboard:\n"
    until i == @gameboard.count
      print "#{@gameboard[i]}        #{@guessboard[i]}\n"
      i += 1
    end 
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
  guess_results = game.guess_checker
  game.game_won?(guess_results)
  game.game_is_over?
  game.lives_reducer
  game.display_boards
end

if game.game_won == true
  puts 'Congrats, you have won the game'
else
  puts 'BOO, YOU HAVE LOST THE GAME!'
  print "The secret code was #{game.secret_code}, better luck next time!"
end

