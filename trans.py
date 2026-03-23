import argparse
import math
import sys
import threading
import time
from mutagen import File as AudioFile
from openai import OpenAI

WHISPER_COST_PER_MINUTE = 0.006  # USD


def get_duration_seconds(filepath):
    audio = AudioFile(filepath)
    if audio is None:
        raise ValueError(f"Cannot read audio metadata: {filepath}")
    return audio.info.length


parser = argparse.ArgumentParser(description="Transcribe audio files using Whisper")
parser.add_argument("files", nargs="+", help="Audio file(s) to transcribe")
args = parser.parse_args()

total_seconds = sum(get_duration_seconds(f) for f in args.files)
total_minutes = math.ceil(total_seconds / 60)
estimated_cost = total_minutes * WHISPER_COST_PER_MINUTE

print(f"Estimated cost: ~${estimated_cost:.4f}  ({total_minutes} min @ ${WHISPER_COST_PER_MINUTE}/min)")
confirm = input("Proceed? [y/N] ").strip().lower()
if confirm != "y":
    print("Aborted.")
    sys.exit(0)

client = OpenAI()
full_text = []

for i, part in enumerate(args.files):
    print(f"\n📂 File {i+1}/{len(args.files)}: {part}")

    stop = threading.Event()

    def spinner(stop_event):
        start = time.time()
        while not stop_event.is_set():
            print(f"\r⏳ Transcribing... {int(time.time()-start)}s",
                  end="", flush=True)
            time.sleep(1)
        print()

    t = threading.Thread(target=spinner, args=(stop,))
    t.start()

    try:
        with open(part, "rb") as f:
            result = client.audio.transcriptions.create(
                model="whisper-1",
                file=f,
                language="uk",
                response_format="text"
            )
    finally:
        stop.set()
        t.join()

    full_text.append(result)

with open("transcript.txt", "w") as out:
    out.write("\n\n".join(full_text))

print("✅ Done → transcript.txt")
