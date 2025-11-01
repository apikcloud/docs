import hashlib
import json
import os
import pathlib
import subprocess

import openai

SRC = pathlib.Path("docs")
DEST = pathlib.Path("fr-fr")
CACHE_FILE = pathlib.Path(".translation_cache.json")
API_KEY = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=API_KEY)
cache = json.loads(CACHE_FILE.read_text()) if CACHE_FILE.exists() else {}

# get list of changed or new .md files
result = subprocess.run(
    ["git", "ls-files", "-m", "-o", "--exclude-standard", str(SRC)],
    capture_output=True,
    text=True,
    check=True,
)
changed_files = [
    pathlib.Path(line.strip())
    for line in result.stdout.splitlines()
    if line.strip().endswith(".md")
]

print(changed_files)

translated_count = 0
for md in changed_files:
    rel = md.relative_to(SRC)
    out_file = DEST / rel
    out_file.parent.mkdir(parents=True, exist_ok=True)

    text = md.read_text(encoding="utf-8")
    digest = hashlib.sha1(text.encode()).hexdigest()

    if cache.get(str(rel)) == digest:
        print(f"✔ Skipping {rel} (unchanged)")
        continue

    print(f"🔁 Translating {rel}...")
    response = client.chat.completions.create(
        model="gpt-5",
        messages=[
            {
                "role": "system",
                "content": "You are a professional technical translator. Translate the Markdown documentation from English to French, preserving formatting, code blocks, and metadata. Do not translate code.",
            },
            {"role": "user", "content": text},
        ],
        temperature=0.2,
    )
    translated = response.choices[0].message.content
    out_file.write_text(translated, encoding="utf-8")

    cache[str(rel)] = digest
    translated_count += 1

CACHE_FILE.write_text(json.dumps(cache, indent=2))
print(f"✅ Translation complete: {translated_count} file(s) updated")
