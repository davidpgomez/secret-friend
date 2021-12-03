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
    def new(name) do
      SFWorker.start_link(name)
      name
    end

    @doc """
    Adds a new friend to the list

    ## Examples
        iex> SecretFriends.API.SFList.add_friend(pid, "Jose")
        ["Jose"]
    """
    def add_friend(name, friend) do
      case GenServer.call(name, {:add_friend, friend}) do
        :ok -> name
        :locked -> :locked
      end
    end

    def create_selection(name) do
        GenServer.call(name, :create_selection)
    end

    def show(name) do
      # send request to server
      GenServer.call(name, :show)
    end

    def lock?(name) do
      GenServer.call(name, :lock?)
    end

    def lock(name) do
      GenServer.cast(name, :lock)
    end

    def unlock(name) do
      GenServer.cast(name, :unlock)
    end

end
