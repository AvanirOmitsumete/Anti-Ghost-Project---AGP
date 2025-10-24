<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
  images: {
    type: Array as () => string[],
    required: true,
  },
});

const currentIndex = ref(0);

let intervalId: any = null;

const nextImage = () => {
  currentIndex.value = (currentIndex.value + 1) % props.images.length;
};

onMounted(() => {
  intervalId = setInterval(nextImage, 3000);
});

onUnmounted(() => {
  clearInterval(intervalId);
});
</script>

<template>
  <div class="carousel">
    <img :src="images[currentIndex]" alt="Carousel Image" />
  </div>
</template>

<style scoped>
.carousel {
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

.carousel img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>