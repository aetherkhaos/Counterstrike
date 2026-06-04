what's in a model?{{{
	consists of learned weights and files that tell runtime how to use them
	weights are tensors: large, multi-dimensional arrays of numbers
	tokenizer files define how text becomes token ids and back again
}}}
open weights vs model formats{{{
	open weights means weight files are downloadable; not automatially open-source
	safetensors stores tensor weights without arbitrary code exec durring load
	pytorch checkpoint formats are common but req supply-chain caution when untrusted
}}}
local runtime tools{{{
	ollama - local model with webUI
	llama.cpp - efficient local inference especially for GGUF models
	LM studio - desktop tool for experimenting with local endpoints
	Open WebUI - for connecting to local and remote endpoints
}}}
shared serving stacks{{{
	vLLM and text generation interface (tgi) are built for high-thruput serving
	OpenAI-compatible APIs provide clients with common interface
	Docker Compose can define interface, UI, vector store, and supporting svcs
}}}
Resources{{{
	[Hugging Face – The AI community building the future.](https://huggingface.co/)
	
}}}