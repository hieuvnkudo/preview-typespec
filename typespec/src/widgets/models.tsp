import "@typespec/http";

using Http;

namespace DemoService;

model Widget {
  id: string;
  weight: int32;
  color: "red" | "blue";
}

model WidgetList {
  items: Widget[];
}

model AnalyzeResult {
  id: string;
  analysis: string;
}