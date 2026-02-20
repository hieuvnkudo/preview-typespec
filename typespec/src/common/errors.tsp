namespace DemoService;

@error
model Error {
  code: int32;
  message: string;
  details?: string;
}
