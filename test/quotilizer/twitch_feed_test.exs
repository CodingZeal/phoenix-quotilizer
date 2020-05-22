defmodule Quotilizer.TwitchFeedTest do
  use Quotilizer.DataCase

  alias Quotilizer.TwitchFeed

  describe "messages" do
    alias Quotilizer.TwitchFeed.Message

    @valid_attrs %{text: "some text", username: "some username"}
    @update_attrs %{text: "some updated text", username: "some updated username"}
    @invalid_attrs %{text: nil, username: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TwitchFeed.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert TwitchFeed.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert TwitchFeed.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = TwitchFeed.create_message(@valid_attrs)
      assert message.text == "some text"
      assert message.username == "some username"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TwitchFeed.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = TwitchFeed.update_message(message, @update_attrs)
      assert message.text == "some updated text"
      assert message.username == "some updated username"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = TwitchFeed.update_message(message, @invalid_attrs)
      assert message == TwitchFeed.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = TwitchFeed.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> TwitchFeed.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = TwitchFeed.change_message(message)
    end
  end
end
