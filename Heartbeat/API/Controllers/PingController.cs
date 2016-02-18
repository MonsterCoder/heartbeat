using System.Web.Http;

namespace API.Controllers
{
    [RoutePrefix("ping")]
    public class PingController : ApiController
    {
        public IHttpActionResult Get()
        {
            return Ok();
        }
    }
}