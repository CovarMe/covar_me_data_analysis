class OpenTSDBHelper(val method: String) {

  import scalaj.http.Http
  import org.json4s._
  import org.json4s.JsonDSL._
  import org.json4s.jackson.JsonMethods._

  implicit val formats = DefaultFormats

  case class TSMeta(metric: String, company: String)
  case class TSDP(date: Option[java.util.Date], value: Float)
  case class TS(tags: TSMeta, dps: JObject)

  var opentsdb_url: String = "http://127.0.0.1:9001/api/"

  val req_data = 
    ("start" -> "2y-ago") ~ ("queries" -> 
      List(
        (
          ("aggregator" -> "sum") ~ 
          ("metric" -> "TSLA.price") ~ 
          ("rate" -> "false") ~ 
          ("tags" -> 
            ("company" -> "TSLA"))))) 

  val response = Http(opentsdb_url + "query")
    .postData(compact(render(req_data)))
    .header("content-type", "application/json")
    .asString

    if (response.code == 200) {
      val body = parse(response.body)
      for {
        JArray(tsList) <- body
        ts <- tsList
      } {
        println(ts)
        println(ts.extract[TS])
      }
    }

}

new OpenTSDBHelper("put")
