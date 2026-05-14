(() => {
  // ---------- vs Comparison row pairing ----------
  // Hover or tap a row in either column to highlight both that row
  // and its matching pair in the other column. Other rows dim.
  const vsContainer = document.querySelector('.vs');
  if (vsContainer) {
    const allRows = vsContainer.querySelectorAll('[data-vs-pair]');
    const clearHighlight = () => {
      vsContainer.classList.remove('is-focused');
      allRows.forEach(r => r.classList.remove('is-highlight'));
    };
    const focusPair = (pair) => {
      vsContainer.classList.add('is-focused');
      allRows.forEach(r => r.classList.toggle('is-highlight', r.dataset.vsPair === pair));
    };
    allRows.forEach(row => {
      row.addEventListener('mouseenter', () => focusPair(row.dataset.vsPair));
      row.addEventListener('focus', () => focusPair(row.dataset.vsPair));
      row.tabIndex = 0;
    });
    vsContainer.addEventListener('mouseleave', clearHighlight);
    // Click-tap support: tap a row to lock the highlight, tap again to clear
    let lockedPair = null;
    allRows.forEach(row => {
      row.addEventListener('click', () => {
        if (lockedPair === row.dataset.vsPair) {
          lockedPair = null;
          clearHighlight();
        } else {
          lockedPair = row.dataset.vsPair;
          focusPair(lockedPair);
        }
      });
    });
  }

  // ---------- Hero entrance trigger ----------
  // Add .hero-ready to <body> on next frame so CSS transitions kick in.
  // Robust against backgrounded tabs (transitions resume on visibility).
  const triggerHero = () => document.body.classList.add('hero-ready');
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => requestAnimationFrame(triggerHero));
  } else {
    requestAnimationFrame(triggerHero);
  }
  // Belt-and-suspenders: also fire after 1.5s, in case rAF is throttled
  setTimeout(triggerHero, 1500);

  // ---------- Scroll-aware nav ----------
  const nav = document.querySelector('.nav, .header');
  if (nav) {
    const onScroll = () => {
      nav.classList.toggle('scrolled', window.scrollY > 24);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  // ---------- Mobile nav toggle ----------
  const toggle = document.querySelector('.nav-toggle');
  const mobileNav = document.querySelector('.mobile-nav');
  if (toggle && mobileNav) {
    const setOpen = (isOpen) => {
      toggle.setAttribute('aria-expanded', String(isOpen));
      mobileNav.classList.toggle('is-open', isOpen);
      document.body.classList.toggle('nav-open', isOpen);
    };
    toggle.addEventListener('click', () => {
      const open = toggle.getAttribute('aria-expanded') === 'true';
      setOpen(!open);
    });
    mobileNav.querySelectorAll('a').forEach(a => {
      a.addEventListener('click', () => setOpen(false));
    });
    // Close on Escape
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && mobileNav.classList.contains('is-open')) setOpen(false);
    });
  }

  // ---------- Current-page nav highlight ----------
  const path = location.pathname.replace(/\/$/, '') || '/index.html';
  document.querySelectorAll('.nav a, .mobile-nav a').forEach(a => {
    const href = a.getAttribute('href');
    if (!href) return;
    if (
      href === path ||
      (path === '/' && href === 'index.html') ||
      (path.endsWith('/index.html') && href === 'index.html') ||
      path.endsWith('/' + href)
    ) {
      a.setAttribute('aria-current', 'page');
    }
  });

  // ---------- Activate marquee only when scrolled into view ----------
  const marquees = document.querySelectorAll('.marquee');
  if (marquees.length && 'IntersectionObserver' in window) {
    const mObs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        entry.target.classList.toggle('is-active', entry.isIntersecting);
      });
    }, { threshold: 0.1 });
    marquees.forEach(m => mObs.observe(m));
  }

  // ---------- Animated counters [data-counter] ----------
  // Usage: <span data-counter="700000" data-suffix="+">0</span>
  // Big numbers (>=1000) get thousand-separator commas automatically.
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const counters = document.querySelectorAll('[data-counter]');
  const fmt = (value, decimals, target) => {
    const v = value.toFixed(decimals);
    // Insert commas only if the TARGET is >= 1000 (so 25 stays "25", 700000 becomes "700,000")
    if (Math.abs(target) >= 1000) return Number(v).toLocaleString('en-US');
    return v;
  };
  if (counters.length && 'IntersectionObserver' in window) {
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const el = entry.target;
        obs.unobserve(el);
        const target = parseFloat(el.dataset.counter);
        const suffix = el.dataset.suffix || '';
        const prefix = el.dataset.prefix || '';
        const decimals = parseInt(el.dataset.decimals || '0', 10);
        if (reduceMotion || isNaN(target)) {
          el.textContent = prefix + fmt(target, decimals, target) + suffix;
          return;
        }
        const duration = parseInt(el.dataset.duration || '1400', 10);
        const start = performance.now();
        const tick = (now) => {
          const t = Math.min(1, (now - start) / duration);
          // easeOutCubic
          const eased = 1 - Math.pow(1 - t, 3);
          const value = target * eased;
          el.textContent = prefix + fmt(value, decimals, target) + suffix;
          if (t < 1) requestAnimationFrame(tick);
        };
        requestAnimationFrame(tick);
      });
    }, { threshold: 0.4, rootMargin: '0px 0px -10% 0px' });
    counters.forEach(c => obs.observe(c));
  }

  // ---------- Lazy fade-in on image load ----------
  document.querySelectorAll('img[loading="lazy"]').forEach(img => {
    if (img.complete) return;
    img.style.opacity = '0';
    img.style.transition = 'opacity .4s ease';
    img.addEventListener('load', () => { img.style.opacity = '1'; }, { once: true });
  });

  // ---------- WhatsApp floating action button ----------
  if (!document.querySelector('.wa-fab')) {
    const waPhone = '60122362159'; // +6012-236 2159
    const waMsg = encodeURIComponent('Hi AnchorSOL, project enquiry from your website.');
    const a = document.createElement('a');
    a.className = 'wa-fab';
    a.href = `https://wa.me/${waPhone}?text=${waMsg}`;
    a.target = '_blank';
    a.rel = 'noopener';
    a.setAttribute('aria-label', 'Chat with AnchorSOL on WhatsApp');
    a.innerHTML = `
      <span class="wa-fab__pulse" aria-hidden="true"></span>
      <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
        <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413"/>
      </svg>`;
    document.body.appendChild(a);
  }

  // ---------- Apple-grade scroll-reveal ----------
  // Auto-tags major sections with data-reveal then fades them up
  // when they enter the viewport. One-shot, never re-triggers.
  // Disabled when user prefers reduced motion.
  if (!reduceMotion && 'IntersectionObserver' in window) {
    const revealCandidates = document.querySelectorAll(
      'section .sechead, section .secmark, section .sec-h, ' +
      '.benefit-grid > *, .proj-grid > *, .app-grid > *, .compare__col, ' +
      '.spec-card, .stat-card, .step, .kb-grid > *, .trust-strip__chip, ' +
      '.cta-band > *, .pull-quote, .featured-quote, .resource, .post-card, ' +
      '.testimonial, .gallery > *, .kb-toc'
    );
    revealCandidates.forEach((el, i) => {
      if (el.hasAttribute('data-reveal')) return;
      el.setAttribute('data-reveal', '');
      // Stagger items inside the same row/grid
      const stagger = i % 4;
      if (stagger) el.setAttribute('data-reveal-delay', String(stagger));
    });
    const revealObs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-revealed');
          revealObs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.08, rootMargin: '0px 0px -8% 0px' });
    document.querySelectorAll('[data-reveal]').forEach(el => revealObs.observe(el));
  }

  // ---------- Bottom tab bar scroll-spy + auto-center ----------
  // Highlights the tab whose section is closest to viewport center, then
  // smoothly scrolls the tab bar horizontally so the active tab is in view.
  // Also manages a .is-scrollable / .is-at-end class for the edge-fade hint.
  const tabbar = document.querySelector('.tabbar');
  const tabbarScroll = tabbar ? tabbar.querySelector('.tabbar__scroll') : null;
  if (tabbar && tabbarScroll) {
    const hashTabs = new Map();
    tabbar.querySelectorAll('.tabbar__tab').forEach(t => {
      const href = t.getAttribute('href') || '';
      if (href.startsWith('#')) hashTabs.set(href, t);
    });

    // Tag scrollable state so the right-edge fade shows up only when needed
    const updateScrollableHint = () => {
      const isScrollable = tabbarScroll.scrollWidth - tabbarScroll.clientWidth > 4;
      tabbar.classList.toggle('is-scrollable', isScrollable);
      const atEnd = tabbarScroll.scrollLeft + tabbarScroll.clientWidth >= tabbarScroll.scrollWidth - 4;
      tabbar.classList.toggle('is-at-end', atEnd);
    };
    updateScrollableHint();
    tabbarScroll.addEventListener('scroll', updateScrollableHint, { passive: true });
    window.addEventListener('resize', updateScrollableHint, { passive: true });

    if (hashTabs.size && 'IntersectionObserver' in window) {
      const targets = [];
      hashTabs.forEach((tab, hash) => {
        const el = document.querySelector(hash);
        if (el) targets.push({ el, hash, tab });
      });

      if (targets.length) {
        // Centers the active tab in the bar. behavior 'auto' jumps instantly
        // (used after a tap to avoid the bar scrubbing through every tab),
        // 'smooth' eases (used during natural page scroll).
        const centerActiveTab = (tab, behavior) => {
          const tabLeft = tab.offsetLeft;
          const tabWidth = tab.offsetWidth;
          const barWidth = tabbarScroll.clientWidth;
          const targetLeft = Math.max(0, tabLeft + tabWidth / 2 - barWidth / 2);
          tabbarScroll.scrollTo({ left: targetLeft, behavior: behavior || 'smooth' });
        };

        const setActiveHash = (hash, behavior) => {
          hashTabs.forEach((t, h) => {
            const isActive = h === hash;
            t.classList.toggle('is-active', isActive);
            if (isActive) centerActiveTab(t, behavior);
          });
        };

        // When the user taps a tab, suppress scroll-spy entirely until the
        // page has finished smooth-scrolling (no scroll events for 200ms).
        // Also adds .is-tapping to the bar so :hover styles are killed
        // while the bar auto-scrolls past other tabs.
        let suppressed = false;
        let settleTimer = null;
        const onSettled = () => { suppressed = false; tabbar.classList.remove('is-tapping'); };
        hashTabs.forEach((tab, hash) => {
          tab.addEventListener('click', () => {
            suppressed = true;
            tabbar.classList.add('is-tapping');
            setActiveHash(hash, 'auto'); // snap tab into center, no scrubbing
            // Safety release in case scroll never fires (already on section)
            clearTimeout(settleTimer);
            settleTimer = setTimeout(onSettled, 1400);
          });
        });
        // Detect when the page actually finishes scrolling: re-enable
        // scroll-spy 200ms after the last scroll event.
        let endTimer = null;
        window.addEventListener('scroll', () => {
          if (!suppressed) return;
          clearTimeout(endTimer);
          endTimer = setTimeout(() => {
            clearTimeout(settleTimer);
            onSettled();
          }, 200);
        }, { passive: true });

        let lastHash = null;
        const onScroll = () => {
          if (suppressed) return;
          const viewportCenter = window.innerHeight / 2;
          let best = null;
          let bestDist = Infinity;
          for (const t of targets) {
            const r = t.el.getBoundingClientRect();
            if (r.bottom < 0 || r.top > window.innerHeight) continue;
            const sectionCenter = r.top + r.height / 2;
            const dist = Math.abs(sectionCenter - viewportCenter);
            if (dist < bestDist) {
              bestDist = dist;
              best = t;
            }
          }
          if (!best) {
            for (const t of targets) {
              const r = t.el.getBoundingClientRect();
              if (r.bottom > 0 && r.top < window.innerHeight) {
                if (!best || r.top < best.el.getBoundingClientRect().top) best = t;
              }
            }
          }
          if (best && best.hash !== lastHash) {
            lastHash = best.hash;
            setActiveHash(best.hash);
          }
        };

        let scrollTick = false;
        window.addEventListener('scroll', () => {
          if (scrollTick) return;
          scrollTick = true;
          requestAnimationFrame(() => {
            onScroll();
            scrollTick = false;
          });
        }, { passive: true });
        onScroll();
      }
    }

    // On sub-pages, scroll the pre-marked .is-active tab into view on load
    const preActive = tabbar.querySelector('.tabbar__tab.is-active');
    if (preActive && !hashTabs.has(preActive.getAttribute('href'))) {
      requestAnimationFrame(() => {
        const tabLeft = preActive.offsetLeft;
        const tabWidth = preActive.offsetWidth;
        const barWidth = tabbarScroll.clientWidth;
        tabbarScroll.scrollTo({ left: Math.max(0, tabLeft + tabWidth / 2 - barWidth / 2), behavior: 'auto' });
      });
    }
  }

  // ---------- Contact form: geo-toggle wiring ----------
  const rfqForm = document.getElementById('rfqForm');
  if (rfqForm) {
    const subjectField = rfqForm.querySelector('#_subject');
    const phoneInput = rfqForm.querySelector('#phone');
    const phoneHint = rfqForm.querySelector('#phoneHint');
    const radios = rfqForm.querySelectorAll('input[name="country"]');
    const apply = () => {
      const sel = rfqForm.querySelector('input[name="country"]:checked');
      const country = sel ? sel.value : 'MY';
      if (country === 'BD') {
        if (subjectField) subjectField.value = 'New AnchorSOL enquiry, Bangladesh';
        if (phoneInput) phoneInput.placeholder = '+880 1XXX XXX XXX';
        if (phoneHint) phoneHint.textContent = 'Include country code: +880 (Bangladesh)';
      } else {
        if (subjectField) subjectField.value = 'New AnchorSOL enquiry, Malaysia';
        if (phoneInput) phoneInput.placeholder = '+60 12 345 6789';
        if (phoneHint) phoneHint.textContent = 'Include country code: +60 (Malaysia)';
      }
    };
    radios.forEach(r => r.addEventListener('change', apply));
    apply();
  }

  // (The legacy sticky callback bar is removed, the T1-navy <div class="top">
  // top-bar already provides the same live status + HQ contact, so injecting
  // another bar would duplicate it.)

  // ---------- Small ® superscript wrap ----------
  // Walks body text nodes after DOM ready and wraps each ® character in
  // <sup class="reg">®</sup> so it renders small + superscripted.
  // Skips <title>, <meta>, <script>, <style>, <noscript>, <textarea>, <code>,
  // <pre> so titles/JSON-LD/code blocks stay intact.
  const REG_SKIP = new Set(['SCRIPT', 'STYLE', 'NOSCRIPT', 'TITLE', 'TEXTAREA', 'CODE', 'PRE', 'SUP']);
  const wrapRegMark = (root) => {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode: (node) => {
        if (node.nodeValue.indexOf('®') === -1) return NodeFilter.FILTER_REJECT;
        const parent = node.parentNode;
        if (!parent || REG_SKIP.has(parent.tagName)) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    });
    const targets = [];
    let n;
    while ((n = walker.nextNode())) targets.push(n);
    targets.forEach((node) => {
      const parts = node.nodeValue.split('®');
      const frag = document.createDocumentFragment();
      parts.forEach((part, i) => {
        if (part) frag.appendChild(document.createTextNode(part));
        if (i < parts.length - 1) {
          const sup = document.createElement('sup');
          sup.className = 'reg';
          sup.textContent = '®';
          frag.appendChild(sup);
        }
      });
      node.parentNode.replaceChild(frag, node);
    });
  };
  if (document.body) wrapRegMark(document.body);
})();
