defmodule Explorer.CustomContractsHelpers do
  @moduledoc """
  Helpers to enable custom contracts themes
  """

  @black_list  [
    "0x9C594FaEc60c60b05BAF77a958749eFC78206B02",
    "0xeDD8627e171e4ed11120094633fD82ac7eCe6ebc",
    "0x185F0c2f49BCB1D47D671B0a5Cd3D0B54c5F0692",
    "0x32f61686331D4c3F1d15EcCd25Cb5c9323B873c6",
    "0x5D9ec21ea6B7a90943377424EdD6e81F843bBD26",
    "0x814920D1b8007207db6cB5a2dD92bF0b082BDBa1"
  ]

  @white_list [
    "0x5C7F8A570d578ED84E63fdFA7b1eE72dEae1AE23",
    "0x3b44b2a187a7b3824131f8db5a74194d0a42fc15",
    "0x145863Eb42Cf62847A6Ca784e6416C1682b1b2Ae",
    "0x6a2d178585806De5A2e5E7F9acFCE44680637284",
    "0xDccd6455AE04b03d785F12196B492b18129564bc",
    "0x5e954f5972EC6BFc7dECd75779F10d848230345F",
    "0xA6fF77fC8E839679D4F7408E8988B564dE1A2dcD",
    "0x025322f210e6a7546C3F080325eDbE692B25C1Ea",
    "0xe61Db569E231B3f5530168Aa2C9D50246525b6d6",
    "0xA111C17f8B8303280d3EB01BBcd61000AA7F39F9",
    "0xbf62c67eA509E86F07c8c69d0286C0636C50270b",
    "0x8F09fFf247B8fDB80461E5Cf5E82dD1aE2EBd6d7",
    "0xfd0Cd0C651569D1e2e3c768AC0FFDAB3C8F4844f",
    "0x2D03bECE6747ADC00E1a131BBA1469C15fD11e03",
    "0xe44Fd7fCb2b1581822D0c862B68222998a0c299a",
    "0x062E66477Faf219F25D27dCED647BF57C3107d52",
    "0xc21223249CA28397B4B6541dfFaEcC539BfF0c59",
    "0x66e428c3f67a68878562e79A0234c1F83c208770",
    "0xF2001B145b43032AAF5Ee2884e456CCd805F677D"
  ]

  def is_in_black_list(address) do
    result = cond do
      "#{address}" in @white_list ->
        false
      "#{address}" in @black_list ->
        true
      true ->
        false
    end
    result
  end

  def is_verified_address(address) do
    result = "#{address}" in @white_list
    result
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
