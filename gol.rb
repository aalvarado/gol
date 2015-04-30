$LOAD_PATH << File.join([ File.dirname(__FILE__), 'app' ])
$LOAD_PATH << File.join([ File.dirname(__FILE__), 'lib' ])

require 'cell'
require 'grid'
require 'grid_builder'
require 'logic'
require 'cli/main'
