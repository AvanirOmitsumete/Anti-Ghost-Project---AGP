<template>
  <div class="fixed inset-0 bg-gray-800 bg-opacity-75 flex items-center justify-center z-50">
    <img src="https://via.placeholder.com/96x96/000000/FFFFFF?text=CROC" alt="Loading" class="animate-spin-slow w-24 h-24">
  </div>
</template>

<style>
.animate-spin-slow {
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
