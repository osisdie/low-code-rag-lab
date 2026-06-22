"""把 knowledge-base 灌進 LightRAG，建立知識圖譜 + 向量索引。

用法：
    python ingest.py                 # 灌入預設三份知識庫
    python ingest.py path/to/a.md    # 指定檔案

灌完後，rag_storage/ 會出現實體、關係與向量索引檔；
之後啟動 adapter（dify_retrieval_adapter.py）即可被 Dify 查詢。
"""
import asyncio
import sys
from pathlib import Path

from rag_factory import build_rag

# 預設灌入的知識庫（相對於本檔）
DEFAULT_DOCS = [
    "../knowledge-base/coffee-catalog-relationships.md",  # 關係型資料：圖譜威力主場
    "../knowledge-base/ecommerce-return-sop.md",
    "../knowledge-base/restaurant-faq.md",
]


async def main(paths):
    rag = await build_rag()
    base = Path(__file__).parent
    for p in paths:
        fp = (base / p).resolve()
        if not fp.exists():
            print(f"⚠️  找不到檔案，略過：{fp}")
            continue
        text = fp.read_text(encoding="utf-8")
        print(f"📥 灌入：{fp.name}（{len(text)} 字）… 抽取實體關係中，請稍候")
        await rag.ainsert(text)
        print(f"✅ 完成：{fp.name}")
    print("\n🎉 全部灌入完成。圖譜與向量索引已寫入 rag_storage/")
    print("   下一步：啟動 adapter →  uvicorn dify_retrieval_adapter:app --host 0.0.0.0 --port 8000")


if __name__ == "__main__":
    docs = sys.argv[1:] or DEFAULT_DOCS
    asyncio.run(main(docs))
