import "@typespec/http";
import "./src/widgets/models.tsp";
import "./src/widgets/routes.tsp";

using Http;
@service(#{ title: "Widget Service" })
namespace DemoService;
