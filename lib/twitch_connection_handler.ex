defmodule TwitchConnectionHandler do
  defmodule State do
    defstruct host: "irc.chat.twitch.tv",
              port: 6667,
              pass: nil,
              nick: "justinfan87492",
              user: "justinfan87492",
              name: "justinfan87492",
              debug?: true,
              client: nil
    end

  def start_link(client, state \\ %State{}) do
    GenServer.start_link(__MODULE__, [%{state | client: client}])
  end

  def init([state]) do
    ExIRC.Client.add_handler state.client, self
    ExIRC.Client.connect! state.client, state.host, state.port
    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    debug "Connected to #{server}:#{port}"
    ExIRC.Client.logon state.client, state.pass, state.nick, state.user, state.name
    {:noreply, state}
  end

  def handle_info({:received, message, info, _channel}, state) do
    # debug "We got a chat message from #{state.user} : #{message}"
    broadcast({:ok, %{ text: message, user: info.user }})
    {:noreply, state}
  end

  defp broadcast({:ok, message}) do
    Phoenix.PubSub.broadcast(Quotilizer.PubSub, "messages", { :new_message, message })
  end

  # Catch-all for messages you don't care about
  def handle_info(msg, state) do
    debug "Received unknown messsage:"
    IO.inspect msg
    {:noreply, state}
  end

  defp debug(msg) do
    IO.puts IO.ANSI.yellow() <> msg <> IO.ANSI.reset()
  end
end
