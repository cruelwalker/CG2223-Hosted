import { createWebHistory, createRouter } from "vue-router";

const routes = [
  {
    path: "/login",
    component: () => import('../components/LoginView.vue'),
  },
  {
    path: "/home",
    component: () => import('../components/WelcomeView.vue'),
  },
  {
    path: "/transactions",
    component: () => import('../components/Transactions.vue')
  },
  {
    path: "/accounts",
    component: () => import('../components/Accounts.vue')
  },
  {
    path: "/users",
    component: () => import('../components/Users.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes: routes,
  linkActiveClass: 'active'
})



export default router;