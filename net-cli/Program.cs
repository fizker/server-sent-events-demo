using System;
using LaunchDarkly.EventSource;

namespace net_cli
{
	class Program
	{
		static void Main(string[] args)
		{
			Console.WriteLine("Hit enter to exit");
			var controller = new EventSourceController(new("http://localhost:8030/messages"));
			controller.Connect();
			Console.ReadLine();
		}
	}

	class EventSourceController
	{
		readonly EventSource _eventSource;

		public EventSourceController(Uri serverUri)
		{
			var configuration = Configuration.Builder(serverUri)
				.Build();
			_eventSource = new(configuration);

			_eventSource.Opened += OnOpen;
			_eventSource.MessageReceived += OnMessage;
			_eventSource.Error += OnError;
		}

		public void Connect()
		{
			_ = _eventSource.StartAsync();
		}

		void OnOpen(object sender, StateChangedEventArgs e)
		{
			Console.WriteLine("Connection open");
		}

		void OnMessage(object sender, MessageReceivedEventArgs e)
		{
			Console.WriteLine($"Event name: {e.EventName}");
			Console.WriteLine($"Data: {e.Message.Data}");
		}

		void OnError(object sender, ExceptionEventArgs e)
		{
			Console.WriteLine($"Got exception: ({e.Exception.GetType().FullName}) {e.Exception.Message}");
		}
	}
}
