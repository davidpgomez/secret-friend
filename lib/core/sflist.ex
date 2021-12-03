defmodule SecretFriends.Core.SFList do
    @moduledoc """
    Documentation for `SecretFriends.Core.SFList`.
    """

    @doc """
    This function creates a new list of friends

    ## Examples
        iex> SecretFriends.Core.SFList.new
        []

    """
    def new, do: []

    @doc """
    Adds a new friend to the list

    ## Examples
        iex> SecretFriends.Core.SFList.add_friend([], "Jose")
        ["Jose"]
    """
    def add_friend(sflist, new_friend), do: [new_friend | sflist]

    def create_selection(sflist) do
        sflist
        |> Enum.shuffle()
        |> gen_pairs()
    end

    defp gen_pairs(sflist) do
        Enum.chunk_every(sflist, 2, 1, sflist)
    end

end
