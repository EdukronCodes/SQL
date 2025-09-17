import pandas as pd
import chromadb
from sklearn.feature_extraction.text import TfidfVectorizer
from gtts import gTTS
import os
import tempfile

df = pd.read_excel("aws_faq.xlsx")
df.dropna(subset=["Question", "Answer"], inplace=True,axis=0)
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(df["Question"].tolist())
embeddings = X.toarray().tolist()

client = chromadb.Client()
collection = client.create_collection(name="aws_faqs", metadata={"hnsw:space": "cosine"})

collection.add(
    documents=df["Question"].tolist(),
    embeddings=embeddings,
    metadatas=[{"answer": ans} for ans in df["Answer"].tolist()],
    ids=[f"faq{i}" for i in range(len(df))]
)

def aws_chatbot(query, top_k=1):
    query_vec = vectorizer.transform([query]).toarray().tolist()
    results = collection.query(query_embeddings=query_vec, n_results=top_k)
    best_question = results["documents"][0][0]
    best_answer = results["metadatas"][0][0]["answer"]
    print("❓ User:", query)
    print("🤖 Bot:", best_answer)
    tts = gTTS(text=best_answer, lang="en")
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as fp:
        temp_file = fp.name
    tts.save(temp_file)
    if os.name == "nt":
        os.system(f"start {temp_file}")
    elif os.name == "posix":
        os.system(f"afplay {temp_file}" if os.uname().sysname == "Darwin" else f"mpg123 {temp_file}")
    return best_question, best_answer

queries = [
    "Tell me about EC2 compute service",
    "How do I start using EC2?",
    "Why does AWS need my phone number?"
]

for q in queries:
    aws_chatbot(q)
    print("-" * 60)
