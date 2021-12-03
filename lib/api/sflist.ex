defmodule SecretFriends.API.SFList do
  alias SecretFriends.Worker.SFWorker
    @moduledoc """
    Documentation for `SecretFriends.API.SFList`.

    It is an SDK for interacting with secret friends
    """

    @doc """
    This function creates a new list of friends

    ## Examples
        iex> SecretFriends.API.SFList.new
        []

    """
    def new() do
      SFWorker.start()
    end

    @doc """
    Adds a new friend to the list

    ## Examples
        iex> SecretFriends.API.SFList.add_friend(pid, "Jose")
        ["Jose"]
    """
    def add_friend(pid, friend) do
      send(pid, {:cast, {:add_friend, friend}})
      pid
    end

    def create_selection(pid) do
        send(pid, {:call, self(), :create_selection})
        handle_response()
    end

    def show(pid) do
      # send request to server
      send(pid, {:call, self(), :show})

      # await for response
      handle_response()
    end

  defp handle_response() do
    receive do
      {:response, response} -> response
      _other -> nil
    end
  end
end
