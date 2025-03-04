import torch

def hello() -> None:
    print("Hello from hello-world!")
    print("CUDA available:", torch.cuda.is_available())

    if torch.cuda.is_available():
        device = torch.device("cuda")
        print("Using GPU:", torch.cuda.get_device_name(0))

        # Define two numbers as tensors on GPU
        a = torch.tensor([2.0], device=device)
        b = torch.tensor([4.0], device=device)

        # Perform multiplication on GPU
        result = a * b

        print(f"Multiplication result: {a.item()} * {b.item()} = {result.item()}")
        print("Tensor device:", result.device)
    else:
        print("CUDA is not available. Using CPU.")
