

CODE_NUMBERS = [1, 2, 3, 4, 5, 6]

class Display
  attr_reader :game_over, :gameboard, :game_won, :secret_code, :current_guess

  def initialize
    @lives = 5
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

  #A sort of compound function that calls both perfect_match_checker and alright_match_checker and returns the final guessboard for that iteration of the user guess
  def guess_checker(corr_guess_array, alright_guess_elements)
    cg_elements = corr_guess_array.count('A')
    #puts 
    #print "The number of correct guess elements is #{cg_elements}"
    elements_left_over = [alright_guess_elements - cg_elements, 0].max
    #print "\nThe number of elements left over is #{elements_left_over}"
    if elements_left_over > 0
      j = 0
      until elements_left_over == 0
        corr_guess_array[cg_elements + j] = 'B'
        elements_left_over -= 1
        j += 1
      end
    end
    #print "The guess array is #{cg_array} \n"
    corr_guess_array
  end

  #Sets up the Guessboard to give feedback to guess and checks what part of user guess is in secret code and in correct spot
  def perfect_match_checker(current_gue, secret_gue)
    initial_correct_guess_array = ['C', 'C', 'C', 'C']
    i = 0
    cg_place = 0
    until i == initial_correct_guess_array.length
      #puts "It is now checing index of #{i}"
      if current_gue[i] == secret_gue[i]
        #puts "#{@current_guess[i]} matches #{@secret_code}"
        initial_correct_guess_array[cg_place] = 'A'
        cg_place += 1
      end
      i += 1
    end
    initial_correct_guess_array
  end

  #Function to run after perfect_match_checker() to see what guesses are in the secret code., but not in correct spot
  def alright_match_checker(current_gue, secret_cod)
    #puts "new iteration of checker is running"
    #print @secret_code
    #puts
    number_of_alright_guesses = 0
    secret_code_copy = secret_code_cloner
    current_gue.each do |ele|
    #  puts "we are now checking #{ele}"
      i = 0
      while i < secret_cod.count
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

def guessboard_appender(guest)
  @guessboard.append(guest)
end

  #QnD function to close secret code as to combat pointer issues
  def secret_code_cloner
    k = 0
    copied_array = []
    while k < @secret_code.length
      copied_array[k] = @secret_code[k]
      k += 1
    end
    copied_array
  end

  #Function to check if game has been won
  def game_won?(guess_array)
    result = guess_array.all?('A')
    if result == true
      @game_won = true
      @game_over = true
    end
  end

  #Function to display both gameboard and guessboard in an easily readible format
  def display_boards
    i = 0
    print "\nGameboard:          Guessboard:\n"
    until i == @gameboard.count
      print "#{@gameboard[i]}        #{@guessboard[i]}\n"
      i += 1
    end 
  end
end

class Computer < Display
  attr_reader :random_code, :instance_of_all_possible_codes

  def initialize
    @instance_of_all_possible_codes = Computer.all_possible_codes_generator
  end
  
  
  
  # If CPU is code setter, sets up a random combination as the code
  def cpu_code_setter
    @random_code = []
    4.times do 
      temp = CODE_NUMBERS.sample
      @random_code.append(temp)
    end
    return @random_code
  end
  
  #This function generates all 1296 iterations of secret code to help computer make its guess on secret code
  def self.all_possible_codes_generator
    container = []
    i = 0 
    while i < CODE_NUMBERS.count
      j = 0
      while j < CODE_NUMBERS.count
        k = 0
        while k < CODE_NUMBERS.count
          l = 0
          while l < CODE_NUMBERS.count
            temp = [CODE_NUMBERS[i],CODE_NUMBERS[j],CODE_NUMBERS[k],CODE_NUMBERS[l]]
            container.append(temp)
            l += 1
          end
          k += 1
        end
        j += 1
      end
      i += 1
    end
    container
  end



end

class Human
  def initialize(name)
    @name = name
  end

  # If Human is code setter, allows the user to set the code while also validating correct input
  def human_code_setter
    @human_code = []
    puts "\nHello #{@name}, you will know be prompted to pick 4 numbers to be the code the computer will try to break "
    while @human_code.length != 4
      print 'type in a number from 1 to 6: '
      num = gets.chomp.to_i
      num = loop_validator(num)
      @human_code.append(num)
    end
    #print @human_code
    return @human_code
  end

  #Function to compartmentalize process to get imput for each guess with validation
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
          print "\nRUH ROE, that input was not in or between 1-6, please type in an interger in that range here: "
          number = gets.chomp.to_i
          puts
        end
        return number
    end
  end
end

al = Computer.new
john = Human.new("John")
game = Display.new


puts
puts """Welcome to Mastermind, a game that will test your codebreaking and codemaking skills.
You will play against the computer as either a codebreaker or codemaker.

If you are a codebreaker, then it will be your responcibilty to crack the Computer's secret code.
The Computer will randomly generate a 4 digit code made up from the numbers 1 to 6, with repititon allowed.

After each guess, you will be prompted with feedback on the Guessboard. 
The letter 'A' indicates one of your guesses is the right number in the right spot. The letter 'B' indicates that the letter is
in the secret code, but not in the correct spot. Lastly, the letter 'C' indicates that one of the letters is not contained in the secret code"""

#NOTE: Will need to add print statement to explain how to play if human plays as a codemaker

print "\nAlright Human, it's time to pick your role. Type 1 and press enter if you want to play as a codebreaker or type in 2 and press enter to play as a codemaker: "
#I can add input vlaidation here later if i feel like being responcible
role_chosen = gets.chomp.to_i

if role_chosen == 1
  computer_secret_code = al.cpu_code_setter
  game.set_secret_code(computer_secret_code)
  #print game.secret_code
  until game.game_over == true
    present_guess = john.human_code_guessor
    game.set_current_guess(present_guess)
    correct_guess_array = game.perfect_match_checker(game.current_guess, game.secret_code)
    alright_guess_elements = game.alright_match_checker(game.current_guess, game.secret_code)
    #puts "\nThe cg array is #{cg_array}"
    #puts "the number of alright elements is #{ag_elements}"
    guess_results = game.guess_checker(correct_guess_array, alright_guess_elements)
    #print "\nThe final guess result is #{guess_results}"
    game.guessboard_appender(guess_results)
    game.game_won?(guess_results)
    game.game_is_over?
    game.lives_reducer
    game.display_boards
  end
else
  human_secret_code = john.human_code_setter
  game.set_secret_code(human_secret_code)
  
end

if game.game_won == true
  puts 'Congrats, you have won the game'
else
  puts 'BOO, YOU HAVE LOST THE GAME!'
  print "The secret code was #{game.secret_code}, better luck next time!"
end

