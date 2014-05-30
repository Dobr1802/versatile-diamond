require 'erb'
require 'colorize'
require 'stringio'

ENGINE_DIR = '..'
OBJS_DIR = 'obj'

CC = 'g++'
FLAGS = "--std=c++0x -DPARALLEL -DTHREADS_NUM=3 -fopenmp -I#{ENGINE_DIR}/"
# FLAGS = "--std=c++0x -DPRINT -DTHREADS_NUM=1 -I#{ENGINE_DIR}/"
# FLAGS = "--std=c++0x -DTHREADS_NUM=1 -I#{ENGINE_DIR}/"

# Provides string by which compilation will do
# @return [String] the compilation string
def compile_line(file_in, file_out, additional_args = '')
  "#{CC} #{FLAGS} #{additional_args} #{file_in} -o #{file_out}"
end

# Makes random sequence of chars
# @param [Range] range of chars which will be used for random sequence
# @param [Integer] min_length the minimal length of result sequence
# @param [Integer] add_length the additional length of result sequence
# @return [String] the random sequence of characters
def random_sequence(range, min_length, add_length)
  (min_length + rand(add_length)).times.reduce('') do |acc|
    acc << range.to_a.sample
  end
end

# Makes random name
# @return [String] the random name
def random_name
  random_sequence('a'..'z', 3, 5) + random_sequence('0'..'9', 1, 2)
end

# Finds all C++ code files and makes Makefile by them, after that do `make` command
# @return [String] the make command output
def make
  dirs = Dir["#{ENGINE_DIR}/**/"].map do |dir_name|
    next if dir_name == "#{ENGINE_DIR}/" || dir_name =~ /^#{ENGINE_DIR}\/tests/
    dir_name.sub(/^#{ENGINE_DIR}\/(.+?)\/$/, '\1')
  end

  makefile = ERB.new(File.read('Makefile.erb'))
  compiler = CC
  flags = FLAGS
  src_dir = ENGINE_DIR
  obj_dir = OBJS_DIR
  source_dirs = dirs.compact.join(' ')

  File.open('Makefile', 'w') do |f|
    f.write(makefile.result(binding))
  end

  `make clean; make`
end

# Compilates test file
# @param [String] file_name the name of compiling test file
# @param [String] random_name the name of binary output file
def compile_test(file_name, random_name)
  if !@maked && ARGV.size == 0
    make
    @maked = true
  end

  supports = Dir['support/**/*.cpp']
  objs = Dir["#{OBJS_DIR}/**/*.o"]
  args = "#{supports.join(' ')} #{objs.join(' ')}"
  compile_line(file_name, random_name, args)
end

# Counts assert expressions in some file
# @param [String] file_name the name of scanning file
def count_asserts(file_name)
  @asserts ||= 0
  @asserts += File.read(file_name).scan(/\bassert/).size
end

# Gets number of counted asserts
# @return [Integer] the number of assert expressions
def asserts
  @asserts
end

# Runs test
# @param [String] file_name the name of running test file
def check(file_name)
  count_asserts(file_name)

  rn = random_name
  cl = compile_test(file_name, rn)
  puts cl

  `#{cl}`
  if $?.success?
    output = `./#{rn} 2>&1`
    puts output unless output.strip == ''

    run_result = $?.success?
    if run_result
      puts " +++ #{file_name} +++".green
      puts
      return nil
    end
  end
  puts " --- #{file_name} ---".red
  puts
  file_name
ensure
  `rm -f #{rn}`
end

# Counts asserts in engine source
def count_asserts_from_engine
  files = %w(h cpp).reduce([]) do |acc, ext|
    acc + Dir["#{ENGINE_DIR}/**/*.#{ext}"]
  end

  files.each(&method(:count_asserts))
end

spec_files = Dir['**/*.cpp'] - Dir['support/*.cpp']
result =
  if ARGV.size > 0
    ARGV.map do |spec_file_name|
      if spec_files.include?(spec_file_name)
        check(spec_file_name)
      else
        puts "Undefined spec: #{spec_file_name}"
        spec_file_name
      end
    end
  else
    count_asserts_from_engine
    spec_files.shuffle.map(&method(:check))
  end

puts
puts "Total #{asserts} examples..."
if result.any?
  print "Failed".red
  errors = result.compact.size
  puts " [ #{(result.size - errors).to_s.green} | #{errors.to_s.red} ]"
else
  print "Success".green
  puts " [ #{(result.size).to_s.green} ]"
end
