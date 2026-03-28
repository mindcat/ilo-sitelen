import os
import toml
import json
import requests
from bs4 import BeautifulSoup

TOML_LIST_PATH = "../tp-dataset/categories/typst.toml"
WORDS_DIR = "../tp-dataset/words"

OUTPUT_JSON = "sona/sona.json"
AUDIO_DIR = "sona/kute"
VIDEO_DIR = "sona/luka-pona"

os.makedirs(AUDIO_DIR, exist_ok=True)
os.makedirs(VIDEO_DIR, exist_ok=True)

print("Fetching Linku API data...")
linku_words = requests.get("https://api.linku.la/v2/words").json()
luka_pona_signs = requests.get("https://api.linku.la/v2/luka_pona/signs").json()

print("Fetching lipamanka semantic spaces...")
lipamanka_html = requests.get("https://lipamanka.gay/essays/dictionary").text
soup = BeautifulSoup(lipamanka_html, 'html.parser')

def get_semantic_space(lemma):
    header = soup.find(id=lemma)
    if not header:
        return None
    content = []
    current = header.find_next_sibling()
    while current and current.name not in ['h2', 'h3', 'h4']:
        if current.name == 'p':
            content.append(current.get_text(strip=True))
        current = current.find_next_sibling()
    return "\n\n".join(content) if content else None

def download_file(url, filepath):
    if not os.path.exists(filepath):
        print(f"  Downloading: {filepath}")
        try:
            response = requests.get(url)
            if response.status_code == 200:
                with open(filepath, 'wb') as f:
                    f.write(response.content)
        except Exception as e:
            print(f"  Failed to download {url}: {e}")

def mock_download_file(url, filepath):
    print(f"    [MOCK] Would download: {url}")
    print(f"    [MOCK] Would save to:  {filepath}")

target_files = [f for f in os.listdir(WORDS_DIR) if f.endswith('.toml')]

missing = []

app_dictionary = []

print(f"\nFound {len(linku_words)} words in Linku API vs {len(target_files)} in tp-dataset. Starting dry run...\n")
print("-" * 50)

# every word from the api (we wont be saving obscure ones, though)
for lemma, linku_data in linku_words.items():
    print(f"Processing: {lemma}")
    local_toml = True

    local_data = {}
    toml_path = os.path.join(WORDS_DIR, f"{lemma}.toml")
    if os.path.exists(toml_path):
        try:
            with open(toml_path, 'r', encoding='utf-8') as f:
                local_data = toml.load(f)
        except Exception as e:
            print(f"    Error reading local TOML for {lemma}: {e}")
    else:
        print(f"    (No local TOML found for {lemma}, core fields will be null)")
        local_toml = False


    usage = linku_data.get("usage_category", "")

    # if usage is not "obscure":
    #     if (lemma + ".toml") not in target_files:
    #         missing.append(lemma)

    ku_raw = linku_data.get("ku_data", {})
    ku_sorted = [{"translation": k, "percentage": v} for k, v in sorted(ku_raw.items(), key=lambda item: item[1], reverse=True)]


    definition = linku_data.get("translations", {}).get("definition", "")
    commentary = linku_data.get("translations", {}).get("commentary", "")

    # Audio
    audio_file = None
    for audio in linku_data.get("audio", []):
        if "kala Asi" in audio.get("author", ""):
            audio_url = audio["link"]
            audio_file = f"{lemma}.mp3"
            mock_download_file(audio_url, os.path.join(AUDIO_DIR, audio_file))
            break

    semantic_space = get_semantic_space(lemma)

    # luka pona
    signs = []
    for sign_id, sign_data in luka_pona_signs.items():
        definitions = [d.strip() for d in sign_data.get("definition", "").split(",")]
        if lemma in definitions:
            mp4_url = sign_data.get("video", {}).get("mp4")
            mp4_file = None

            if mp4_url:
                mp4_file = f"{lemma}.mp4"
                download_file(mp4_url, os.path.join(VIDEO_DIR, mp4_file))

            signs.append({
                "id": sign_id,
                "twohands": sign_data.get("is_two_handed", False),
                "mp4": mp4_file,
                "etymology": sign_data.get("etymology", []),
                "icons": sign_data.get("translations", {}).get("icons"),
                "parameters": sign_data.get("translations", {}).get("parameters", {})
            })

    if local_toml:
    # depending on whether it is yet added locally (i still need to make .tomls for ['ali', 'epiku', 'lanpan', 'linluwi', 'majuna', 'nimisin', 'oko'])
        word_obj = {
            "lemma": lemma,
            "sitelenpona": local_data.get("sitelenpona"),
            "origin": local_data.get("origin"),
            "script": local_data.get("script"),
            "categories": local_data.get("categories"),
            "definitions": local_data.get("definitions"),
            "definition_long": definition,
            "commentary": commentary,
            "usage": usage,
            "ku": ku_sorted,
            "audio": audio_file,
            "semantic": semantic_space,
            "lukaPonaSigns": signs
        }
    else:
        raw_source = linku_data.get("source_language", "")
        word_obj = {
            "lemma": lemma,
            "sitelenpona": [lemma],
            "origin": {"iso": raw_source} if raw_source else None,
            "script": local_data.get("script"),
            "categories": local_data.get("categories"),
            "definitions": {"en": definition} if definition else None,
            "definition_long": definition,
            "commentary": commentary,
            "usage": usage,
            "ku": ku_sorted,
            "audio": audio_file,
            "semantic": semantic_space,
            "lukaPonaSigns": signs
        }

    if not (usage == "obscure"):
        print(json.dumps(word_obj, ensure_ascii=False, indent=2))
        print("-" * 50)
        app_dictionary.append(word_obj)
        if (lemma + ".toml") not in target_files:
            missing.append(lemma)


app_dictionary.sort(key=lambda x: x["lemma"])
print(app_dictionary)

print("making sona.json...")
with open(OUTPUT_JSON, 'w', encoding='utf-8') as f:
    json.dump(app_dictionary, f, ensure_ascii=False, indent=2)

print("words not in tp-dataset:")
print(missing)

print("put resources in xcode...")
