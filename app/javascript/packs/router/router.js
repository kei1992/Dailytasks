import Vue from "vue/dist/vue.esm.js";
import VueRouter from "vue-router";
import Index from "../components/index.vue";
import About from "../components/about.vue";
import Contact from "../components/contact.vue";

Vue.use(VueRouter);

export default new VueRouter({
  // HTML5 Historyモードに切り替え
  mode: "history",
  routes: [
    { path: "/", component: Index },
    { path: "/about", component: About },
    { path: "/contact", component: Contact },
  ],
});
