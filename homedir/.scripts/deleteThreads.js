(() => {
  const waitForElement = (selector, interval = 1000) => {
    return new Promise((resolve) => {
      const checker = setInterval(() => {
        const element = document.querySelector(selector);

        if (element) {
          clearInterval(checker);
          resolve(element);
        }
      }, interval);
    });
  };

  const delay = (ms) => {
    return new Promise((resolve) => setTimeout(resolve, ms));
  };

  const processElement = async (el) => {
    // Scroll the element into view
    el.scrollIntoView({ behavior: "smooth", block: "center" });

    // 1. Click menu button
    const items = el.querySelectorAll("div.x9f619 > div.x1a2a7pz");
    const reply = items[items.length - 1];
    const btn = reply.querySelector('div.xpvyfi4 div.x1i10hfl[role="button"]');
    btn.click();

    // 2. Click on delete item button
    const dialog = await waitForElement('div.x1n2onr6[role="dialog"]');
    const btnWrap = dialog.querySelectorAll("div.x1q05qs2")[1];
    const deleteBtn = btnWrap.querySelector('div.x1i10hfl[role="button"]');
    deleteBtn.click();

    // 3. Click to confirm deletion
    const confirmDialog = await waitForElement(
      'div.x1o1ewxj[aria-hidden="false"]'
    );
    const confBtnWrap = confirmDialog.querySelector(
      "div.x6s0dn4 > div.x6bh95i"
    );
    const confDeleteBtn = confBtnWrap.querySelector(
      'div.x1i10hfl.x12v9rci[role="button"]'
    );
    confDeleteBtn.click();
  };

  const processElementsSequentially = async () => {
    const elements = document.querySelectorAll("div.x1c1b4dv > div.x78zum5");

    for (let i = 0; i < elements.length; i++) {
      await processElement(elements[i]);
      await delay(3000);
    }
  };

  processElementsSequentially();
})();
