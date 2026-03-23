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

The script loads `.env` automatically via `python-dotenv`.

Alternatively, export the variable in your shell.

## Install (optional)

Adds `trans` to your PATH via a symlink in `~/.local/bin`:

```bash
./install.sh
```

Then open a new terminal, or run `source ~/.bashrc` to apply immediately.

To uninstall:

```bash
./uninstall.sh
```

## Usage

```bash
trans audio.mp3
trans part_00.mp3 part_01.mp3 part_02.mp3
trans part_*.mp3
trans audio.mp3 --lang en
trans audio.mp3 -o result.txt
```

Or without installing:

```bash
./trans audio.mp3
```

Output is written to `transcript.txt` by default.
