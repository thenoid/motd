# Encoding: utf-8

require 'rspec/core/rake_task'
# current_dir = File.dirname(__FILE__)

desc 'Run cop, foodcritic, spec'
task default: [:cop, :foodcritic, :spec]
desc 'Run cop, foodcritic, spec, kitchen'
task all: [:default, :kitchen]
task validate: :default

desc 'Run ChefSpec unit tests'
task :spec do
  sh('chef', 'exec', 'rspec')
end

desc 'Run RuboCop'
task :cop do
  sh('chef', 'exec', 'rubocop')
end

desc 'Run Foodcritic'
task :foodcritic do
  sh('foodcritic', '-f', 'any', '.')
end

desc 'Run KitchenCI'
task :kitchen do
  sh('kitchen', 'converge')
  sh('kitchen', 'verify')
end

desc 'Release the software artifact (tag in git, push to supermarket/chef server)'
task :release do
  text = File.read("./metadata.rb")
  b    = 1
  b   += text.match(/version\D+(((?:\d+\.)+)(\d+))/)[3].to_i
  find = $1
  repl = "#{$2}#{b}"
  text.gsub!(/#{find}/,repl)
  name = text.match(/name\s*\S(.*)\S/)[1].to_s
  puts "Updating version: #{find} -> #{repl}"
  File.open("./metadata.rb", "w") {|file| file.puts text }
  sh('git','tag','-a',"v#{repl}",'-m',"'rake released #{repl}'")
  #sh('git','push','--tags')
  sh('berks','install')
  sh('berks','upload','--no-freeze',name)
  #sh('knife','supermarket','share','-m','https://bodega',name)
end
