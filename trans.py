import argparse
import threading
import time
from openai import OpenAI

parser = argparse.ArgumentParser(description="Transcribe audio files using Whisper")
parser.add_argument("files", nargs="+", help="Audio file(s) to transcribe")
args = parser.parse_args()

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
