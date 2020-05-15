defmodule QuotilizerWeb.NotificationsController do
  use QuotilizerWeb, :controller

  def index(conn, params) do
    Quotilizer.Quote.create_quote(params)
    json(conn, %{ message: "Hello world"})
  end
end
