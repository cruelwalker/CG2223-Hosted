<template>
    <nav>
    <ul>
      <!--<li><router-link to="/disclaimers">Disclaimers</router-link></li>-->
      <li><router-link to="/users">User</router-link></li>
      <li><router-link to="/transactions">Transactions</router-link></li>
      <li><router-link to="/accounts">Accounts</router-link></li>
      <li><router-link to="/login">Logout</router-link></li>
    </ul>
  </nav>
  </template>

<script>
  export default {
    name: 'Navbar',
  }
  </script>
  
  <style>
  nav {
    background-color: #333;
  }
  
  nav ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
  }
  
  nav li {
    float: left;
  }
  
  nav a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
  }
  
  nav a:hover {
    background-color: #111;
  }

  nav a.active {
    background-color: #04AA6D;
    color: white;
  }
  </style>
  