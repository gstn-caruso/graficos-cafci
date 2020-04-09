namespace :descargar do
  desc 'Descargar información histórica de la CAFCI'
  task historico: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    api_url = 'https://api.cafci.org.ar/estadisticas/informacion/diaria/3/'

    ventana_de_tiempo = ((3.months.ago)..(1.day.ago))
    rango_de_fechas = (ventana_de_tiempo.begin.to_date..ventana_de_tiempo.last.to_date)
    fondos_hsbc_parseados = []

    rango_de_fechas.each do |fecha|
      sleep(1)

      puts("HTTP - GET fecha #{fecha}")
      url_fecha = URI(api_url + fecha.strftime('%Y-%m-%d'))
      respuesta = JSON.parse(Net::HTTP.get(url_fecha))['data']

      next if respuesta.blank?

      fondos_hsbc = respuesta.select { |r| r['fondo'].include? 'HF' }

      fondos_hsbc_parseados << fondos_hsbc.map do |f|
        {
            nombre: f['fondo'],
            fecha: DateTime.strptime(f['fecha'], '%d/%m/%y'),
            valor_cuotaparte: f['vcp'],
            cantidad_cuotaparte: f['ccp'],
            patrimonio: f['patrimonio'],
        }
      end

      puts("HTTP - GET fondo encontrado")
    end

    FondoComunDeInversion.create!(fondos_hsbc_parseados)
  end
end
