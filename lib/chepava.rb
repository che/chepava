# encoding: utf-8

require 'yaml'


module CHEPAVA

  SEPARATOR = '/'

  CHAR_EMPTY = ''
  CHAR_DOG = '@'
  CHAR_DOT = '.'

  YAML_FILE_EXTENSION = '.yml'
  RUBY_FILE_EXTENSION = '.rb'

  REG_YAML_FILE = /[.][Yy][Mm][Ll]$/
  REG_RUBY_FILE = /[.][Rr][Bb]$/
  REG_SPACES = /[\s\t]/

  LOCALES_DIR = 'locales' + SEPARATOR
  CONFIG_DIR = File.dirname(File.dirname(File.expand_path(__FILE__))) + SEPARATOR + 'config' + SEPARATOR
  PUBLIC_DIR = File.dirname(CONFIG_DIR) + SEPARATOR + 'public'
  VIEWS_DIR = File.dirname(CONFIG_DIR) + SEPARATOR + 'views'

  NAME = File.basename(__FILE__, RUBY_FILE_EXTENSION)

  ENCODING_DEFAULT = 'utf-8'
  LOCALE_DEFAULT = 'en'

  CONFIGURATION = {}

  def self.init
    for i in YAML.load_file(CONFIG_DIR + NAME + YAML_FILE_EXTENSION)[NAME] do
      CONFIGURATION[i[0].to_sym] = i[1]
    end
    CONFIGURATION[:tel] = {:title => CONFIGURATION[:tel], :number => CONFIGURATION[:tel].gsub(REG_SPACES, CHAR_EMPTY)} if CONFIGURATION[:tel]
    CONFIGURATION[:domain] = NAME + CHAR_DOT + CONFIGURATION[:domain] if CONFIGURATION[:domain]
    CONFIGURATION[:mailto] = CONFIGURATION[:mailto] + CHAR_DOG + CONFIGURATION[:domain] if CONFIGURATION[:mailto]
    CONFIGURATION[:sites] = CONFIGURATION[:sites].split(REG_SPACES) if CONFIGURATION[:sites]
    CONFIGURATION[:locales_list] = CONFIGURATION[:locales_list].split(REG_SPACES) if CONFIGURATION[:locales_list]
    CONFIGURATION[:locale] = LOCALE_DEFAULT unless CONFIGURATION[:locale]
    CONFIGURATION[:locales] = {}
    @path = CONFIG_DIR + LOCALES_DIR
    for i in Dir.entries(@path) do
      @file = @path + i
      if @file =~ REG_YAML_FILE && File.exists?(@file) && File.file?(@file)
        CONFIGURATION[:locales].merge!(YAML.load_file(@file))
      end
    end
    CONFIGURATION[:locales_list].replace(CONFIGURATION[:locales_list] & CONFIGURATION[:locales].keys)
    for i in CONFIGURATION[:locales_list] do
      for l in CONFIGURATION[:locales].delete(i) do
        CONFIGURATION[:locales][i] = {} unless CONFIGURATION[:locales][i]
        CONFIGURATION[:locales][i][l[0].to_sym] = l[1]
      end
    end
    if CONFIGURATION[:locales_list].include?(CONFIGURATION[:locale])
      @path = File.dirname(__FILE__) + SEPARATOR + File.basename(__FILE__, RUBY_FILE_EXTENSION)
      for i in Dir.entries(@path).sort[2..-1].reverse do
        @file = @path + SEPARATOR + i
        require @file if @file =~ REG_RUBY_FILE && File.exists?(@file) && File.file?(@file)
      end
    end
    for i in instance_variables do
      remove_instance_variable(i)
    end
  end

end
