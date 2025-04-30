import random
from datetime import datetime

def generate_vector(op_type):
    # Gera A (não zero)
    a = random.randint(1, 255)
    
    # Gera B e calcula resultado e carry de acordo com a operação
    if op_type == "ADD":
        b = random.randint(1, min(255, a))
        full_result = a + b
        result = full_result & 0xFF
        carry = 1 if full_result > 255 else 0
        op_code = 0
    elif op_type == "SUB":
        b = random.randint(1, a)  # B <= A para evitar borrow
        result = (a - b) & 0xFF
        carry = 0  # Carry sempre 0 na subtração (complemento de 2)
        op_code = 1
    elif op_type == "MUL":
        b = random.randint(1, min(255, a))
        full_result = a * b
        result = full_result & 0xFF
        carry = 0  # Carry sempre 0 na multiplicação (complemento de 2)
        op_code = 2
    else:  # DIV
        b = random.randint(1, a)  # B não zero e <= A
        result = a // b
        carry = 0  # Divisão não usa carry
        op_code = 3
    
    return f"{op_code:X} {a:02X} {b:02X} {result:02X} {carry} // {op_type}"

# Gera o arquivo de vetores
with open("ULA_vectors.txt", "w") as f:
    
    # Gera 25 vetores para cada operação
    operations = ["ADD", "SUB", "MUL", "DIV"]
    for op in operations:
        f.write(f"\n// {op} Operations\n")
        for _ in range(25):
            f.write(generate_vector(op) + "\n")

print("Arquivo de vetores gerado com sucesso!")

