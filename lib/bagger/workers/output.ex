defmodule Bagger.Workers.Output do
  @moduledoc """
  This process is responsible for generating the output for the `Bagger`.
  This will show the results of a specific test and training cycle. The output
  layer is essentialy the communication layer to the outside world of the network.
  All the code associated to how `Bagger` generates its output can be listed
  here.

  The `Bagger` has two bags for the groceries
  - Hot Bag
  - Cold Bag

  This it shows the contents of the bags to the user
  """

  use GenServer

  #########
  #  API  #
  #########

  @doc """
  Starts the Output Process.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [hot_bag: [], cold_bag: []], [name: __MODULE__])
  end

  @doc """
  Classifies a hot item and adds it to the hot bag
  """
  def classify(1, item) do
    GenServer.cast(__MODULE__, {:hot, item})
  end

  @doc """
  Classifies a cold item and adds it to the cold bag
  """
  def classify(0, item) do
    GenServer.cast(__MODULE__, {:cold, item})
  end

  @doc """
  Shows the contents of the bag to the user
  """
  def show do
    GenServer.call(__MODULE__, :show)
  end

  ##################
  # IMPLEMENTATION #
  ##################

  def init(classifiers) do
    {:ok, classifiers}
  end

  def handle_call(:show, _from, state) do
    make_report(state)
    System.cmd("open", ["bagger_report.html"])
    {:reply, "Bagging Completed.", state}
  end

  def handle_cast({:hot, item}, state) do
    result = Keyword.update!(state, :hot_bag, fn(items) -> [item | items] end)
    {:noreply, result}
  end

  def handle_cast({:cold, item}, state) do
    result = Keyword.update!(state, :cold_bag, fn(items) -> [item | items] end)
    {:noreply, result}
  end

  defp make_report(state) do
    contents = EEx.eval_file("lib/bagger/template/bagger_report.eex",
      [
        hot_items: Keyword.fetch!(state, :hot_bag),
        cold_items: Keyword.fetch!(state, :cold_bag)
      ])
    File.write!("bagger_report.html", contents, [:write])
  end
end
