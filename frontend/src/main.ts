import { createPinia } from 'pinia'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { supabase } from './boot/supabase' // Import supabase

import './assets/main.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)

// Make supabase available globally
app.config.globalProperties.$supabase = supabase

app.mount('#app')