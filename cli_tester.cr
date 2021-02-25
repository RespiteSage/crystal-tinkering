require "process"

class CLITester
  private getter process_string : String
  private getter initial_expectation : String?
  getter interactions = Hash(Array(String), Array(String)?).new
  private getter all_output = String::Builder.new

  private def initialize(@process_string, @initial_expectation)
  end

  def self.test_process(process_string : String, initial_expectation : String? = nil)
    tester = self.new process_string, initial_expectation

    yield tester

    puts "Interactions:"
    tester.interactions.each do |inputs, expectations|
      puts "---", "#{inputs} => #{expectations}"
    end

    tester.run
  end

  def add_interaction(inputs : Array(String), expectations : Array(String)? = nil)
    interactions[inputs] = expectations
  end

  def add_interaction(input : String, expectation : String? = nil)
    if expectation
      add_interaction [input], [expectation]
    else
      add_interaction [input]
    end
  end

  def run
    rolling_output_read, rolling_output_write = IO.pipe

    output = IO::MultiWriter.new all_output, rolling_output_write

    Process.run(process_string, shell: true, output: output) do |process|
      initial_output = rolling_output_read.gets

      if initial_expectation
        puts "Matches initial expectation: #{initial_output == initial_expectation}"
      end

      interactions.each do |(inputs, expectations)|
        interaction_passes = true
        interaction_record = Array(Tuple(String, String?, String)).new

        inputs.each_index do |i|
          unless inputs[i].empty?
            process.input.puts inputs[i]
          end

          response = rolling_output_read.gets

          if expectations && expectations[i]?
            interaction_passes &&= response == expectations[i]

            interaction_record << {inputs[i], response, expectations[i]}
          else
            interaction_record << {inputs[i], response, "[No expectation]"}
          end
        end

        if interaction_passes
          puts "Interaction beginning with '#{inputs[0]}' passes!"
        else
          puts "Interaction beginning with '#{inputs[0]}' fails..."
          interaction_record.each do |(input, response, expectation)|
            puts "  '#{input}' => '#{response}' (expected '#{expectation}')"
          end
        end
      end
    end
  end
end

process_string = "echo 'First prompt'; head -n 1 | tr ',' ':'; echo 'Second prompt'; head -n 1 | tr ',' ';'"
initial_expectation = "First prompt"

CLITester.test_process(process_string, initial_expectation) do |tester|
  tester.add_interaction "Hello, world!", "Hello: world!"
  tester.add_interaction "", "Second prompt"
  tester.add_interaction "Goodbye, world!", "Goodbye; world!"
end
