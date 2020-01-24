/* eslint no-console: 0 */

// yarn add vue-turbolinks

// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

// Vue.use(TurbolinksAdapter)

// document.addEventListener('turbolinks:load', () => {
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    components: { App }
  })
});
