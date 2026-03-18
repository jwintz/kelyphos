<script setup lang="ts">
import { withBase } from 'ufo'

const baseURL = useRuntimeConfig().app.baseURL || '/'
const logoSrc = computed(() => withBase('/_raw/logo.png', baseURL))
</script>

<template>
  <NuxtLink to="/" class="logo-link" aria-label="Kelyphos">
    <img
      :src="logoSrc"
      alt="Kelyphos"
      class="logo-img"
    />
    <span class="logo-name">Kelyphos</span>
  </NuxtLink>
</template>

<style scoped>
.logo-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
}

.logo-img {
  height: 28px;
  width: 28px;
  border-radius: 6px;
  object-fit: contain;
}

.logo-name {
  font-weight: 600;
  font-size: 1rem;
  color: var(--ui-text-highlighted);
}
</style>
