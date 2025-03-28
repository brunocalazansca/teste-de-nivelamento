from flask import Flask, request, jsonify
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

df = pd.read_csv("../Relatorio_cadop.csv", sep=";", dtype=str, on_bad_lines="skip")

@app.route("/buscar", methods=["GET"])
def buscar_operadoras():
    termo = request.args.get("termo", "").lower()

    if not termo:
        return jsonify([])

    resultados = df[df["Razao_Social"].str.lower().str.contains(termo, na=False)]

    return jsonify(resultados.to_dict(orient="records"))

if __name__ == "__main__":
    app.run(debug=True)
