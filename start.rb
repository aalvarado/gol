require './gol'
require 'yaml'

conf = YAML.load_file('conf/screen.yml')

screen = Screen.new(conf)

puts conf['final_message']
