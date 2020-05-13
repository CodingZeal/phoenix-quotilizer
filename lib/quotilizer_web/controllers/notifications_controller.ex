defmodule QuotilizerWeb.NotificationsController do
  use QuotilizerWeb, :controller

  def index(conn, params) do
    Phoenix.PubSub.broadcast(Quotilizer.PubSub, "quotes", params)
    json(conn, %{ message: "Hello world"})
  end
end
