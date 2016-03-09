using System.Web.Http;

namespace API.Controllers
{
    [RoutePrefix("ping")]
    public class PingController : ApiController
    {
        [Route(""),HttpGet]
        public IHttpActionResult Get()
        {
            return Ok("Request received");
        }
    }
}