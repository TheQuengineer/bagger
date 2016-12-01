defmodule Bagger.Supervisors.LayerOne do
  @moduledoc """
  The layer one Supervisor is responsible for all the neurons in the first layer.
  As a result when the `Bagger` application starts the supervisor will create
  the new Neuron and link itself to the child.
  """
  use Supervisor

  @doc """
  Starts the first layer which is a `Supervisor` process. By default it
  creates one Neuron. Within the Layer.
  """
  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init([]) do
    children = [
      worker(Bagger.Workers.Neuron, [], [function: :new])
    ]
    supervise(children, [strategy: :one_for_one])
  end
end
