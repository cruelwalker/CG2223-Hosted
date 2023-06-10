<template>
  <h3>Welcome {{ getUsername() }}</h3>
  <navbar></navbar>
</template>

<script>
import Navbar from './NavBar.vue'
import { GET_USERNAME } from "../store/storeconstants";
export default {
  name: 'WelcomeVIew',
  components: {
    navbar: Navbar
  },
  data() {
    return {
    }
  },
  methods: {
    getUsername() {
      return this.$store.getters[`auth/${GET_USERNAME}`]
    }
  }
}
</script>