require_relative 'Applications'
require 'byebug'

ui_gem = UIgen.new( 'http://localhost:4200/')
ui_gem.browser = 'chrome'
ui_gem.load_configuration('schema.json')

ui_gem.execute('ApplicationCreate')


