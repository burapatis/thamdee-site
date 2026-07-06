/* Thamdee — main.js (no dependencies, ~1 KB) */
(function () {
  "use strict";

  /* เมนูมือถือ (accessible toggle) */
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.getElementById("site-nav");
  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var open = nav.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    /* ปิดเมนูเมื่อเลือกลิงก์ หรือกด Escape */
    nav.addEventListener("click", function (e) {
      if (e.target.closest("a")) {
        nav.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && nav.classList.contains("open")) {
        nav.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
        toggle.focus();
      }
    });
  }

  /* Reveal on scroll — ทำงานเฉพาะเมื่อผู้ใช้ไม่ได้ตั้งค่า reduced motion */
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var items = document.querySelectorAll(".reveal");
  if (!reduced && "IntersectionObserver" in window && items.length) {
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("in");
            io.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px 0px -8% 0px", threshold: 0.1 }
    );
    items.forEach(function (el) { io.observe(el); });
  } else {
    items.forEach(function (el) { el.classList.add("in"); });
  }

  /* ปุ่มกลับขึ้นด้านบน — แสดงหลัง scroll เกิน 2 จอ */
  var backToTop = document.getElementById("back-to-top");
  if (backToTop) {
    var scrollThreshold = window.innerHeight * 2;
    var reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    function toggleBackToTop() {
      if (window.scrollY > scrollThreshold) {
        backToTop.hidden = false;
      } else {
        backToTop.hidden = true;
      }
    }

    backToTop.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: reducedMotion ? "auto" : "smooth" });
    });

    window.addEventListener("scroll", toggleBackToTop, { passive: true });
    window.addEventListener("resize", function () {
      scrollThreshold = window.innerHeight * 2;
      toggleBackToTop();
    }, { passive: true });
    toggleBackToTop();
  }
})();
