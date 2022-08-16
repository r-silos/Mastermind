CODE_NUMBERS = [1,2,3,4,5,6]

class Display

    def initialize
        @lives = 6
        #gamegoard keeps track of number guesses of codebreaker
        @gameboard = []
        #guessboard keeps track of whether each position is correct or not
        @guessboard = []
    end

    def set_secret_code(code)
        @secret_code = code
    end
end

class Computer

    
    attr_reader :random_code

    #If CPU is code setter, sets up a random combination as the code
    def cpu_code_setter
        @random_code = []
        4.times do 
            temp = CODE_NUMBERS.sample
            @random_code.append(temp)
        end
        print random_code
        return @random_code
    end

end


class Human

    def initialize(name)
        @name = name
    end

    #If Human is code setter, allows the user to set the code while also validating correct input
    def human_code_setter
        @human_code = []
        puts "Hello #{@name}, you will know be prompted to pick 4 numbers to be the code the computer will try to break "
        while @human_code.length != 4
            print "type in a number from 1 to 6: "
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



    #little function to make data input validation easier in class
    def loop_validator(number)
        if CODE_NUMBERS.include?(number)
            return number
        else
            while !(CODE_NUMBERS.include?(number))
                print "RUH ROE, that input was not in or between 1-6, please type in an interger in that range here: "
                number = gets.chomp.to_i
            end
            return number
        end
    end




end

#al = Computer.new()
#al.cpu_code_setter

john = Human.new("John")
john.human_code_guessor
