1. Architecture Brief
Ollama (harness) running qwen3.5:0.8b (model)
Docker Desktop(container manager) running open-webUI (web interface for ai model)

2. Working local interface
```
PS C:\Users\xAdministrator> ollama run qwen3.5:0.8b
pulling manifest
pulling manifest
pulling afb707b6b8fa: 100% ▕████████████████████████████████████████▏ 1.0 GB
pulling 9be69ef46306: 100% ▕████████████████████████████████████████▏  11 KB
pulling 9371364b27a5: 100% ▕████████████████████████████████████████▏   65 B
pulling b14c6eab49f9: 100% ▕████████████████████████████████████████▏  476 B
verifying sha256 digest
writing manifest
success
>>> hi
Thinking...
Okay, the user just said "hi". That's a simple greeting. Let me make sure I understand right.
They might just want me to respond with a friendly greeting. I should keep it warm and open for
them to ask more. No need to overthink it. Just respond with "Hello! How can I assist you
today?" and invite them to continue. Let me check the policy again. The system instructions say
to avoid instructions that could be harmful, etc. Greetings are fine. No specific policies to
follow beyond standard interactions. So the response should be friendly and open-ended.
...done thinking.

Hello! How can I assist you today? 😊

>>> Send a message (/? for help)
```

3. Open WebUI connection to local model
```
### USER
*   Hello there

### ASSISTANT
Who can I help you with today? 🌟
```

4. connect with Gen.AI
5. 