defmodule SecretFriends.Worker.SFWorker do
  use GenServer
  alias SecretFriends.Core.SFList

  # start server
  def start_link(name) do
    # MFA (module - function - arguments)
    GenServer.start_link(__MODULE__, %{sflist: SFList.new(), selection: nil, lock: false}, name: name)
  end

  @impl GenServer
  def init(state) do
    {:ok, state}
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
  def handle_cast(:lock, state) do
    {:noreply, %{state | lock: true}}
  end

  @impl GenServer
  def handle_cast(:unlock, state) do
    {:noreply, %{state | lock: false}}
  end

  # handle_call (msg, from, state) -> {:reply, response, new_state}
  @impl GenServer
  def handle_call(:create_selection, _from, %{sflist: sflist} = state) do
    new_selection = SFList.create_selection(sflist)
    {:reply, new_selection, %{state | sflist: sflist, selection: new_selection}}
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
