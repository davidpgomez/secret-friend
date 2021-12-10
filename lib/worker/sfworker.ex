defmodule SecretFriends.Worker.SFWorker do
  use GenServer
  alias SecretFriends.Core.SFList

  # start server
  def start_link(name) do
    # MFA (module - function - arguments)
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @impl GenServer
  def init(name) do
    # search for a previous state of `name` process and retrieve it
    case :ets.lookup(:sflist_cache, name) do
      [] ->
        {:ok, %{sflist: SFList.new(), selection: nil, lock: false, name: name}}
      # use ^name to match by name value (and not override it)
      [{^name, state}] ->
        {:ok, state}
    end
  end

  # handle_cast (msg, state) -> {:noreply, new_state}
  @impl GenServer
  def handle_call({:add_friend, friend}, _from, %{sflist: sflist, lock: false} = state) do
    new_sflist = SFList.add_friend(sflist, friend)
    # invalidate previous selection when adding a friend
    # use pipe operand to update sflist and selection keys of state dict
    {:reply, :ok, %{state | sflist: new_sflist, selection: nil}}
  end

  # handle_cast (msg, state) -> {:noreply, new_state}
  @impl GenServer
  def handle_call({:add_friend, _friend}, _from, %{lock: true} = state) do
    # when list is locked, the state remains
    {:reply, :locked, state}
  end

  @impl GenServer
  def handle_cast(:lock, %{name: name} = state) do
    new_state = %{state | lock: true}

    :ets.insert(:sflist_cache, {name, new_state})
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_cast(:unlock, %{name: name} = state) do
    new_state = %{state | lock: false}

    :ets.insert(:sflist_cache, {name, new_state})
    {:noreply, new_state}
  end

  # handle_call (msg, from, state) -> {:reply, response, new_state}
  @impl GenServer
  def handle_call(:create_selection, _from, %{sflist: sflist, name: name} = state) do
    new_selection = SFList.create_selection(sflist)
    new_state = %{state | selection: new_selection}

    :ets.insert(:sflist_cache, {name, new_state})
    {:reply, new_selection, new_state}
  end

  # handle_call (msg, from, state) -> {:reply, response, new_state}
  @impl GenServer
  def handle_call(:create_selection, _from, %{selection: selection} = state) do
    {:reply, selection, state}
  end

  @impl GenServer
  def handle_call(:show, _from, %{sflist: sflist} = state) do
    {:reply, sflist, state}
  end

  @impl GenServer
  def handle_call(:lock?, _from, %{lock: lock} = state) do
    {:reply, lock, state}
  end

end
