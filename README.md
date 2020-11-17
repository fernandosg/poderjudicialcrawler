# poderjudicialcrawler

Gem Crawler para poder obtener información del sitio poderjudicial.com
## Installation

Agregue la siguiente línea en tu gemfile del proyecto

```ruby
gem 'poderjudicial', git: 'https://github.com/fernandosg/poderjudicialcrawler'
```

## Usage

Una vez agregado al proyecto, genere una instancia de la clase

Poderjudicial::CrawlerInfo
```ruby
object = Poderjudicial::CrawlerInfo.new email: "emaildelacuentapoderjudicial", password: "contraseña_de_la_cuenta"
```

Argumentos:

email: Requerido
password: Requerido
individual_search: Opcional.- Este argumento servirá para ver el listado de las demandas a partir de un nombre

La clase tiene 2 métodos:

### get_from_url
```ruby
object.get_from_url "https://www.poderjudicialvirtual.com/df-trejo-bouquet-jacqueline-del-carmen--nueva-wal-mart-de-mexico-s-de-r-l-de-c-v-y-servicios-adminis-26/2020"
```

El método get_from_url obtendra informacion a partir de la ur proporcionada.

Retorna un hash similar a la siguiente estructura

```ruby
{
   actor: "",
   demandado: "",
   expediente: "",
   notificaciones: "",
   resumen: "",
   juzgado: ""
}
```

### get_demands_from_user

```ruby
get_demands_from_user "Banco Santander Mexico"
```

Recibe el nombre de una persona/empresa

Retorna un arreglo con los diferentes números de demandas

## Dependencias
Para el correcto uso de esta gema se requiere tener las siguientes gemas definidas:

watir
webdrivers
selenium-webdriver

## License
[MIT](https://choosealicense.com/licenses/mit/)
