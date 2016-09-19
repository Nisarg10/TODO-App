module Menu
      def menu
        " Welcome to the TodoLister Program!
        This menu will help you use the Task List System
        1) Add
        2) Show
        3) Update
        4) Delete
        5) Write to File
        6) Read from File
        Q) Quit "
      end

      def show
        menu
      end
    end

    module Promptable
      def prompt(message = "Just the facts, ma'am.", symbol = ':> ')
        print message
        print symbol
        gets.chomp
      end
    end

    class List
      attr_reader :all_tasks

      def initialize
        @all_tasks = []
      end

      def add(task)
        all_tasks << task
      end

      def delete(task_number)
        all_tasks.delete_at(task_number - 1)
      end

      def update(task_number, task)
          all_tasks[task_number - 1] = task
      end

      def show
        all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
      end

      def write_to_file(filename)
          machinified = @all_tasks.map(&:to_machine).join("\n")
          IO.write(filename, machinified)
      end

      def read_from_file(filename)
          IO.readlines(filename).each do |line|
            status, *description = line.split(':')
            status = status.include?('X')
            add(Task.new(description.join(':').strip, status))
          end
      end
    end

    class Task
      attr_reader :description
      attr_accessor :status

      def initialize(description, status = false)
          @description = description
          @status = status
        end

      def completed?
          status
      end

      def to_s
        description
      end

      def to_machine
          "#{represent_status}:#{description}"
        end

      private
        def represnt_status
          "#{completed? ? '[X]': '[ ]'}"
        end

    end

    if __FILE__ == $PROGRAM_NAME
          include Promptable
          include Menu
          ml = List.new
          puts 'Please choose from the following list'
          until ['q'].include?(user_input = prompt(show).downcase)
            case user_input
            when '1'
              ml.add(Task.new(prompt('What is the task you would like 
              to accomplish?')))
            when '2'
              puts ml.show
            when '3'
              puts ml.show
              ml.update(prompt('Which task to update?').to_i, 
              Task.new(prompt('Task Description?')))
            when '4'
              puts ml.show
              ml.delete(prompt('Which task to delete?').to_i)
            when '5'
              ml.write_to_file(prompt 'What is the filename to 
              write to?')
            when '6'
              begin
                ml.read_from_file(prompt('What is the filename to 
                read from?'))
              rescue Errno::ENOENT
                puts 'File name not found, please verify your file 
                name and path.'
              end
            else
              puts 'Try again, I did not understand.'
            end
            prompt('Press enter to continue', '')
          end
          puts 'Outro - Thanks for using the awesome menu system!'
    end
