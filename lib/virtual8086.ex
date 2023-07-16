defmodule Virtual8086 do
  @moduledoc """
  Documentation for `Virtual8086`.
  """

  @byte_registers %{
    000 => "al",
    001 => "cl",
    010 => "dl",
    011 => "bl",
    100 => "ah",
    101 => "ch",
    110 => "dh",
    111 => "bh",
  }

  @word_registers %{
    000 => "ax",
    001 => "cx",
    010 => "dx",
    011 => "bx",
    100 => "sp",
    101 => "bp",
    110 => "si",
    111 => "di",
  }

  @effective_addresses_memory_mode_no_displacement %{
    000 =>"[bx + si]",
    001 =>"[bx + di]",
    010 =>"[bp + si]",
    011 =>"[bp + di]",
    100 =>"[si]",
    101 =>"[di]",
    111 =>"[bx]",
  }

  @effective_addresses_memory_mode_8_bit_displacement %{
    000 =>"bx + si",
    001 =>"bx + di",
    010 =>"bp + si",
    011 =>"bp + si",
    100 =>"si",
    101 =>"di",
    110 =>"bp",
    111 =>"bx",
  }

  @mov_register_to_register Instructions.Mov.RegisterToRegister
  @mov_immediate_to_register Instructions.Mov.ImmediateToRegister
  @mov_memory_to_from_register Instructions.Mov.MemoryToFromRegister

  def disassemble(binary_stream) do
    assembly = ["bits 16\n\n"]

    do_disassemble(%{assembly: assembly, remaining_binary: binary_stream})
    |> Enum.join()
  end

  defp do_disassemble(%{assembly: assembly, remaining_binary: <<>>}), do: assembly
  defp do_disassemble(%{assembly: assembly, remaining_binary: binary_stream}) do
    {instruction, binary} = parse_instruction(binary_stream)

    instruction.decode(binary)
    |> append_to_assembly(assembly)
    |> do_disassemble()
  end

  # Register to Register Mov
  defp parse_instruction(<<0b100010::6, d_and_w_fields::2, 0b011::2, rest::bits>>) do
    <<binary::bits>> = <<d_and_w_fields::2, 0b011::2, rest::bits>>
    {@mov_register_to_register, binary}
  end

  # Memory To/From Register Mov
  defp parse_instruction(<<0b100010::6, rest::bits>>) do
    {@mov_memory_to_from_register, rest}
  end

  # Immediate to Register Mov
  defp parse_instruction(<<0b1011::4, rest::bits>>) do
    {@mov_immediate_to_register, rest}
  end

  defp append_to_assembly(instruction, assembly) do
    %{assembly: assembly ++ [instruction[:assembly]], remaining_binary: instruction[:remaining_binary]}
  end

  def byte_registers, do: @byte_registers

  def word_registers, do: @word_registers

  def effective_addresses_memory_mode_no_displacement, do: @effective_addresses_memory_mode_no_displacement

  def effective_addresses_memory_mode_8_bit_displacement, do: @effective_addresses_memory_mode_8_bit_displacement
end
