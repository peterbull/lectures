import torch

compiled_square = torch.compile(torch.square)

input_tensor = torch.tensor([1.0, 2.0, 3.0])
result = compiled_square(input_tensor)

print(f"Input: {input_tensor}")
print(f"Result: {result}")
