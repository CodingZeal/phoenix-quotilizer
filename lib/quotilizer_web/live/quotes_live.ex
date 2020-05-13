defmodule QuotilizerWeb.QuotesLive do
  use QuotilizerWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :thing)
    end

    socket = assign(socket, quotes: [])

    {:ok, socket}
  end

  # def handle_info(event, socket) do
  #   IO.inspect("Handling event in quotes live")
  #   IO.inspect(event)
  #   {:noreply, assign(socket, quotes: [])}
  # end

  def render(assigns) do
    ~L"""
      <h1>Quotes</h1>
      <ul>
        <%= for quote <- @quotes do %>
          <li><%= quote %></li>
        <% end %>
      </ul>
    """
  end

  def handle_info(:thing, socket) do
    new_quotes = socket.assigns.quotes
    new_quotes = new_quotes ++ ["Hello world - #{Enum.random(1..1000)}"]
    socket = assign(socket, quotes: new_quotes)
    {:noreply, socket}
  end
end
