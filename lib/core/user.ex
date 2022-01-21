defmodule SecretFriends.Core.User do
  def new(name, nick) do
    %{name: name, nick: nick, sflists: []}
  end

  def add_sflist(%{sflists: sflists} = _user) do
    sflists
  end

  def add_sflists(%{sflists: sflists} = user, new_sflist) do
    updated_sflists = [new_sflist| sflists]
    %{user | sflists: updated_sflists}
  end
end
