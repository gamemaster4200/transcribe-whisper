# transcribe

Transcribes audio files to text using OpenAI Whisper API.

Accepts one or more audio files as arguments and writes the result to `transcript.txt`.

## Requirements

- Python 3.10+
- OpenAI API key

## Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Create a `.env` file with your API key:

```
OPENAI_API_KEY=sk-...
```

## Usage

```bash
python trans.py audio.mp3
python trans.py part_00.mp3 part_01.mp3 part_02.mp3
python trans.py part_*.mp3
```

Output is written to `transcript.txt`.
