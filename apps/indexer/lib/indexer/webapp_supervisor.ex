defmodule Indexer.WebappSupervisor do
  @moduledoc """
  Supervisor of all indexer worker supervision trees
  """

  use Supervisor

  alias Indexer.Fetcher.{
    CoinBalanceOnDemand,
    TokenTotalSupplyOnDemand
  }

  def child_spec([]) do
    child_spec([[]])
  end

  def child_spec([init_arguments]) do
    child_spec([init_arguments, []])
  end

  def child_spec([_init_arguments, _gen_server_options] = start_link_arguments) do
    default = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, start_link_arguments},
      type: :supervisor
    }

    Supervisor.child_spec(default, [])
  end

  def start_link(arguments, gen_server_options \\ []) do
    Supervisor.start_link(
      __MODULE__,
      arguments,
      Keyword.put_new(gen_server_options, :name, __MODULE__)
    )
  end

  @impl Supervisor
  def init(%{memory_monitor: memory_monitor}) do
    json_rpc_named_arguments = Application.fetch_env!(:indexer, :json_rpc_named_arguments)

    named_arguments =
      :indexer
      |> Application.get_all_env()
      |> Keyword.take(
        ~w(blocks_batch_size blocks_concurrency block_interval json_rpc_named_arguments receipts_batch_size
           receipts_concurrency subscribe_named_arguments realtime_overrides)a
      )
      |> Enum.into(%{})
      |> Map.put(:memory_monitor, memory_monitor)
      |> Map.put_new(:realtime_overrides, %{})

    %{
      block_interval: _block_interval,
      realtime_overrides: _realtime_overrides,
      subscribe_named_arguments: _subscribe_named_arguments
    } = named_arguments

    fetchers = [
      {CoinBalanceOnDemand.Supervisor, [json_rpc_named_arguments]},
      {TokenTotalSupplyOnDemand.Supervisor, [json_rpc_named_arguments]}
    ]

    Supervisor.init(
      fetchers,
      strategy: :one_for_one
    )
  end
end
