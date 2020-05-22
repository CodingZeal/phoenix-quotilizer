defmodule QuotilizerWeb.MessageLive.Index do
  use QuotilizerWeb, :live_view

  alias Quotilizer.TwitchFeed
  alias Quotilizer.TwitchFeed.Message

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Quotilizer.PubSub, "messages")

    {:ok, assign(socket, messages: [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_info({:new_message, message}, socket) do
    IO.inspect message.user
    IO.inspect message.text
    {:noreply, assign(socket, messages: [message | socket.assigns.messages])}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, TwitchFeed.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = TwitchFeed.get_message!(id)
    {:ok, _} = TwitchFeed.delete_message(message)

    {:noreply, assign(socket, :messages, fetch_messages())}
  end

  defp fetch_messages do
    TwitchFeed.list_messages()
  end
end
