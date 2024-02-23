defmodule Explorer.CustomContractsHelpers do
  @moduledoc """
  Helpers to enable custom contracts themes
  """

  @address_list_file File.read!("config/address_list.json")

  @address_list_map @address_list_file |> Poison.decode!()

  @official_token_list @address_list_map |> Map.get("official_token")

  @black_list @address_list_map |> Map.get("black_list")

  @white_list @address_list_map |> Map.get("white_list")

  @phenix_finance_hacker_list @address_list_map |> Map.get("phenix_finance_hacker")

  @suspicious_list @address_list_map |> Map.get("suspicious_list")

  def is_in_black_list(address, symbol) do
    result =
      cond do
        "#{address}" in @white_list -> false
        "#{address}" in @black_list -> true
        # only official one is false(in the white list)
        "#{symbol}" == "VVS" -> true
        true -> false
      end

    result
  end

  def is_official_token(address) do
    result =
      if @official_token_list != nil do
        "#{address}" in @official_token_list
      else
        false
      end

    result
  end

  def is_luna(address, name) do
    result =
      if String.downcase("#{address}") == "0x9278c8693e7328bef49804bacbfb63253565dffd" do
        "LUNC"
      else
        name
      end

    result
  end

  def is_phenix_hacker(address) do
    if @phenix_finance_hacker_list != nil do
      String.downcase("#{address}") in @phenix_finance_hacker_list
    else
      false
    end
  end

  def is_suspicious_address(address) do
    if @suspicious_list != nil do
      String.downcase("#{address}") in @suspicious_list
    else
      false
    end
  end

  def phenix_hacker_index(address) do
    if String.downcase("#{address}") in @phenix_finance_hacker_list do
      index_of(String.downcase("#{address}"), @phenix_finance_hacker_list)
    else
      ""
    end
  end

  def index_of(value, list) do
    map = :lists.zip(list, :lists.seq(1, length(list)))

    case :dict.find(value, :dict.from_list(map)) do
      {:ok, index} -> index
      _ -> ""
    end
  end

  def get_custom_addresses_list(env_var) do
    addresses_var = get_raw_custom_addresses_list(env_var)
    addresses_list = (addresses_var && String.split(addresses_var, ",")) || []

    formatted_addresses_list =
      addresses_list
      |> Enum.map(fn addr ->
        String.downcase(addr)
      end)

    formatted_addresses_list
  end

  def get_raw_custom_addresses_list(env_var) do
    Application.get_env(:block_scout_web, env_var)
  end
end
