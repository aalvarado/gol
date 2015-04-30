require './gol'
require 'yaml'

conf = YAML.load_file('conf/screen.yml')

Screen.new(conf)

puts conf['final_message']
