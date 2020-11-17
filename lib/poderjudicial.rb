require "poderjudicial/version"
require 'watir'
require 'webdrivers'
require 'selenium-webdriver'
module Poderjudicial
  class CrawlerInfo
    def initialize args = {}
      @pattern_for_p_actor = /#{Regexp.escape('Actor:')}(.*?)#{Regexp.escape('Demandado:')}/m
      @pattern_for_p_demandado = /#{Regexp.escape('Demandado:')}(.*?)/m
      @pattern_for_p_resumen = /#{Regexp.escape('RESUMEN:')}(.*?)/m
      @agent = Mechanize.new
      @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @user_email = args[:email] || args["email"]
      @password = args[:password] || args["password"]
      @url_individual_search = (args[:individual_search] || args["individual_search"]) || "https://www.poderjudicialvirtual.com/buscar-nuevos-expedientes"
    end

    def get_from_url url
      data = {
        actor: "",
        demandado: "",
        expediente: "",
        notificaciones: "",
        resumen: "",
        juzgado: ""
      }
       web = @agent.get(url)
       data[:actor] = get_actor_content web
       data[:demandado] = get_demandado_content web
       data[:expediente] = get_expediente_content web
       data[:notificaciones] = get_notificaciones_content web
       data[:resumen] = get_resumen_content web
       data[:juzgado] = get_juzgado_content web
       return data
    end

    def get_demands_from_user name
      raise StandardError.new "Debes definir una url para la búsqueda de demandas por nombre" if @url_individual_search.blank?
      doc = get_dynamic_html @url_individual_search, name
      name = I18n.transliterate(name)
      demands = []
      doc.search(".boxbusqueda").each do |elem|
        position = I18n.transliterate(elem.search('div[ng-bind-html="item.demandado"]').first.text) =~ /Demandado:[\s+]#{Regexp.escape("#{name}")}(.*?)/x
        next if position.nil?
        if(position) > -1
          elem.search('div[ng-bind-html="item.numexpediente"]').each do |field_number|
            demands << field_number.text
          end
        end
      end
      @b.close
      demands
    end

    private
    def get_actor_content web
      content = web.search(".content").at("p:contains('Actor:')").parent.text.strip
      content[@pattern_for_p_actor, 1].strip
    end

    def get_demandado_content web
      content = web.search(".content").at("p:contains('Demandado:')").parent.text.strip
      pattern = /Demandado:(\S*) (.*)/m
      content.split(pattern)[2].strip
    end

    def get_expediente_content web
      numbers = web.search(".content").at("p:contains('Expediente')").parent.text.strip.scan(/\d+/)
      "#{numbers[0]}/#{numbers[1]}"
    end

    def get_notificaciones_content web
      notifications = []
      web.search("#listaAcuerdos").search(".tickets").search(".containerdegradado").search(".list-group-item").each do |notification|
        notifications << notification.text
      end
      notifications
    end

    def get_resumen_content web
      content = web.search(".content").at("p:contains('RESUMEN:')").parent.text.strip
      content.split(@pattern_for_p_resumen)[2].try(:strip)
    end

    def get_juzgado_content web
      web.search('//*[@id="pcont"]/div/div/div[2]/div[2]/p/a[2]').text
    end

    def get_dynamic_html url, string_search
      raise StandardError.new "Debes de agregar un email y un password para poder obtener la información del sitio" if @user_email.blank? || @password.blank?
      login_session
      @b ||= Watir::Browser.new
      @b.goto url
      @b.text_field(class: "busqExacInput").set string_search
      @b.button(id: "btn-form-enviar").click
      Nokogiri::HTML @b.div(:class=>'products').html
    end

    def login_session
      @b ||= Watir::Browser.new
      @b.goto "https://www.poderjudicialvirtual.com/entrar"
      @b.text_field(id: "lgnemail").set @user_email
      @b.text_field(id: "lgnpassword").set @password
      @b.button(type: "submit", class: "btn-primary btn-flat").click
      Watir::Wait.until { @b.text.include? 'Buscar Expedientes' }
    end
  end
end
