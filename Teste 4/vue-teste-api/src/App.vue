<template>
  <div id="app">
    <h1>Buscar Operadoras</h1>
    <input v-model="busca" @keyup.enter="buscarOperadoras" placeholder="Digite o registro da operadora" />
    <button @click="buscarOperadoras">Buscar</button>

    <div v-if="isLoading">Carregando...</div>

    <table v-if="!isLoading && operadoras.length > 0">
      <thead>
        <tr>
          <th>Razão Social</th>
          <th>Nome Fantasia</th>
          <th>CNPJ</th>
          <th>Representante</th>
          <th>Cidade</th>
          <th>UF</th>
          <th>Telefone</th>
          <th>Data de Registro</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="operadora in operadoras" :key="operadora.CNPJ">
          <td>{{ operadora.Razao_Social }}</td>
          <td>{{ operadora.Nome_Fantasia }}</td>
          <td>{{ operadora.CNPJ }}</td>
          <td>{{ operadora.Representante }}</td>
          <td>{{ operadora.Cidade }}</td>
          <td>{{ operadora.UF }}</td>
          <td>{{ operadora.Telefone }}</td>
          <td>{{ operadora.Data_Registro_ANS }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";
import "@/style.css";

export default {
  data() {
    return {
      busca: "",
      operadoras: [],
      isLoading: false,
    };
  },
  methods: {
    async buscarOperadoras() {
      this.operadoras = []

      if (!this.busca) return;

      this.isLoading = true;

      try {
        const response = await axios.get(
          `http://127.0.0.1:5000/buscar?termo=${this.busca}`
        );
        this.operadoras = JSON.parse(response.data.replaceAll("NaN", "null"));
        console.log(this.operadoras.Razao_Social)

      } catch (error) {
        console.error("Erro ao buscar operadoras:", error);

      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>