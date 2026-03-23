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

Copy `.env.example` and fill in your API key:

```bash
cp .env.example .env
```

The script loads `.env` automatically via `python-dotenv`, searching in the current directory first, then in the script's own directory.

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

## Testing

```bash
bash tests/smoke.sh
```

Free tests (`--help`, `--dry-run`) run immediately. API tests require confirmation and cost money.

## Options

- `--help` / `-h` — show help message and exit
- `--output` / `-o` — output file (default: `transcript.txt`)
- `--lang` — language code (default: `uk`)
- `--model` — Whisper model (default: `whisper-1`)
- `--live` — print each transcript immediately after processing
- `--dry-run` / `-n` — estimate cost only, do not transcribe
- `--yes` / `-y` — skip confirmation prompt
- `--quiet` / `-q` — suppress all output except errors (implies `--yes`)

## Examples

```bash
trans audio.mp3
trans part_00.mp3 part_01.mp3 part_02.mp3
trans part_*.mp3
trans audio.mp3 --lang en
trans audio.mp3 -o result.txt
trans audio.mp3 --model whisper-1
trans audio.mp3 --live
trans audio.mp3 -n
trans part_*.mp3 --lang en --live -o result.txt
trans part_*.mp3 -y --live
```

Or without installing:

```bash
./trans audio.mp3
```

Output is written to `transcript.txt` by default.
