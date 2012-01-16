# encoding: utf-8

require 'sinatra'
require 'haml'


module CHEPAVA
  class Site < Sinatra::Base
    set :haml, :format => CONFIGURATION[:html].to_sym
    set :public_folder, PUBLIC_DIR
    set :views, VIEWS_DIR
    enable :static_cache_control
    disable :show_exceptions
    disable :sessions

    LOCALE_REQUEST_KEY = 'HTTP_ACCEPT_LANGUAGE'
    LOCALE = ':locale'

    REG_LOCALE__SEPARATOR1 = /[;]/
    REG_LOCALE__SEPARATOR2 = /[,]/

    get "#{SEPARATOR}*.css" do
      content_type "text#{SEPARATOR}css"
      pass
    end

    get SEPARATOR do
      def_lang
      redirect SEPARATOR + @locale
    end

    get SEPARATOR + LOCALE + SEPARATOR do
      def_lang
      redirect SEPARATOR + @locale
    end

    get SEPARATOR + LOCALE do
      def_lang
      haml :index
    end

    not_found do
      redirect SEPARATOR
    end

    error do
      redirect SEPARATOR
    end

    private

    def def_lang
      @locale = params[:locale].to_s
      if @locale.empty?
        begin
          @locale = request.env[LOCALE_REQUEST_KEY].split(REG_LOCALE__SEPARATOR1)[0].split(REG_LOCALE__SEPARATOR2)[-1]
        rescue
          @locale = CONFIGURATION[:locale]
        end
      end
      redirect SEPARATOR + CONFIGURATION[:locale] unless CONFIGURATION[:locales_list].include?(@locale)
    end

  end
end
