defmodule Virtual8086Test do
  use ExUnit.Case
  doctest Virtual8086

  test "dissassembles single register mov" do
    reference_binary = File.read!("test/single_register_mov")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  test "dissassembles many register mov" do
    reference_binary = File.read!("test/many_register_mov")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  test "dissassembles 8 bit immediate to register mov" do
    reference_binary = File.read!("test/8_bit_immediate_to_register")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  test "dissassembles 16 bit immediate to register mov" do
    reference_binary = File.read!("test/16_bit_immediate_to_register")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  test "dissassembles movs with source address calculation" do
    reference_binary = File.read!("test/source_address_calculation")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  test "dissassembles movs with destination address calculation" do
    reference_binary = File.read!("test/dest_address_calculation")

    test_binary =
      Virtual8086.disassemble(reference_binary)
      |> recompile()

    assert test_binary == reference_binary

    clean_up()
  end

  defp recompile(assembly) do
    File.write!("test/test.asm", assembly)
    System.cmd("nasm", ["test/test.asm"])
    File.read!("test/test")
  end

  defp clean_up() do
    File.rm!("test/test.asm")
    File.rm!("test/test")
  end
end
