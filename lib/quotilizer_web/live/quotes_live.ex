defmodule QuotilizerWeb.QuotesLive do
  use QuotilizerWeb, :live_view

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Quotilizer.PubSub, "quotes")

    socket = assign(socket, quotes: [])

    {:ok, socket}
  end

  def handle_info({:quote_created, quote}, socket) do
    {:noreply, assign(socket, quotes: [quote.text | socket.assigns.quotes])}
  end

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
end
