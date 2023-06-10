<template>
  <div v-if="!loggedIn" class="login-container">
    <form name="login-form">
      <img src="@/assets/ilovejava.jpg" alt="Logo" class="logo">
      <div class="form-group">
        <label for="userName">Username:</label>
        <input type="text" id="userName" v-model="input.userName" />
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="input.password" />
      </div>
      <button type="submit" v-on:click.prevent="login()">Login</button>
      <p v-if="output" class="error-message">{{ output }}</p>
    </form>
  </div>
</template>


<script>
import axios from 'axios';
import { SET_AUTHENTICATION, SET_USERNAME, SET_ID } from "../store/storeconstants";

export default {
  name: 'LoginView',
  data() {
    return {
      input: {
        userName: "",
        password: ""
      },
      output: "",
      loggedIn: false
    }
  },
  methods: {
    login() {
      //make sure username OR password are not empty
      if (this.input.userName != "" || this.input.userName != "") {

        axios.post('http://localhost:8080/api/login', {
          userName: this.input.userName ,
          password: this.input.password
        })
          .then(response => {
             const token = response.data.bearerToken;
            localStorage.setItem('bearerToken', token); // Store the token in local storage
            console.log(token)
            this.$store.commit(`auth/${SET_AUTHENTICATION}`, true);
            this.$store.commit(`auth/${SET_USERNAME}`, this.input.userName);
            this.$store.commit(`auth/${SET_ID}`, response.data);
            this.loggedIn = true;
            this.$router.push('/home')
          })
          .catch(error => {
            alert("Invalid credentials");
            console.log(error);
            // handle login error, display message to user, etc
          });
        
      } else {
        this.$store.commit(`auth/${SET_AUTHENTICATION}`, false);
        this.output = "Username and password can not be empty"
      }
    },
  },
}
</script>
<style>
.login-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f7f7f7;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.logo {
  display: block;
  margin: 0 auto;
  width: 150px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: inline-block;
  width: 100px;
  font-weight: bold;
}

input[type="text"],
input[type="password"] {
  width: 200px;
  padding: 5px;
  border: 1px solid #ccc;
  border-radius: 3px;
}

button {
  padding: 10px 20px;
  background-color: #333;
  color: #fff;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

button:hover {
  background-color: #555;
}

.error-message {
  color: red;
  font-weight: bold;
}
</style>

