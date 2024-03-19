using System.Threading.Tasks;
using Greet;
using Grpc.Core;
using Microsoft.Extensions.Logging;

namespace Server
{
    public class GreeterService(ILoggerFactory loggerFactory) : Greeter.GreeterBase
    {
        private readonly ILogger _logger = loggerFactory.CreateLogger<GreeterService>();

        public override Task<HelloReply> SayHello(HelloRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"Sending hello to {request.Name}");
            return Task.FromResult(new HelloReply { Message = $"Hello {request.Name}" });
        }

        public override Task<HelloReply> SayHelloFrom(HelloRequestFrom request, ServerCallContext context)
        {
            _logger.LogInformation($"Sending hello to {request.Name} from {request.From}");
            return Task.FromResult(new HelloReply { Message = $"Hello {request.Name} from {request.From}" });
        }

        public override Task<HelloReply> SayHelloFromWithType(HelloRequestFromWithType request, ServerCallContext context)
        {
            _logger.LogInformation($"Sending hello to {request.Params.Name} from {request.Params.From} by {request.Type}");
            return Task.FromResult(new HelloReply { Message = $"Hello {request.Params.Name} from {request.Params.From} by {request.Type}" });
        }
    }
}
