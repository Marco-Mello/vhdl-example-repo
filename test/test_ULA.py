import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_dut_add(dut):
    """Testar a soma da entradaA com a entradaB"""
    dut.entradaA.value = 0b01111111  # 127
    dut.entradaB.value = 0b00000001  # 1
    dut.seletor.value = 0b01

    # Aguarda alguns ciclos de simulação (ajuste conforme necessário)
    await Timer(1, units="ns")  # Espera a propagação

    expected = 0b10000000  # valor binário nativo (inteiro)
    got = int(dut.saida_s.value.binstr, 2)  # converte string binária → inteiro

    assert got == expected, (
        f"Erro: a={dut.entradaA.value.binstr.zfill(8)}, "
        f"b={dut.entradaB.value.binstr.zfill(8)}, "
        f"esperado={format(expected, '08b')} ({expected}), "
        f"obtido={dut.saida_s.value.binstr.zfill(8)} ({got})"
    )
    
    pass

@cocotb.test()
async def test_dut_sub(dut):
    """Testar a subtracao da entradaA com a entradaB"""
    dut.entradaA.value = 0b01111111  # 127
    dut.entradaB.value = 0b00000001  # 1
    dut.seletor.value = 0b00

    # Aguarda alguns ciclos de simulação (ajuste conforme necessário)
    await Timer(1, units="ns")  # Espera a propagação

    expected = 0b01111110  # valor binário nativo (inteiro)
    got = int(dut.saida_s.value.binstr, 2)  # converte string binária → inteiro

    assert got == expected, (
        f"Erro: a={dut.entradaA.value.binstr.zfill(8)}, "
        f"b={dut.entradaB.value.binstr.zfill(8)}, "
        f"esperado={format(expected, '08b')} ({expected}), "
        f"obtido={dut.saida_s.value.binstr.zfill(8)} ({got})"
    )
    pass

@cocotb.test()
async def test_dut_pass_b(dut):
    """Testar a passa da entradaA com a entradaB"""
    dut.entradaA.value = 0b01111111  # 127
    dut.entradaB.value = 0b00000001  # 1
    dut.seletor.value = 0b10

    # Aguarda alguns ciclos de simulação (ajuste conforme necessário)
    await Timer(1, units="ns")  # Espera a propagação

    expected = 0b00000001  # valor binário nativo (inteiro)
    got = int(dut.saida_s.value.binstr, 2)  # converte string binária → inteiro

    assert got == expected, (
        f"Erro: a={dut.entradaA.value.binstr.zfill(8)}, "
        f"b={dut.entradaB.value.binstr.zfill(8)}, "
        f"esperado={format(expected, '08b')} ({expected}), "
        f"obtido={dut.saida_s.value.binstr.zfill(8)} ({got})"
    )
    pass

@cocotb.test()
async def test_dut_flag(dut):
    """Testar quando a operação for sub e flag zero"""
    dut.entradaA.value = 0b00000001  # 1
    dut.entradaB.value = 0b00000001  # 1
    dut.seletor.value = 0b00

    # Aguarda alguns ciclos de simulação (ajuste conforme necessário)
    await Timer(1, units="ns")  # Espera a propagação

    expected = 0b00000000  # valor binário nativo (inteiro)
    got = int(dut.saida_s.value.binstr, 2)  # converte string binária → inteiro

    assert got == expected, (
        f"Erro: a={dut.entradaA.value.binstr.zfill(8)}, "
        f"b={dut.entradaB.value.binstr.zfill(8)}, "
        f"esperado={format(expected, '08b')} ({expected}), "
        f"obtido={dut.saida_s.value.binstr.zfill(8)} ({got})"
    )
    pass