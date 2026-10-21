from data import LavicDataLoader
import os, json

print("exists data/lavic/item2meta.json:", os.path.exists("data/lavic/item2meta.json"))
print("exists data/lavic/all_beauty/test.jsonl:", os.path.exists("data/lavic/all_beauty/test.jsonl"))
print("exists data/lavic/all_beauty/all_item_ids.json:", os.path.exists("data/lavic/all_beauty/all_item_ids.json"))

loader = LavicDataLoader('./data/lavic', 'all_beauty', 'test')
loader.load_data()
print("item_db:", len(loader.item_db))
print("conversations:", len(loader.conversations))

if loader.item_db:
    k = next(iter(loader.item_db))
    print("sample item id:", k)
    print("sample main_category:", loader.item_db[k].get("main_category"))

loader.extract_attributes()
print("items:", len(loader.items))

texts = loader.get_item_texts()
print("texts:", len(texts))